# Setup a Secure Resolver using BIND

The purpose of the lab is to setup the resolver on the first server. You
should install *either* BIND or Unbound -- not both.

1.  Connect to the server (resolverX.odslab.se) by using SSH or PuTTY.
2.  Change the host name.

        > sudo hostname resolverX.odslab.se

```comment
Why is this necessary?  It looks the same name as the machine name
the people log into, i.e. there is no change.
```

3.  Logout and login to get an updated command prompt.
4.  Install BIND as the resolver.

        > sudo apt-get update
        > sudo apt-get upgrade
        > sudo apt-get install bind9

```comment
Effectively all operations are done as root.  People could also
sudo su - to root immediately.  This is fine, but it is good to
mention in the course that it is also possible to run opendnssec
as normal user and/or have it drop priviledges.  With previous
version, using ods-ksmutil you would have the problem that it
would always need to run with root priviledges, but with
ods-enforcer this is no longer the case.
```

5.  Change the configuration in BIND so that it only listens on
    the localhost.

        > sudo vim /etc/bind/named.conf.options

    File contents:

        options {
            dnssec-validation auto;
            listen-on-v6 { ::1; };
            listen-on { 127.0.0.1; };
        };

6.  Configure the Ubuntu BIND9 configuration to update resolv.conf

        > sudo vim /etc/default/bind9

    File contents:

        RESOLVCONF=yes

```comment
This does not in itself cause the /etc/resolv.conf to be regeneraed, not
even after a reload. This would require a "service bind9 restart" or, also
possible, perform dig commands with @localhost argument.
```

7.  Restart BIND9

        > service bind9 restart

8.  Verify by using dig. Notice that the AD-flag is set.

        > dig +dnssec www.opendnssec.org

```comment
Not for this course, but I'l like to see if we can use drill more.
```

9.  Also try resolving a domain where DNSSEC is broken.

        > dig www.trasigdnssec.se

    But we can see that in fact the domain does contain the information
    if we bypass the DNSSEC validation:

        > dig +cd www.trasigdnssec.se
