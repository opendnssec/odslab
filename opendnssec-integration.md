# Integration

There are three areas to think of when integrating OpenDNSSEC with your environment.

- Adding / removing zones
- Zone distribution
- Sending the public key to the parent zone

The first two have been covered in previous labs. This lab will cover the third area by using a simple script.

1. Create a simple script:

        sudo vim /var/opendnssec/dnskey.pl

    File contents:

        #!/usr/bin/perl
        my $fh;
        open($fh, '>>', "/var/opendnssec/dnskey.txt");
        print $fh <STDIN>;
        close $fh;
        exit(0);

2. Make it executable:

        sudo chmod +x /var/opendnssec/dnskey.pl

3. Configure OpenDNSSEC to run this script:

        sudo vim /etc/opendnssec/conf.xml

    File contents:

        <Enforcer>
            <DelegationSignerSubmitCommand>/var/opendnssec/dnskey.pl</DelegationSignerSubmitCommand>
        </Enforcer>

4. Restart the Enforcer:

        sudo ods-enforcer stop
        sudo ods-enforcer start

5. Enforce a key rollover:

        sudo ods-enforcer key rollover \
                           --zone sub.groupX.odslab.se \
                           --keytype KSK

6. You will get a DNSKEY in your file once the new KSK is ready:

        sudo ods-enforcer key list --zone sub.groupX.odslab.se
