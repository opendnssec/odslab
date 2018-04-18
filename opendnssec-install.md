# Install OpenDNSSEC

This lab will prepare the second server by installing the latest software. Although there are binary packages available for many systems, we will compile the latest version from source code in this lab excercise in order to better understand the dependencies and the build process.

1.  Connect to the server (nsX.odslab.se) by using SSH or PuTTY.

2.  Change the host name:

        sudo hostnamectl set-hostname nsX.odslab.se

3.  Logout and login to get an updated command prompt.

4.  Upgrade base operating system:

        sudo apt-get update && sudo apt-get upgrade -y

5.  Installing the build tools:

        sudo apt-get install -y build-essential

6.  Also install a separate authoritative nameserver. For many deployment scenarios one can use OpenDNSSEC only, but in this exercise we'll use BIND 9 as a standalone authoritative nameserver.

        sudo apt-get install -y bind9

7.  We want to use an HSM and we are going to use SoftHSM:

        sudo apt-get install -y softhsm2

8.  Continue to install some prerequisites to be able to compile OpenDNSSEC:

        sudo apt-get install -y libssl-dev libldns-dev \
                                libxml2-dev libxml2-utils \
                                libsqlite3-dev sqlite3

9.  Install OpenDNSSEC. The version number to use will be provided by your teacher:

        wget https://dist.opendnssec.org/source/opendnssec-VERSION.tar.gz
        tar -xzf opendnssec-VERSION.tar.gz
        cd opendnssec-VERSION
        ./configure
        make
        sudo make install


---
Next Section: [SoftHSM](softhsm.md)
