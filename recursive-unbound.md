# Setup a Secure Resolver using Unbound

The purpose of the lab is to setup the resolver on the first server. You should install *either* BIND or Unbound -- not both (unless uninstall BIND first).

1.  Connect to the server (resolverX.odslab.se) by using SSH or PuTTY.
2.  Change the host name.

        > sudo hostname resolverX.odslab.se

3.  Login and logout to get an updated command prompt.
4.  Uninstall BIND if previously installed.

        > sudo dpkg --purge bind9

5.  Install Unbound as the resolver. Also install dnsutils for dig(1).

        > sudo apt-get update
        > sudo apt-get upgrade
        > sudo apt-get install unbound dnsutils

6.  Configure the Unbound not to use any forwarders

        > sudo vim /etc/default/unbound

    File contents:

        RESOLVCONF_FORWARDERS=false

7.  Restart Unbound

        > systemctl restart unbound

8.  Verify by using dig. Notice that the AD-flag is set.

        > dig +dnssec www.opendnssec.org

9.  Also try resolving a domain where DNSSEC is broken.

        > dig www.trasigdnssec.se

    But we can see that in fact the domain does contain the information
    if we bypass the DNSSEC validation:

        > dig +cd +dnssec www.trasigdnssec.se
