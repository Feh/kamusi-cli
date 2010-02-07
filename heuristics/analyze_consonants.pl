#!/usr/bin/perl
use strict;
use warnings;

my %c = ();

open my $f, '<', 'swahili_words.txt' or die 'bleah';
while(<$f>) {
    chomp;
    $c{$1}++ if /([bcdfghjklmnpqrstvwxyz]+)/;
}

map { print "$_ -> $c{$_}\n" } keys %c;
