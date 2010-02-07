#!/usr/bin/perl
use strict;
use warnings;

my %m = ( e => "english", s => "swahili" );

foreach my $lang ( keys %m ) {
    open my $fh, '<', "../${lang}all.txt" or die "EPIC FAIL";
    open my $list, '>', "$m{$lang}_words.txt" or die "EPIC FAIL";
    my $last = '';
    while(<$fh>) {
        next unless /^\[$m{$lang} word\]/i;
        s/^[^]]+]\s+//;
        print $list $_ unless $_ eq $last;
        $last = $_;
    }
}
