#!/usr/bin/perl

#------------------------------------------------------------------------

use strict;
use warnings;
use constant false => 0;
use constant true  => 1;

#------------------------------------------------------------------------
# read required files into arrays

open my $file, '<', '/home/xxxx/xxxx/config.xxx' or die $!;
chomp(my @myList = <$file>);
close $file or die $!;

#------------------------------------------------------------------------

my @range;

foreach (0 .. $#myList) {
	if ($myList[$_] =~ /#/) {
		push(@range, $_);
	} # end if
} # end foreach

# find number of excess items on the end
my $test = @myList - $range[1];

# remove items from the end
for (my $i = 0 ; $i < $test ; $i++) {
	pop(@myList);
} # end for

# remove items from the front
my $temp = $range[0] + 1;
foreach (0 .. $temp) {
	shift(@myList);
} # end foreach

# remove leading whitespace/chars from name
foreach (0 .. $#myList) {
	$myList[$_] =~ s/^\s+\-\s//;
} # end foreach

#------------------------------------------------------------------------
# make a shell script to do the actual processing

open $file, '>', '/home/xxxx/xxxx/xxxx/xxx/masterList.txt' or die $!;

foreach (@myList) {
	print $file $_ . "\n";
} # end foreach

close $file or die $!;

#------------------------------------------------------------------------
