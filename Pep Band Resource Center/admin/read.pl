#!/usr/bin/perl

use strict;
use warnings;
use XML::Simple;
use Data::Dumper;

require "components.pl";

my $xml = new XML::Simple;

my $library_ref = $xml->XMLin("/var/www/html/library.xml");
my %library = %$library_ref;

components::printDocOpening();
components::printHead();
print "<body>";




print "<pre>\n";

foreach my $key (sort(keys(%ENV)))
{
	print "$key:\t\t $ENV{$key}\n";
}


print "\n";
print Dumper($library_ref);
print "</pre>\n";
print "</html>";

