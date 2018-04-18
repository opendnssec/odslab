# Quickstart

## Resolver (Unbound)

    sudo apt-get update && sudo apt-get -y dist-upgrade
    sudo dpkg --purge bind9
    sudo apt-get install -y unbound dnsutils

## Resolver (BIND)

    sudo apt-get update && sudo apt-get -y dist-upgrade
    sudo dpkg --purge unbound
    sudo apt-get install -y bind9

## Signer

    sudo apt-get update && sudo apt-get -y dist-upgrade
    sudo apt-get install -y build-essential bind9 softhsm2 \
        libssl-dev libldns-dev \
        libxml2-dev libxml2-utils \
        libsqlite3-dev sqlite3

### OpenDNSSEC 2.0.4

    wget https://dist.opendnssec.org/source/opendnssec-2.0.4.tar.gz
    tar xzf opendnssec-2.0.4.tar.gz
    cd opendnssec-2.0.4 
    ./configure && make && sudo make install
