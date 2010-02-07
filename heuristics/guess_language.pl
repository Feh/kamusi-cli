#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw[max];
use Data::Dumper;

my %score = ( en => 0, sw => 0 );
my %lang_files = ( en => 'english_words.txt', sw => 'swahili_words.txt' );

my %stat = (
    en => { found => 0, fp => 0, fail => 0},
    sw => { found => 0, fp => 0, fail => 0},
);

my %crit = (
    en => {
        doubleconsonant => {
            regex => join ('|' => map { $_ x 2 } split '' => 'abcdefglmnoprstz'),
            score => 15
        },
        ending => {
            regex => '(ed|tion|y|bl[ey]|nt|sh|ze|ing)($|\s)',
            score => 20
        },
        ending_in_two_consonants => {
            regex => '[^aeiou]{2}$',
            score => 25
        },
        ch_no_vowel => {
            regex => 'ch[^aeiouw]',
            score => 10
        },
        unique => {
            regex => '(ck|q|x|wh|fl)',
            score => 30
        },
        kind_of => {
            regex => 'kind',
            score => 20
        },
        ie => {
            regex => 'ie',
            score => 5
        },
    },

    sw => {
        unique => {
            regex => "(mw|ng')",
            score => 30
        },
        dgh => {
            regex => '(dh|gh)[aeiou]',
            score => 10
        },
        kiuw => {
            regex => 'k[uiw]',
            score => 5
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
            regex => '^(n[dygjc]|m([bdfghjklmnprstvwz]|ch))',
            score => 30
        },
        i_end => {
            regex => 'i$',
            score => 25
        },
        # ending => {
        #     regex => '[aeou]$',
        #     score => 5
        # },
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
        if($score{$l} != 0 && $score{$l} == max(values %score)) {
            $stat{$l}{found}++;
        } else {
            if($score{$l} == 0) {
                $stat{$l}{fail}++;
            } else {
                $stat{$l}{fp}++;
            }
            #print $_ ." $score{$l} vs $score{sw}\n" if $l == "en";
            # print Dumper %score;
        }
    }
}

print Dumper %stat;
