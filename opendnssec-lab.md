# OpenDNSSEC Lab

## Editing the OpenDNSSEC Configuration


The configuration needs to be adjusted to better fit this setup.

1. Open the configuration for editing:

        sudo vim /etc/opendnssec/conf.xml

    The repository list was adjusted in a [previous lab](hsm-testing.md).

2. We will be rolling keys in a rapid pace, burning up a lot of keys in a year. The default setting is to pre-generate keys for a year, which will take a long time with so many keys.  So we want to decrease this by modifying the setting AutomaticKeyGenerationPeriod to:

        <AutomaticKeyGenerationPeriod>P2D</AutomaticKeyGenerationPeriod>

3. There is only one core on the lab machine and the performance was not increased by using multiple threads. For this lab, will then only use one thread for the Signer in OpenDNSSEC.

        <WorkerThreads>1</WorkerThreads>
        <SignerThreads>1</SignerThreads>

4. Save the file and exit.

5. Setup the KASP database:

        sudo ods-enforcer-db-setup

    And answer yes.

## Creating a Policy

We will use the provided KASP policy "lab". It uses very low values on the timing parameters, just so that key rollovers will go faster in this lab environment.

1. Open the kasp.xml file:

        sudo vim /etc/opendnssec/kasp.xml

2. The policy we're going to use is called "lab", it is already defined beginning at the following statement:

        <Policy name="lab">

3. Signatures are set to have a short lifetime:

        <Signatures>
          <Resign>PT10M</Resign>
          <Refresh>PT30M</Refresh>
          <Validity>
            <Default>PT1H</Default>
            <Denial>PT1H</Denial>
          </Validity>
          <Jitter>PT2M</Jitter>
          <InceptionOffset>PT3600S</InceptionOffset>
          <MaxZoneTTL>PT300S</MaxZoneTTL>
        </Signatures>

4. The TTL and safety margins for the keys are also lower:

        <TTL>PT300S</TTL>
        <RetireSafety>PT360S</RetireSafety>
        <PublishSafety>PT360S</PublishSafety>

5. Set the KSK lifetime to 2 hours and the ZSK to 1 hours. Also make sure both the KSK and the ZSK are 2048-bit RSA/SHA-256 (algorithm 8):

        <KSK>
          <Algorithm length="2048">8</Algorithm>
          <Lifetime>PT2H</Lifetime>
          <Repository>SoftHSM</Repository>
        </KSK>

        <ZSK>
          <Algorithm length="2048">8</Algorithm>
          <Lifetime>PT1H</Lifetime>
          <Repository>SoftHSM</Repository>
        </ZSK>

6. The values for the SOA can be found in the zone we created earlier. We will use a unix timestamp as the serial number:

        <Zone>
          <PropagationDelay>PT300S</PropagationDelay>
          <SOA>
            <TTL>PT60S</TTL>
            <Minimum>PT60S</Minimum>
            <Serial>unixtime</Serial>
          </SOA>
        </Zone>

7. And these values are from the parent zone:

        <Parent>
          <PropagationDelay>PT5M</PropagationDelay>
          <DS>
            <TTL>PT1M</TTL>
          </DS>
          <SOA>
            <TTL>PT1M</TTL>
            <Minimum>PT1M</Minimum>
          </SOA>
        </Parent>

8. Save and exit.

9. Verify that the KASP looks ok. The database has not been created yet, you will thus get a warning about this.

        sudo ods-kaspcheck

   OpenDNSSEC will warn you that when you use Y (for Year) in duration fields, it is interpreted as 365 days.

## Start OpenDNSSEC

1. At this point we should start the OpenDNSSEC daemons.  Both enforcer and signer daemons are started using:

        sudo ods-control start

   The creating of /var/run/opendnssec is only necessary when having rebooted the machine.  This should be handled by the package management.

2. Be sure to monitor the system log for any error conditions, some problems can only be reported once the daemons are already in the background.

        tail /var/log/syslog

3. Import the initial KASP in OpenDNSSEC:

        sudo ods-enforcer policy import

## Add and sign the Zone

Zones can be added in two ways, either by command line or by editing the zonelist.xml.  The command line is the one for now.

1. Add the zone to the enforcer which will in turn inform the zone to be signed:

        sudo ods-enforcer zone add --zone groupX.odslab.se --policy lab \
                    --input /var/cache/bind/zones/unsigned/groupX.odslab.se \
                    --output /var/cache/bind/zones/signed/groupX.odslab.se

2. Check the syslog to see that the two daemons started, that the signconf was generated, and that Signer engine signed the zone:

        tail -n 100 /var/log/syslog

3. Have a look on the signconf:

        less /var/opendnssec/signconf/group*.odslab.se.xml

4. Have a look on the signed zone file:

        less /var/cache/bind/zones/signed/group*.odslab.se

## Publish the Signed Zone

The signed zone is now just a file on disc. We have to tell BIND to use this one instead of the unsigned zone file.

1. Edit the BIND configuration and change the path to the zone file:

        sudo vim /etc/bind/named.conf.local

    File contents:

        zone "groupX.odslab.se" {
            type master;
            file "zones/signed/groupX.odslab.se";
        };

2. Reload the configuration:

        sudo rndc reload

3. Tell OpenDNSSEC to notify BIND every time the zone has been signed:

        sudo vim /etc/opendnssec/conf.xml

    Update:

        <NotifyCommand>/usr/sbin/rndc reload %zone</NotifyCommand>

4. Restart the Signer Engine:

        sudo ods-signer stop
        sudo ods-signer start

5. Verify that the zone is signed on the resolver machine. Notice that the AD-flag is not set:

        dig +dnssec www.groupX.odslab.se

6. Verify that DNSSEC records are correctly served for this zone:

        dig @127.0.0.1 groupX.odslab.se SOA +dnssec




## Publishing the DS RR

The zone is now signed and we have verified that DNSSEC is working. It is then time to publish the DS RR.

1. Wait until the KSK is ready to be published in the parent zone:

        sudo ods-enforcer key list -v

2. Show the DS RRs that we are about to publish. Notice that they share the key tag with the KSK:

        sudo ods-enforcer key export --zone groupX.odslab.se --ds

3. Ask your teacher to update the DS in the parent zone.

4. Wait until the DS has been uploaded. Check the DS with the following command:

        dig @ns.odslab.se groupX.odslab.se DS

5. It is now safe to tell the Enforcer that it has been seen. Replace KEYTAG with the keytag of your current KSK.

        sudo ods-enforcer key ds-seen --zone groupX.odslab.se --keytag KEYTAG

6. The KSK is now considered as active. Check the key list with the following command:

        sudo ods-enforcer key list

7. Verify that we can query the zone from the *resolver* machine.
   The AD-flag should be set:

        dig +dnssec www.groupX.odslab.se


## KSK Rollover

The KSK rollover is usually done at the end of its lifetime. But a key rollover can be forced before that by issuing the rollover command.

1. Check how long time it is left before the KSK should be rolled:

        sudo ods-enforcer key list

2. We will now force a key rollover. If a key rollover has been initiated then this command will be ignored:

        sudo ods-enforcer key rollover --zone groupX.odslab.se --keytype KSK

3. Wait until the new KSK is ready. It should be maximum 10 minutes. If it is longer than that, then you probably missed to adjust a value in your KASP. Update the KASP to match the LAB policy given here in the document.

        sudo ods-enforcer key list -v

4. The DS RRs can be exported to the teacher once the new KSK is ready. Ask the teacher to upload it.

        sudo ods-enforcer key export --ds --zone groupX.odslab.se > groupX.ds

5. Wait until the DS has been uploaded.

        dig @ns.odslab.se groupX.odslab.se DS

6. It is now safe to tell the Enforcer that it has been seen:

        sudo ods-enforcer key ds-seen --zone groupX.odslab.se --keytag KEYTAG

7. The new KSK is now considered as active.

        sudo ods-enforcer key list

8. Verify that we can query the zone from the *resolver* machine.

        sudo rndc flush
        dig +dnssec www.groupX.odslab.se



## Adding a New Policy

We will add a new policy named "lab2".  It will use RSASHA512 with NSEC3 instead of the default RSASHA256 with NSEC.

1. Open the kasp.xml file.

        sudo vim /etc/opendnssec/kasp.xml

2. Copy the policy named "lab".

3. Rename the policy to "lab2":

        <Policy name="lab2">

4. Change from NSEC to NSEC3:

        <Denial>
          <NSEC3>
            <Resalt>P100D</Resalt>
            <Hash>
              <Algorithm>1</Algorithm>
              <Iterations>5</Iterations>
              <Salt length="8"/>
            </Hash>
          </NSEC3>
        </Denial>

5. Change KSK and ZSK algorithm to RSASHA512. You can find the algorithm numbers at http://www.iana.org/assignments/dns-sec-alg-numbers/.

6. Save and exit.

7. Verify that the KASP looks OK:

        sudo ods-kaspcheck

8. Load the new policy into OpenDNSSEC:

        sudo ods-enforcer policy import


## Adding a New Zone

A second zone will be added by using the command line interface.

1. Make a copy of your current zone. Also adjust the $ORIGIN in the copy.

        cd /var/cache/bind/zones/unsigned/
        sudo cp groupX.odslab.se sub.groupX.odslab.se
        sudo vi sub.groupX.odslab.se

2. Add it to OpenDNSSEC. You will get an error from *rndc*, because we have not configured BIND to know about the sub-zone. This will be done later.

        sudo ods-enforcer zone add --zone sub.groupX.odslab.se \
                 --policy lab2 \
                 --input /var/cache/bind/zones/unsigned/sub.groupX.odslab.se \
                 --output /var/cache/bind/zones/signed/sub.groupX.odslab.se

3. Have a look in syslog and see that the zone gets signed and that BIND does
   not know about the zone.

        sudo tail /var/log/syslog

4.  Add the zone BIND.

        sudo vim /etc/bind/named.conf.local
        sudo rndc reload

This zone is present on the same server as your original parent zone. Any DNS query on it will thus get an answer, but a delegation to it should be added in the parent zone. This will be fixed in the next lab.


## Updating the Zone Content

We need to create a delegation to the zone that we just created. And also make sure that include the DS RRs.

1. Wait until the KSK is ready in the new zone.

        sudo ods-enforcer key list

2. Export the DS for the zone.

        sudo ods-enforcer key export --zone sub.groupX.odslab.se --ds

3. Add these DS records and create a delegation to the zone. Remember to remove the TTL from the DS RRs.

        sudo vim /var/cache/bind/zones/unsigned/groupX.odslab.se

        sub IN NS nsX.odslab.se.
        sub IN DS ...

4. Signal OpenDNSSEC to read the zone content again.

        sudo ods-signer sign groupX.odslab.se

5. Go the *resolver* and query for the DS.

        dig sub.groupX.odslab.se DS

6.  Tell OpenDNSSEC that the DS has been seen.

        sudo ods-enforcer key ds-seen \
                               --zone sub.groupX.odslab.se \
                               --keytag KEYTAG


## Zone Transfers

OpenDNSSEC may also be fetch unsigned zones and/or serve signed zones using its built in zone transfer server.

In this lab we will set up OpenDNSSEC for outbound zone transfers protected with TSIG. We will also configure our local BIND authoritative name server to fetch the signed zone using zone transfer instead of reading it from a file on disk.

1. Generate a TSIG new base64 encoded random secret using the following command:

        openssl rand -base64 32

2. Update the adapter configuration file with the new TSIG secret.

        sudo vim /etc/opendnssec/addns.xml

    File contents:

        <TSIG>
          <Name>tsig.groupX.odslab.se</Name>
          <Algorithm>hmac-sha256</Algorithm>
          <Secret>SECRET</Secret>
        </TSIG>

    We also need to enable outbound zone transfer for our nameserver using the TSIG secret.

         <Outbound>
           <ProvideTransfer>
             <Peer>
               <Prefix>127.0.0.1</Prefix>
               <Key>tsig.groupX.odslab.se</Key>
             </Peer>
           </ProvideTransfer>
           <Notify>
             <Remote>
               <Address>127.0.0.1</Address>
             </Remote>
           </Notify>
         </Outbound>

3. We also need to enable the listener in the main configuration file. As we already have a nameserver listening on port 53, we use a different port (5353) in this lab.

        sudo vim /etc/opendnssec/conf.xml

    File contents:

        <Listener>
          <Interface><Port>5353</Port></Interface>
        </Listener>

4. Almost done, time to update the zone list and select DNS as the output adapter.  For this we export the zonelist to get an up-to-date copy, modify the entry for groupX.odslab.se and import it back again.

        sudo ods-enforcer zonelist export
        sudo vim /etc/opendnssec/zonelist.xml

        <Output>
          <Adapter type="DNS">/etc/opendnssec/addns.xml</Adapter>
        </Output>

5. Reimport the zonelist and restart the Signer Engine.

        sudo ods-enforcer zonelist import
        sudo ods-signer stop
        sudo ods-signer start

6. Check that OpenDNSSEC is listening on port 5353.

        sudo netstat -tulpan | grep :5353

7. Use dig to verify that zone transfer works as expected.

        dig @127.0.0.1 -p 5353 \
          -y hmac-sha256:tsig.groupX.odslab.se:SECRET \
          groupX.odslab.se AXFR

8.  Update the name server configuration to fetch the zone via zone transfer:

        sudo install -d -o bind -g bind /var/cache/bind/zones/slave
        sudo vim /etc/bind/named.conf.local

    File contents:

         key tsig.groupX.odslab.se. {
             algorithm hmac-sha256;
             secret "replace with secret generated above";
         };
         
         masters opendnssec {
             127.0.0.1 port 5353 key tsig.groupX.odslab.se.;
         };
         
         zone "groupX.odslab.se" {
             type slave;
             masters { opendnssec; };
             file "zones/slave/groupX.odslab.se";
         };

    That was a massive piece of configuration! You can always check your configuration for syntax errors using the following command:

        named-checkconf

9.  Finally, restart BIND:

        sudo rndc reload

10.  You should also verify that the zone is served by BIND:

        dig +dnssec @127.0.0.1 groupX.odslab.se SOA


---
Next Section: [Testing](testing.md)
