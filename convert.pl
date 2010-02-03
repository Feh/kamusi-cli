#!/usr/bin/perl
# (c) Julius Plenz

use strict;
use warnings;
use DBI;

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

my %dbargs = (
    AutoCommit  => 0,
    PrintError  => 1,
);

# connect to the database
my $dbh = DBI->connect(
    'dbi:SQLite:dbname=words.db',
    '', '', \%dbargs
);

# preparing the database for the data import
foreach my $lang ( keys %lang_file ) {
    $dbh->do("DROP TABLE $lang");
    $dbh->do(
        "CREATE TABLE $lang ("
        . join( ', ' => map "$_ TEXT" => keys %field )
        . ');'
    );
}

my @fields = keys %field;   # a defined ordering of the %field keys
                            # hashs do not have that, so we use this. Later.

my %insert_stmt;    # prepare the insert statements for each language
                    # (a placeholder for the table name is not possible)
foreach my $lang ( keys %lang_file ) {
    $insert_stmt{$lang} = $dbh->prepare(
        "INSERT INTO $lang ("
        . join( ', ' => @fields )
        . ') VALUES ('
        . join( ', ' => ('?') x @fields )
        . ')'
    );
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

            my $rv = $insert_stmt{$lang}->execute( @record{@field{@fields}} );
            die 'FAIL!' unless $rv == 1;
            $insert_stmt{$lang}->finish;

            %record     = ();
            $reading    = undef;
        }
        else { # nothing to do
            next; # no-op, but more readable
        }
    }

    close $filehandle;
}

$dbh->commit();
$dbh->disconnect();

__END__
