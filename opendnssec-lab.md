# OpenDNSSEC Lab

## Editing the OpenDNSSEC Configuration


The configuration needs to be adjusted to better fit this setup.

1. Open the configuration for editing.

        > sudo vim /etc/opendnssec/conf.xml

    The repository list was adjusted in a previous lab.

2. We will be rolling keys in a rapid pace., thus need to lower the Enforcer Interval.

    File contents:

        <Interval>PT120S</Interval>

2. There is only one core on the lab machine and the performance was not increased by using multiple threads. For this lab, will then only use one thread for the Signer in OpenDNSSEC.

        <WorkerThreads>1</WorkerThreads>
        <SignerThreads>1</SignerThreads>

3. Save the file and exit.




## Creating a Policy

We will use the provided KASP policy “lab". It uses very low values on the timing parameters, just so that key rollovers will go faster in this lab environment.

1. Open the kasp.xml file.

        > sudo vim /etc/opendnssec/kasp.xml

2. The policy we’re going to use is called "lab".

        <Policy name="lab">

3. Signatures are set to have a short lifetime.

        <Signatures>
          <Resign>PT10M</Resign>
          <Refresh>PT30M</Refresh>
          <Validity>
            <Default>PT1H</Default>
            <Denial>PT1H</Denial>
          </Validity>
          <Jitter>PT2M</Jitter>
          <InceptionOffset>PT3600S</InceptionOffset>
        </Signatures>

4. The TTL and safety margins for the keys are also lower.

        <TTL>PT300S</TTL>
        <RetireSafety>PT360S</RetireSafety>
        <PublishSafety>PT360S</PublishSafety>

5. Set the KSK lifetime to 3 hours and the ZSK to 2 hours.

        <KSK>
          <Algorithm length="2048">8</Algorithm>
          <Lifetime>PT3H</Lifetime>
          <Repository>SoftHSM</Repository>
        </KSK>

        <ZSK>
          <Algorithm length="1024">8</Algorithm>
          <Lifetime>PT2H</Lifetime>
          <Repository>SoftHSM</Repository>
        </ZSK>

6. The values for the SOA can be found in the zone we created earlier. We will use a unix timestamp as the serial number.

        <Zone>
          <PropagationDelay>PT300S</PropagationDelay>
          <SOA>
            <TTL>PT60S</TTL>
            <Minimum>PT60S</Minimum>
            <Serial>unixtime</Serial>
          </SOA>
        </Zone>

7. And these values are from the parent zone.

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

        > sudo ods-kaspcheck

10. Setup the KASP database.

        > sudo ods-ksmutil setup




## Adding the Zone

Zones can be added in two ways, either by command line or by editing the zonelist.xml. We will edit the zone list in this lab.

1. Open the zonelist.xml file.

        > sudo vim /etc/opendnssec/zonelist.xml

2. Uncomment the example zone.

3. Change the name of the zone and the paths to the zone files.

        <Zone name="groupX.odslab.se">
          <Policy>lab</Policy>
          <SignerConfiguration>/var/opendnssec/signconf/groupX.odslab.se.xml</SignerConfiguration>
          <Adapters>
            <Input>
              <Adapter type="File">/var/cache/bind/zones/unsigned/groupX.odslab.se</Adapter>
            </Input>
            <Output>
              <Adapter type="File">/var/cache/bind/zones/signed/groupX.odslab.se</Adapter>
            </Output>
          </Adapters>
        </Zone>

4. Save and exit.

5. Update the Enforcer database. You will get a warning that the Enforcer could not be notified. That’s OK -- we haven’t started it yet and will do that later.

        > sudo ods-ksmutil update zonelist



## Signing the Zone

It is now time to sign the zone!

1. Start OpenDNSSEC

        > sudo ods-control start

2. Check the syslog to see that the two daemons started, that the signconf was generated, and that Signer engine signed the zone.

        > tail -n 100 /var/log/syslog

3. Have a look on the signconf.

        > less /var/opendnssec/signconf/groupX.odslab.se.xml

4. Have a look on the signed zone file.

        > less /var/cache/bind/zones/signed/groupX.odslab.se



## Publish the Signed Zone

The signed zone is now just a file on disc. We have to tell BIND to use
this one instead of the unsigned zone file.

1. Edit the BIND configuration and change the path to the zone file

        > sudo vim /etc/bind/named.conf.local

    File contents:

        zone "groupX.odslab.se" {
            type master;
            file "zones/signed/groupX.odslab.se";
        };

2. Reload the configuration.

        > sudo rndc reload

3. Tell OpenDNSSEC to notify BIND every time the zone has been signed.

        > sudo vim /etc/opendnssec/conf.xml

    Update:

        <NotifyCommand>/usr/sbin/rndc reload %zone</NotifyCommand>

4. Restart the Signer Engine.

        > sudo ods-signer stop
        > sudo ods-signer start

5. Verify that the zone is signed on the resolver machine. Notice that the AD-flag is not set.

        > dig +dnssec www.groupX.odslab.se

6. Verify that DNSSEC records are correctly served for this zone.

        > dig @127.0.0.1 groupX.odslab.se SOA +dnssec
