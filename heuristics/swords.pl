#!/usr/bin/perl
use strict;
use warnings;

open my $fh, '<', '../sall.txt' or die "EPIC FAIL";
while(<$fh>) {
    next unless /^\[Swahili Word\]/;
    s/^[^]]+]\s+//;
    print;
}
