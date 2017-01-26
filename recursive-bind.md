# Setup a Secure Resolver using BIND

The purpose of the lab is to setup the resolver on the first server. You
should install *either* BIND or Unbound -- not both.

1.  Connect to the server (resolverX.odslab.se) by using SSH or PuTTY.
2.  Change the host name.

        sudo hostname resolverX.odslab.se

3.  Logout and login to get an updated command prompt.
4.  Install BIND as the resolver.

        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install bind9

5.  Change the configuration in BIND so that it only listens on
    the localhost.

        sudo vim /etc/bind/named.conf.options

    File contents:

        options {
            dnssec-validation auto;
            listen-on-v6 { ::1; };
            listen-on { 127.0.0.1; };
        };

6.  Instruct the operating system to use the local nameserver:

        sudo vim /etc/resolv.conf

    Change the nameserver line into:

        nameserver 127.0.0.1

7.  Restart BIND9

        sudo systemctl restart bind9

8.  Verify by using dig. Notice that the AD-flag is set.

        dig +dnssec www.opendnssec.org

9.  Also try resolving a domain where DNSSEC is broken.

        dig www.trasigdnssec.se

    But we can see that in fact the domain does contain the information
    if we bypass the DNSSEC validation:

        dig +cd www.trasigdnssec.se
