# Setup a Secure Resolver using Unbound

The purpose of the lab is to setup the resolver on the first server. You should install *either* BIND or Unbound -- not both (unless uninstall BIND first).

1.  Connect to the server (resolverX.odslab.se) by using SSH or PuTTY.

2.  Change the host name.

        sudo hostnamectl set-hostname resolverX.odslab.se

3.  Login and logout to get an updated command prompt.

4.  Upgrade base operating system:

        sudo apt-get update && sudo apt-get upgrade -y

5.  Uninstall BIND if previously installed:

        sudo dpkg --purge bind9

6.  Install Unbound as the resolver. Also install dnsutils for dig(1).

        sudo apt-get install -y unbound dnsutils

7.  Verify by using dig. Notice that the AD-flag is set.

        dig +dnssec www.opendnssec.org

8.  Also try resolving a domain where DNSSEC is broken.

        dig www.trasigdnssec.se

    But we can see that in fact the domain does contain the information if we bypass the DNSSEC validation:

        dig +cd +dnssec www.trasigdnssec.se



---
Next Section: [Install OpenDNSSEC](opendnssec-install.md)
