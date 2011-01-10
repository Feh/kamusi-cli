#!/usr/bin/perl

use strict;
use warnings;

print "Content-Type: text/html\r\n\r\n";

my %FORM = ();

if($ENV{'QUERY_STRING'}) {
    my @pairs = split(/&/, $ENV{'QUERY_STRING'});
    foreach my $pair (@pairs)
    {
        my ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%(..)/pack("C", hex($1))/eg;
        $FORM{$name} = $value;
    }
}

# defaults
$FORM{'q'} ||= 'kamusi';
$FORM{'d'} ||= 'sw';
$FORM{'s'} ||= 'false';

$FORM{'q'} =~ s/[^a-z%? -]//g if defined $FORM{'q'};
$FORM{'d'} =~ s/[^a-z]//g if defined $FORM{'d'};
$FORM{'s'} =~ s/[^a-z]//g if defined $FORM{'s'};

$ENV{'HOME'} = '/home/feh';

my @cmd = ("./kamusi");
push @cmd, "-s" if ($FORM{'s'} || 'false') eq 'true';
push @cmd, "-d $FORM{d}" if length($FORM{'d'} || '') > 0;
push @cmd, '--';
push @cmd, "'" . $FORM{'q'} . "'" if defined $FORM{'q'};

my $c = join ' ' => @cmd;
my $res = qx($c);

print "<pre>\n";
if(length($res) > 0) {
    foreach my $line (split /\n/, $res) {
        if($line =~ m/^(\w+)(: )(.+)( = )(.*)$/) {
            $line = "<em>$1</em>$2<strong>$3</strong>$4$5";
        }
        print $line, "\n";
    }
} else {
    print "$FORM{q}: <em>no results</em>";
}
print "</pre>\n";
