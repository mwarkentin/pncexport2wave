#!/usr/bin/env perl

# This is a helper script to convert PNC Bank's Online Statement
# CSV export to the Wave Accountingi (waveapps.com) CSV import.
#
# The data is printed to STDOUT.  Just redirect as needed.
use strict;
use warnings;

use Text::CSV::Simple;
use Getopt::Long;

my %OPT = (
    file => "./all.csv",
);

GetOptions(
    \%OPT, 
    "file=s", 
);

my $parser = Text::CSV::Simple->new;
$parser->want_fields(0, 1, 2, 5);
$parser->field_map(qw/date amount description type/);
my @data = $parser->read_file($OPT{file});

for my $line (@data) {
    my $amount = $line->{amount};
    $amount = "-$amount" if $line->{type} eq 'DEBIT';
    print join(',', ($line->{date}, $amount, "\"$line->{description}\"")) . "\n";
}
