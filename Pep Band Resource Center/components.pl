#!/usr/bin/perl

package components;

require "utilities.pl";

use strict;
use warnings;
use XML::Simple;

# Prints the document opening
sub printDocOpening()
{
	print "content-type: text/html\n\n";
	print <<"EOF";
<DOCTYPE html>
<html>
EOF
}

# prints the document closing
sub printDocClosing()
{
	print <<"EOF";
</html>
EOF
}

# Prints the header component for html pages
sub printHead()
{
	print <<"EOF";

<head>
<meta http-equiv="Content-type" content="text/html; charset=ISO-8859-1" />
<meta name="robots" content="noindex, nofollow" />
<title>RIT Pep Band Resource Center - pepband.student.rit.edu</title>
<link rel="stylesheet" type="text/css" href="/styles/main.css" />
<link rel="shortcut icon" href="/favicon.ico" />
</head>
EOF
}

# Prints the banner and beginning of the body
sub printBodyOpening()
{
	print <<"EOF";
<body>
<div id="container">
<div id="header">
<img src="/media/banner.jpg" alt="RIT Pep Band Resource Center" height="120" width="750" />
</div>
<div id="content-container">
EOF
}

sub printBodyClosing()
{
	print <<"EOF";
</div>
<div id="footer">
	Updated for the 2012/2013 Academic Year<br />
	For Use by the RIT Pep Band Onlyi
</div>
</div>
</body>
EOF
}

sub printNavigation()
{
	print <<"EOF";
<div id="navigation">
<h1>Information</h1>
<ul>
	<li><a href="#">Calendar</a></li>
	<li><a href="#">Eboard</a></li>
	<li><a href="#">Section Leaders</a></li>
	<li><a href="#">Documents</a></li>
	<li><a href="#">Links</a></li>
</ul>
<h1>Music</h1>
<ul>
EOF
	my $xml = new XML::Simple;
	my $navigation_ref = $xml->XMLin($ENV{'DOCUMENT_ROOT'} . "/navigation.xml");
	my %navigation = %$navigation_ref;
	
	my $library_nav_ref = $navigation{"library"};
	my %library_nav = %$library_nav_ref;

	foreach my $entry (sort(keys(%library_nav)))
	{
		if (defined($library_nav{$entry}{'href'}) && 
			defined($library_nav{$entry}{'name'}))
		{
			my $entry_name = $library_nav{$entry}{'name'};
			my $entry_href = $library_nav{$entry}{'href'};
			print "<li>";
			print "<a title=\"$entry_name\" href=\"$entry_href\">";
			print "$entry_name";
			print "</a>";
			print "</li>";
		}		
	}

	print <<"EOF";
</ul>
</div>
EOF
}	

# Generates a song page from the library
sub printLibraryEntry()
{
	my ($song) = @_;
	my $xml = new XML::Simple;

	my $library_ref = $xml->XMLin($ENV{'DOCUMENT_ROOT'} . "/library.xml");
	my %library = %$library_ref;
	
	if (!exists($library{$song}))
	{
		&printError404();
		return;
	}

	print "<h1>" . $library{$song}{"name"} . "</h1>\n";
	
	print "<h2>Parts</h2>";
	print "<p>Click on the link to download the appropriate part.</p>";
	print "<br />";
	
        my $parts_ref = $library{$song}{"parts"};
        my %parts = %$parts_ref;

        print "<table class=\"music-table\">\n";
        print "<th><!-- Filler --></th>\n";
        print "<th><img src=\"/media/pdf.png\" alt=\"PDF\" height=\"16\" width=\"16\" />";
        print "&#032;PDF</th>\n";
        print "<th><img src=\"/media/picture.png\" alt=\"JPEG\" height=\"16\" width=\"16\" />\n";
        print "&#032;JPG</th>\n";
	
	my $count = 1;
	
	foreach my $part (sort(keys(%parts)))
        {
                my $class = "even";
                my $pdf;
                my $jpg;


                if ($count % 2) { $class = "odd"; }
                if ($parts{$part}{"pdf"} =~ /\w+?\.pdf/i)
                {
                        $pdf = $library{$song}{"path"} . "pdf/" . $parts{$part}{"pdf"};
                }

                if ($parts{$part}{"jpg"} =~ /\w+?\.jpg/i)
                {
                        $jpg = $library{$song}{"path"} . "jpg/" . $parts{$part}{"jpg"};
                }

                if (!defined($pdf) && !defined($jpg)) { next; }

                print "<tr class=\"$class\">\n";
                print "<td>" . $parts{$part}{"name"} . "</td>\n";
                print "<td class=\"pdf\">";

                if ($pdf) { print "<a href=\"$pdf\" target=\"_blank\">Click Here</a>"; }
                else { print "Not Available"; }

		print "</td>\n";
                print "<td class=\"jpeg\">";
                if ($jpg) { print "<a href=\"$jpg\" target=\"_blank\">Click Here</a>"; }
                else { print "Not Available"; }

                print "</td>\n";
                print "</tr>\n";

                $count++;

        }

        print "</table>\n";
}

sub printEboardContact()
{
	my $xml = new XML::Simple;
	my $xml_path = $ENV{'DOCUMENT_ROOT'} . "/eboard.xml";
	if (!(-e $xml_path)) { return "Error - eboard configuraiton missing"; }
	my $eboard_ref = $xml->XMLin($xml_path);
	my %eboard = %$eboard_ref;

	foreach my $member (sort(keys(%eboard)))
	{
		print "<h2>" . $eboard{$member}{'description'} . "</h2>\n";
		print "<p>";
		if (defined($eboard{$member}{'name'}))
		{
			my $name = $eboard{$member}{'name'};
			print "$name<br />\n";
			
			if ($eboard{$member}{'phone'} =~ /^\d{10}$/)
			{
				my $phone = $eboard{$member}{'phone'};
				$phone = &utilities::formatPhoneNumber($phone); 
				print "$phone<br />\n";
			}

			if (defined($eboard{$member}{'email'}))
			{
				my $email = $eboard{$member}{'email'};
				print "<a href=\"mailto:$email\">$email</a><br />\n";
			}
		}

		print "</p>\n";

	}
}

1;
