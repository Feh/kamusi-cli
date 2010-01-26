#!/usr/bin/perl
# (c) Julius Plenz

use strict;
use warnings;
use DBI;

my $dbargs = {AutoCommit => 0, PrintError => 1};
my $dbh = DBI->connect("dbi:SQLite:dbname=words.db", "", "", $dbargs);

# The creation command:
#
#

# recreate the tables from scratch
# might throw an error message if the db has not existed in the first place.
$dbh->do("drop table english");
$dbh->do("drop table kiswahili");

$dbh->do("CREATE TABLE english (class TEXT, derived_language TEXT, derived_word TEXT,
dialect TEXT, english_definition TEXT, english_example TEXT, english_plural TEXT,
english_word TEXT, note TEXT, part_of_speech TEXT, related_words TEXT,
swahili_definition TEXT, swahili_example TEXT, swahili_plural TEXT, swahili_word TEXT,
taxonomy TEXT, terminology TEXT);");
$dbh->do("CREATE TABLE swahili (class TEXT, derived_language TEXT, derived_word TEXT,
dialect TEXT, english_definition TEXT, english_example TEXT, english_plural TEXT,
english_word TEXT, note TEXT, part_of_speech TEXT, related_words TEXT,
swahili_definition TEXT, swahili_example TEXT, swahili_plural TEXT, swahili_word TEXT,
taxonomy TEXT, terminology TEXT);");


open(EN, "eall.txt");
my %entry;
while (<EN>) {
    next unless /^\[/;
    chomp;
    my $value = $_;
    $value =~ s/^\[[^\]]+\] //;
    s/^\[([^\]]+)\].*$/$1/;

    if(/English Word/) { # commit array, then reset
        $entry{"english_word"} = $value;

        my $query = "insert into english (
        class, derived_language, derived_word, dialect, english_definition,
        english_example, english_plural, english_word, note,
        part_of_speech, related_words, swahili_definition, swahili_example,
        swahili_plural, swahili_word, taxonomy, terminology
        ) values ( " .
            $dbh->quote($entry{"class"}) . ", " .
            $dbh->quote($entry{"derived_language"}) . ", " .
            $dbh->quote($entry{"derived_word"}) . ", " .
            $dbh->quote($entry{"dialect"}) . ", " .
            $dbh->quote($entry{"english_definition"}) . ", " .
            $dbh->quote($entry{"english_example"}) . ", " .
            $dbh->quote($entry{"english_plural"}) . ", " .
            $dbh->quote($entry{"english_word"}) . ", " .
            $dbh->quote($entry{"note"}) . ", " .
            $dbh->quote($entry{"part_of_speech"}) . ", " .
            $dbh->quote($entry{"related_words"}) . ", " .
            $dbh->quote($entry{"swahili_definition"}) . ", " .
            $dbh->quote($entry{"swahili_example"}) . ", " .
            $dbh->quote($entry{"swahili_plural"}) . ", " .
            $dbh->quote($entry{"swahili_word"}) . ", " .
            $dbh->quote($entry{"taxonomy"}) . ", " .
            $dbh->quote($entry{"terminology"}) .
        ");";

        $dbh->do($query);
        if ($dbh->err()) { die "$DBI::errstr\n"; }
        %entry = ();
    } # not the start of a word
    elsif (/Class/) {
        $entry{"class"} = $value;
    } elsif (/Derived Language/) {
        $entry{"derived_language"} = $value;
    } elsif (/Derived Word/) {
        $entry{"derived_word"} = $value;
    } elsif (/Dialect/) {
        $entry{"dialect"} = $value;
    } elsif (/English Definition/) {
        $entry{"english_definition"} = $value;
    } elsif (/English Example/) {
        $entry{"english_example"} = $value;
    } elsif (/English Plural/) {
        $entry{"english_plural"} = $value;
    } elsif (/Note/) {
        $entry{"note"} = $value;
    } elsif (/Part of Speech/) {
        $entry{"part_of_speech"} = $value;
    } elsif (/Related Words/) {
        $entry{"related_words"} = $value;
    } elsif (/Swahili Definition/) {
        $entry{"swahili_definition"} = $value;
    } elsif (/Swahili Example/) {
        $entry{"swahili_example"} = $value;
    } elsif (/Swahili Plural/) {
        $entry{"swahili_plural"} = $value;
    } elsif (/Swahili Word/) {
        $entry{"swahili_word"} = $value;
    } elsif (/Taxonomy/) {
        $entry{"taxonomy"} = $value;
    } elsif (/Terminology/) {
        $entry{"terminology"} = $value;
    }
}
close(EN);

open(SW, "sall.txt");
%entry = ();
while (<SW>) {
    next unless /^\[/;
    chomp;
    my $value = $_;
    $value =~ s/^\[[^\]]+\] //;
    s/^\[([^\]]+)\].*$/$1/;

    if(/Swahili Word/) { # commit array, then reset
        $entry{"swahili_word"} = $value;

        my $query = "insert into swahili (
        class, derived_language, derived_word, dialect, english_definition,
        english_example, english_plural, english_word, note,
        part_of_speech, related_words, swahili_definition, swahili_example,
        swahili_plural, swahili_word, taxonomy, terminology
        ) values ( " .
            $dbh->quote($entry{"class"}) . ", " .
            $dbh->quote($entry{"derived_language"}) . ", " .
            $dbh->quote($entry{"derived_word"}) . ", " .
            $dbh->quote($entry{"dialect"}) . ", " .
            $dbh->quote($entry{"english_definition"}) . ", " .
            $dbh->quote($entry{"english_example"}) . ", " .
            $dbh->quote($entry{"english_plural"}) . ", " .
            $dbh->quote($entry{"english_word"}) . ", " .
            $dbh->quote($entry{"note"}) . ", " .
            $dbh->quote($entry{"part_of_speech"}) . ", " .
            $dbh->quote($entry{"related_words"}) . ", " .
            $dbh->quote($entry{"swahili_definition"}) . ", " .
            $dbh->quote($entry{"swahili_example"}) . ", " .
            $dbh->quote($entry{"swahili_plural"}) . ", " .
            $dbh->quote($entry{"swahili_word"}) . ", " .
            $dbh->quote($entry{"taxonomy"}) . ", " .
            $dbh->quote($entry{"terminology"}) .
        ");";

        $dbh->do($query);
        if ($dbh->err()) { die "$DBI::errstr\n"; }
        %entry = ();
    } # not the start of a word
    elsif (/Class/) {
        $entry{"class"} = $value;
    } elsif (/Derived Language/) {
        $entry{"derived_language"} = $value;
    } elsif (/Derived Word/) {
        $entry{"derived_word"} = $value;
    } elsif (/Dialect/) {
        $entry{"dialect"} = $value;
    } elsif (/English Definition/) {
        $entry{"english_definition"} = $value;
    } elsif (/English Example/) {
        $entry{"english_example"} = $value;
    } elsif (/English Plural/) {
        $entry{"english_plural"} = $value;
    } elsif (/English Word/) {
        $entry{"english_word"} = $value;
    } elsif (/Note/) {
        $entry{"note"} = $value;
    } elsif (/Part of Speech/) {
        $entry{"part_of_speech"} = $value;
    } elsif (/Related Words/) {
        $entry{"related_words"} = $value;
    } elsif (/Swahili Definition/) {
        $entry{"swahili_definition"} = $value;
    } elsif (/Swahili Example/) {
        $entry{"swahili_example"} = $value;
    } elsif (/Swahili Plural/) {
        $entry{"swahili_plural"} = $value;
    } elsif (/Taxonomy/) {
        $entry{"taxonomy"} = $value;
    } elsif (/Terminology/) {
        $entry{"terminology"} = $value;
    }
}
close(EN);

$dbh->commit();
$dbh->disconnect();
