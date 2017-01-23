# Publish unsigned zone using BIND

1.  Install an authoritative nameserver:

        sudo apt-get install bind9

2.  Change its configuration to make sure its DNSSEC aware:

        sudo vim /etc/bind/named.conf.options

    Make sure the following line is added in the options section:

        dnssec-enable yes;

3.  Create some directories:

        sudo mkdir /var/cache/bind/zones
        sudo mkdir /var/cache/bind/zones/unsigned
        sudo mkdir /var/cache/bind/zones/signed

4.  Create a zone named after your group:

        sudo vim /var/cache/bind/zones/unsigned/groupX.odslab.se

    File contents:

        $ORIGIN groupX.odslab.se.
        $TTL 60
        @ IN SOA nsX.odslab.se. test.odslab.se. (
                 1    ; serial
                 360  ; refresh (6 minutes)
                 360  ; retry (6 minutes)
                 1800 ; expire (30 minutes)
                 60   ; minimum (1 minute)
                 )
        @   IN NS nsX.odslab.se.
        www IN CNAME nsX.odslab.se.

5.  Add the zone to BIND:

        sudo vim /etc/bind/named.conf.local

    File contents:

        zone "groupX.odslab.se" {
            type master;
            file "zones/unsigned/groupX.odslab.se";
        };

6. Reload the server:

        sudo rndc reload

7.  Try resolving the information from the resolver:

        dig groupX.odslab.se SOA
