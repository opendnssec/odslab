#!/usr/bin/perl
#
# Dump DNS resource records for all student instances

require 5.6.0;
use strict;
use warnings;
use Data::Dumper;
use JSON -support_by_pp;

my %instance_id       = ();
my %instance_hostname = ();
my %instance_type     = ();

my $profile = "default";
my $region  = "eu-west-1";
my $awscmd = sprintf("aws --profile %s --region %s", $profile, $region);

my $json = `$awscmd ec2 describe-instances`;
my $data = decode_json($json);

foreach my $r (@{ $data->{Reservations} }) {
    foreach my $i (@{ $r->{Instances} }) {

        my $addr = $i->{PublicIpAddress};

        my $name = undef;
        my $id   = undef;
        my $type = undef;

        foreach my $t (@{ $i->{Tags} }) {
            $id   = $t->{Value} if ($t->{Key} eq "ID");
            $type = $t->{Value} if ($t->{Key} eq "Type");
            $name = $t->{Value} if ($t->{Key} eq "Name");
        }

	next unless $type;
	next unless $addr;

        if ($type eq "teacher") {
            printf("teacher IN A %s\n", $addr);
            next;
        }

        if ($type eq "resolver") {
            printf("resolver%-12d IN A %s\n", $id, $addr);
            next;
        }

        if ($type eq "signer") {
            printf("ns%-18d IN A %s\n",       $id, $addr);
            printf("group%-15d IN NS ns%d\n", $id, $id);
            next;
        }
    }
}
