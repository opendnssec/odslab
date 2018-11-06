# Setup a Secure Resolver using BIND

The purpose of the lab is to setup the resolver on the first server. You
should install *either* BIND or Unbound -- not both.

1.  Connect to the server (resolverX.odslab.se) by using SSH or PuTTY.

2.  Change the host name.

        sudo hostnamectl set-hostname resolverX.odslab.se

3.  Logout and login to get an updated command prompt.

4.  Upgrade base operating system:

        sudo apt-get update && sudo apt-get upgrade -y

5.  Uninstall Unbound if previously installed:

        sudo dpkg --purge unbound

6.  Install BIND as the resolver and remove resolve.conf

        sudo apt-get install -y bind9

7. Configure BIND so that it only listens on localhost only. Note that some of the options below may already be present in the default configuration file.

        sudo vim /etc/bind/named.conf.options

    Add the following configuration options _inside_ the `options` section:

        listen-on-v6 { ::1; };
        listen-on { 127.0.0.1; };

8. Restart BIND9

        sudo systemctl restart bind9

9. Verify by using dig. Notice that the AD-flag is set.

        dig @127.0.0.1 +dnssec www.opendnssec.org

10. Also try resolving a domain where DNSSEC is broken.

        dig @127.0.0.1 www.trasigdnssec.se

    But we can see that in fact the domain does contain the information if we bypass the DNSSEC validation:

        dig @127.0.0.1 +cd +dnssec www.trasigdnssec.se


---
Next Section: [Install OpenDNSSEC](opendnssec-install.md)
