#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw[max];
use Data::Dumper;

my %score = ( en => 0, sw => 0 );
my %lang_files = ( en => 'english_words.txt', sw => 'swahili_words.txt' );

my %stat = (
    en => { found => 0, fp => 0 },
    sw => { found => 0, fp => 0 },
);

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
            regex => '(ck|q|x|wh)',
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
        ku => {
            regex => 'ku',
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

foreach my $l (keys %crit) {
    open my $fh, '<', $lang_files{$l} or die 'fail';
    while(<$fh>) {
        chomp;
        foreach my $lang (keys %crit) {
            $score{$lang} = 0;
            foreach my $c (keys %{$crit{$lang}}) {
                $score{$lang} += $crit{$lang}{$c}{score}
                    if /$crit{$lang}{$c}{regex}/;
            }
            #print max(values %score) . "\n\n";
        }
        if($score{$l} == max(values %score)) {
            if($score{$l} == 0) {
                $stat{$l}{fp}++;
            } else {
                $stat{$l}{found}++;
            }
        } else {
            $stat{$l}{fp}++;
            # print $_ ."\n";
            # print Dumper %score;
        }
    }
}

print Dumper %stat;
