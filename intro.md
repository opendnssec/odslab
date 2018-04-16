# OpenDNSSEC Training

This document is distributed by OpenDNSSEC under a Creative Commons Attribution-ShareAlike 4.0 International License*


## Introduction

You as a student will have two servers. One will be configured to be the
resolver and the other will be the name server hosting your zone.

-   resolverX.odslab.se
-   nsX.odslab.se

*X* is the group number given to you by the teacher. The IP-addresses of
the resolver and the name server are configured directly in the
*odslab.se* zone, and can be used from the beginning.

You will also be working with the domain *groupX.odslab.se*. This domain
is however not present in DNS yet, because that will happen later in the
lab.


### Connecting to a Server

Use an SSH client (such as OpenSSH or PuTTY) to connect to your servers.
The private key will be given to you by the teacher.

**OpenSSH**

    chmod 400 ods-student.pem
    ssh -i ods-student.pem ubuntu@ADDRESS

**PuTTY**

-   Convert the key to PuTTY format using the PuTTYgen, save the result
    to ods-student.ppk
-   Enter address to server.
-   Use the ods-student.ppk for authentication and log in as the user "ubuntu".


### Documentation

Documentation can be found online at [wiki.opendnssec.org](http://wiki.opendnssec.org).

### Get Started

Let's get started by installing a secure resolver:

- [Setup a Secure Resolver using BIND](recursive-bind.md)
- [Setup a Secure Resolver using Unbound](recursive-unbound.md)
