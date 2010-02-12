#!/usr/bin/perl
# (c) Julius Plenz, Mirko Westermeier

use strict;
use warnings;
use DBI;
use SQL::Abstract;

my %field = (
    class               => 'Class',
    derived_language    => 'Derived Language',
    derived_word        => 'Derived Word',
    dialect             => 'Dialect',
    english_definition  => 'English Definition',
    english_example     => 'English Example',
    english_plural      => 'English Plural',
    english_word        => 'English Word',
    note                => 'Note',
    part_of_speech      => 'Part of Speech',
    related_words       => 'Related Words',
    swahili_definition  => 'Swahili Definition',
    swahili_example     => 'Swahili Example',
    swahili_plural      => 'Swahili Plural',
    swahili_word        => 'Swahili Word',
    taxonomy            => 'Taxonomy',
    terminology         => 'Terminology',
);

my %field_dbname = reverse %field;

my $valid_field_rx = join '|' => values %field;

my %lang_file = (
    english => 'eall.txt',
    swahili => 'sall.txt',
);

# connect to the database
my $dbh = DBI->connect(
    'dbi:SQLite:dbname=words.db',
    '', '', {
        AutoCommit  => 0,
        PrintError  => 0,
    },
);

my $sql = new SQL::Abstract; # my$sql OMG!

# preparing the database for the data import
foreach my $lang ( keys %lang_file ) {
    $dbh->do( scalar $sql->generate( 'drop table', \$lang ) );
    $dbh->do( scalar $sql->generate( 'create table', \$lang, [keys %field] ) );
}

# import the language data
foreach my $lang ( keys %lang_file ) {
    open my $filehandle, '<', $lang_file{$lang}
        or die "Couldn't open file $lang_file{$lang}: $!\n";

    my %record = ();
    my $reading; # true if reading a record

    while ( my $line = <$filehandle> ) {

        if ( $line =~ /^\[($valid_field_rx)\]\s+(.+)/ ) { # reading
            $record{$1} = $2;
            $reading++;
        }
        elsif ( $reading ) { # record finished

            my ( $stmt, @bind ) = $sql->insert( $lang, { map {
                $_ => $record{$field{$_}},
            } grep { $record{$field{$_}} } keys %field } );

            $dbh->do( $stmt, {}, @bind );

            %record     = ();
            $reading    = undef;
        }
        else { # nothing to do
            next; # no-op, but more readable
        }
    }

    close $filehandle;
}

print "Successfully imported all data from language files!\n";

$dbh->commit();
$dbh->disconnect();

__END__
