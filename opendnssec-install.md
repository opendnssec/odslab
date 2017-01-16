# Install OpenDNSSEC

This lab will prepare the second server by installing the latest software.

```comment
Perhaps comment on why to compile from source in this lab excercise.
```

1.  Connect to the server (nsX.odslab.se) by using SSH or PuTTY.
2.  Change the host name.

        > sudo hostname nsX.odslab.se

```comment
Why do this?  It isn't already set?  We could just do this for them
as this is really just preparation of the machine itself.
```

3.  Logout and login to get an updated command prompt.
4.  Start by installing the build tools.

        > sudo apt-get update
        > sudo apt-get upgrade
        > sudo apt-get install build-essential

```comment
Package dnsutils is already included in bind9 package.  Unfortunate we have
to use bind9 here, NSD would have been nice.  We could also use drill in
stead of dig.
I think update and upgrade should be pre-prepaired.  Installing the
build-essential is more part of the pre-requisites for compiling OpenDNSSEC.
This means that this item could be dropped.
```

5.  Also install an authoritative nameserver.

        > sudo apt-get install bind9

```comment
Should explain why.  I could imagine we later split this in first using
OpenDNSSEC file-based, and later switch to XFR adapters.
```

6.  We want to use an HSM and we are going to use SoftHSM.

        > sudo apt-get install softhsm
7.  Continue to install some prerequisites to be able to compile OpenDNSSEC

        > sudo apt-get install build-essential libssl-dev libldns-dev
        > sudo apt-get install libxml2-dev libxml2-utils libsqlite3-dev sqlite3

8.  Install OpenDNSSEC. The version number to use will be provided by your teacher.

        > wget http://dist.opendnssec.org/source/opendnssec-VERSION.tar.gz
        > tar -xzf opendnssec-VERSION.tar.gz
        > cd opendnssec-VERSION
        > ./configure
        > make
        > sudo make install
