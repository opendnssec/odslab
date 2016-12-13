# Install OpenDNSSEC

This lab will prepare the second server by installing the latest software.

1.  Connect to the server (nsX.odslab.se) by using SSH or PuTTY.
2.  Change the host name.

        > sudo hostname nsX.odslab.se

3.  Login and logout to get an updated command prompt.
4.  Start by installing the build tools. Also install dnsutils
    for dig(1).

        > sudo apt-get update
        > sudo apt-get upgrade
        > sudo apt-get install build-essential dnsutils

5.  Also install an authoritative nameserver.

        > sudo apt-get install bind9

6.  Continue to install the DNS-library used for parsing and handling the DNS data.

        > sudo apt-get install libssl-dev libldns-dev

7.  We also want to use an HSM and we are going to use SoftHSM.

        > sudo apt-get install softhsm

8.  Install OpenDNSSEC. The version number to use will be provided by your teacher.

        > sudo apt-get install libxml2-dev libxml2-utils libsqlite3-dev sqlite3
        > wget http://dist.opendnssec.org/source/opendnssec-VERSION.tar.gz
        > tar -xzf opendnssec-VERSION.tar.gz
        > cd opendnssec-VERSION
        > mkdir obj; cd obj
        > ../configure
        > make && sudo make install
