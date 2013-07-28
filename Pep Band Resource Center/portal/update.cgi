#!/usr/bin/perl

use strict;
use warnings;

my @results = `/usr/local/git/update.pl`;

print "content-type: text/html\n\n";
print <<"EOF";
<DOCTYPE html>
<html>
<head>
<title>Updating PMAC from github</title>
</head>
<body>
<pre>
EOF

foreach (@results)
{
	print $_ . "\n";
}

print <<"EOF";
</pre>
</body>
</html>
EOF
