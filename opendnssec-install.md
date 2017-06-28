# Install OpenDNSSEC

This lab will prepare the second server by installing the latest software. Although there are binary packages available for many systems, we will compile the latest version from source code in this lab excercise in order to better understand the dependencies and the build process.

1.  Connect to the server (nsX.odslab.se) by using SSH or PuTTY.
2.  Change the host name:

        sudo hostname nsX.odslab.se

3.  Logout and login to get an updated command prompt.
4.  Start by installing the build tools:

        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install build-essential

5.  Also install a separate authoritative nameserver. For many deployment scenarios one can use OpenDNSSEC, but in this exercise we'll use BIND 9 as a standalone authoritative nameserver.

        sudo apt-get install bind9

6.  We want to use an HSM and we are going to use SoftHSM:

        sudo apt-get install softhsm2

7.  Continue to install some prerequisites to be able to compile OpenDNSSEC:

        sudo apt-get install libssl-dev libldns-dev \
                             libxml2-dev libxml2-utils \
                             libsqlite3-dev sqlite3

8.  Install OpenDNSSEC. The version number to use will be provided by your teacher:

        wget http://dist.opendnssec.org/source/opendnssec-VERSION.tar.gz
        tar -xzf opendnssec-VERSION.tar.gz
        cd opendnssec-VERSION
        ./configure
        make
        sudo make install

Next Section: [SoftHSM](softhsm.md)
