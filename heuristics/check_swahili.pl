#!/usr/bin/perl
use strict;
use warnings;

my $score = 50; # for later use
my $w = shift;

my $count = 0;

my @c = ( 'b', 'ch', 'd', 'dh', 'f', 'g', 'gh', 'h', 'j',
    'k', 'kh', 'l', 'm[twm]?', 'n', 'n[zdyg]?', 'p', 'r', 's', 'st', 'sh',
    't', 'th', 'v', 'w', 'y', 'z',);
my @v = ( 'a', 'e', 'i', 'o', 'u' );

my $c_test = "(". join('|' => @c) . ")";
my $v_test = "(". join('|' => @v) . ")";

open my $f, '<', 'swahili_words.txt' or die 'cant open file';
while (<$f>) {
    chomp;
    $count++ if /^-?$v_test?($c_test$v_test{1,2})+(\s+.*)?$/;
}
    print "^-?$v_test?($c_test${v_test}{1,3})+(\\s+.*)?\$\n";

print $count . " words matched the expr!\n";
