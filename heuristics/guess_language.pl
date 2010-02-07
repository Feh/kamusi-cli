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
        unique          => { score => 30, regex => '(c[^h]|q|x|wh|fl)' },
        kind_of         => { score => 20, regex => 'kind' },
        ie              => { score => 5, regex => 'ie' },
        th              => { score => 5, regex => '^th' },
    },

    sw => {
        unique      => { score => 30, regex => "(mw|ng')" },
        dgh         => { score => 10, regex => '(dh|gh)[aeiou]' },
        kiuw        => { score => 5, regex => 'k[uiw]' },
        ki_begin    => { score => 15, regex => '(^|\s)ki' },
        ana         => { score => 15, regex => 'ana$' },
        verbroot    => { score => 100, regex => '^-' },
        beginning   => { score => 30, regex => '^(n[dygjc]|m([bdfghjklmnprstvwz]|ch))' },
        i_end       => { score => 25, regex => 'i$' },
        ji          => { score => 10, regex => 'ji' },
        double_u_a  => { score => 30, regex => 'aa|uu' },
        middle_of   => { score => 50, regex => '\s[wylz]a\s' },
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
        }
        if($score{$l} != 0) {
            if ($score{$l} == max(values %score)) {
                $stat{$l}{found}++;
            } else {
                $stat{$l}{fp}++;
            }
        } else {
            if(max(values %score) > 0) {
                $stat{$l}{fp}++;
            } else {
                $stat{$l}{fail}++;
                print $_ ." en:$score{en} vs sw:$score{sw}\n";
            }
        }
    }
}

print Dumper %stat;
