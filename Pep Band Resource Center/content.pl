#!/usr/bin/perl

use strict;
use warnings;

require "components.pl";

# Process the request
my $query = $ENV{'QUERY_STRING'};


&components::printDocOpening();
&components::printHead();
&components::printBodyOpening();
&components::printNavigation();

if (!$query) { &pageCalendar(); }
if ($query =~ /^calendar$/i) { &pageCalendar(); }
elsif ($query =~ /^eboard$/i) { &pageEboard(); }



&components::printBodyClosing();
&components::printDocClosing();


# Prints the calendar page
sub pageCalendar()
{
	print <<"EOF";
<div id="content">
<h1>Calendar</h1>
<iframe src="https://www.google.com/calendar/embed?showTitle=0&amp;showNav=0&amp;showCalendars=0&amp;showTz=0&amp;height=600&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=ritpepband%40gmail.com&amp;color=%23B1440E&amp;ctz=America%2FNew_York" style=" border-width:0 " width="700" height="600" frameborder="0" scrolling="no"></iframe>
</div>
EOF
}

# Prints the eboard page
sub pageEboard()
{
	print <<"EOF";
<div id="content">
<h1>Eboard</h1>
EOF
	&components::printEboardContact();
	
	print "</div>\n";
}
