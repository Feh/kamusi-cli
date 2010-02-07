#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %score = ( en => 0, sw => 0 );
my $w = shift;

die 'no word!' unless $w;

my %crit = (
    en => {
        doubleconsonant => {
            regex =>join ('|' => map { $_ x 2 } split '' => 'abcdefglmnoprstz'),
            score => 15
        },
        ending => {
            regex => '(.tion|.y|.bl[ey]|nt|ze)$',
            score => 20
        },
        unique => {
            regex => '(ck|q|x)',
            score => 30
        }
    },

    sw => {
        unique => {
            regex => "(mw|ng')",
            score => 30
        },
        dgh => {
            regex => 'dh|gh',
            score => 10
        },
        ana => {
            regex => 'ana$',
            score => 15
        },
        verbroot => {
            regex => '^-',
            score => 100
        },
        beginning => {
            regex => '^(n[dy]|m[ztdkw])',
            score => 30
        },
        ending => {
            regex => '[aeiou]$',
            score => 5
        }
    }
);

foreach my $lang (keys %crit) {
    foreach my $c (keys %{$crit{$lang}}) {
        $score{$lang} += $crit{$lang}{$c}{score}
            if $w =~ /$crit{$lang}{$c}{regex}/;
    }
}

print Dumper %score;
