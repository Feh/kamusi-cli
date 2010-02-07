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
        doubleconsonant => { score => 15, regex => join ('|' => map { $_ x 2 } split '' => 'abcdefglmnoprstz') },
        ending          => { score => 20, regex => '(ed|tion|y|bl[ey]|nt|sh|ze|ing)($|\s)' },
        ending_in_two_consonants => { score => 25, regex => '[^aeiou]{2}$' },
        ch_no_vowel     => { score => 10, regex => 'ch[^aeiouw]' },
        unique          => { score => 30, regex => '(ck|q|x|wh|fl)' },
        kind_of         => { score => 20, regex => 'kind' },
        ie              => { score => 5, regex => 'ie' },
    },

    sw => {
        unique      => { score => 30, regex => "(mw|ng')" },
        dgh         => { score => 10, regex => '(dh|gh)[aeiou]' },
        kiuw        => { score => 5, regex => 'k[uiw]' },
        ana         => { score => 15, regex => 'ana$' },
        verbroot    => { score => 100, regex => '^-' },
        beginning   => { score => 30, regex => '^(n[dygjc]|m([bdfghjklmnprstvwz]|ch))' },
        i_end       => { score => 25, regex => 'i$' },
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
