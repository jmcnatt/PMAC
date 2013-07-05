#!/usr/bin/perl

package utilities;

use strict;
use warnings;

# Formats a phone number
sub formatPhoneNumber()
{
	my ($phone) = @_;
	
        my $phone_formatted =
		'(' . substr($phone, 0 , 3) .
                ') ' . substr($phone, 3, 3) .
                '-' . substr($phone, 5, 4);

	return $phone_formatted;
}

1;
