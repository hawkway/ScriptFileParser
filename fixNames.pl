#!/usr/bin/perl

#------------------------------------------------------------------------

use strict;
use warnings;
use constant false => 0;
use constant true  => 1;

#------------------------------------------------------------------------
# read required files into arrays

open my $file, '<', '/home/xxxx/xxxx/xxxx/xxxx/list.txt' or die $!;
chomp(my @myList = <$file>);
close $file or die $!;

open $file, '<', '/home/xxxx/xxxx/xxxx/xxxx/outputNames.txt' or die $!;
chomp(my @myNames = <$file>);
close $file or die $!;


#------------------------------------------------------------------------
# declare vars

my @lowerNames;
my @fixedNames;

print "\n=======================================================\n\n";

#------------------------------------------------------------------------
# identify proper file targets, and match against a master list

foreach my $i (0 .. $#myNames) {
	if ($myNames[$i] =~ /^[a-z]+/) {
		print "trying to match: " . $myNames[$i] . "\n";
		# list of names to search against
		foreach my $j (0 .. $#myList) {
			my $temp = lc $myList[$j];
			# if matching filename is in myList
			if ($myNames[$i] =~ /$temp/) {
				print "   name is: " . $myNames[$i] . "\n";
				print "   match found: " . $myList[$j] . "\n";
				push(@lowerNames, $myNames[$i]);
				push(@fixedNames, $myList[$j]);
			} # end if
		} # end foreach
		print "\n";
	} # end if
} # end foreach

#------------------------------------------------------------------------
# print the names of matched items

foreach (@lowerNames) {
	print "target: " . $_ . "\n";
} # end foreach

print "\n";

#------------------------------------------------------------------------
# make a shell script to do the actual processing

my $dest = "~/xxxx/xxxx/";
my $cmd = "mv";

open $file, '>', '/home/xxxx/xxxx/fixNamesPerlScript.sh' or die $!;

	print $file "#!/bin/bash\n\n";
	print $file "cd ~/xxxxx/xxxx\n\n";
	foreach (0 .. $#lowerNames) {
		print $file "echo \"FIXING: " . $lowerNames[$_] . "\"" . "\n\n";
		print $file $cmd . " " . $lowerNames[$_] . " " . $dest . $fixedNames[$_] . ".xxx\n\n";
	} # end foreach
	print $file "exit 0";

close $file or die $!;

#------------------------------------------------------------------------
