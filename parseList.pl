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

open $file, '<', '/home/xxxx/xxxx/xxxx/xxxx/masterList.txt' or die $!;
chomp(my @masterList = <$file>);
close $file or die $!;

open $file, '<', '/home/xxxx/xxxx/xxxx/xxxx/processedList.txt' or die $!;
chomp(my @processedList = <$file>);
close $file or die $!;

#------------------------------------------------------------------------
# declare vars

my @targetList;
my @removalIndex;

#------------------------------------------------------------------------
# remove old items from the list

if (@processedList >= 40) {
	# remove items from the beginning
	for (my $i = 0 ; $i < 20 ; $i++) {
		shift(@processedList);
	} # end for
} # end if

#------------------------------------------------------------------------
# identify proper file targets, and match against a master list

foreach my $i (0 .. $#myList) {
	# identify by filename
	if ($myList[$i] =~ /xxxx/ && $myList[$i] =~ /xxxx/) {
		print "trying to match: " . $myList[$i] . "\n";
		# force name to lower case
		my $tempItem = lc $myList[$i];
		# list of items to search against
		foreach my $item (@masterList) {
			# split the item name into tempList
			my @tempList = split(' ', $item);
			# for every word in the item name
			my $flag = true;
			foreach my $token (@tempList) {
				# if the word is not in the list
				# check lowercase == lowercase
				if ($tempItem !~ /\L$token/) {
					$flag = false;
				} # end if
			} # end foreach
			# if all words of item name exist in list
			if ($flag) {
				print "   name is: " . $item . "\n";
				print "   match found: " . $myList[$i] . "\n";
				push(@targetList, $myList[$i]);
			} # end if
		} # end foreach
		print "\n";
	} # end if
} # end foreach

#------------------------------------------------------------------------
# print the names of matched item

print "\n=======================================================\n\n";

foreach (@targetList) {
	print "selected targets: " . $_ . "\n";
} # end foreach

print "\n=======================================================\n\n";

#------------------------------------------------------------------------
# for every matched item, check to see if it has been processed

foreach my $index (0 .. $#targetList) {
	foreach (@processedList) {
		if ($targetList[$index] =~ /$_/) {
			push(@removalIndex, $index);
		} # end if
	} # end foreach
} # end foreach

#------------------------------------------------------------------------
# remove processed item from the matched list

my @revIndex = sort {$b <=> $a} @removalIndex;

foreach (@revIndex) {
	print "\n";
	print "trying to pop index: " . $_ . "\n";
	print "   removing name: " . $targetList[$_] . "\n";
	splice(@targetList, $_, 1);
} # end foreach

print "\n=======================================================\n\n";

#------------------------------------------------------------------------
# print the names of item to be processed

foreach (@targetList) {
	print "final targets: " . $_ . "\n";
} # end foreach

print "\n=======================================================\n\n";

#------------------------------------------------------------------------
# make a shell script to do the actual processing

open $file, '>', '/home/xxxx/xxxx/myPerlParseScript.sh' or die $!;

my $dest = "~/xxxx/xxxx/";
my $cmd = "cp -R";

	print $file "#!/bin/bash\n\n";
	print $file "cd ~/xxxx/xxxx/xxxx\n\n";
	foreach (@targetList) {
		print $file "echo \"COPYING: " . $_ . "\"" . "\n\n";
		print $file $cmd . " " . $_ . " " . $dest . "\n\n";
	} # end foreach
	print $file "exit 0";

close $file or die $!;

#------------------------------------------------------------------------
# append processed file names to the processed file list

open $file, '>', '/home/xxxx/xxxx/xxxx/xxxx/processedList.txt' or die $!;
	foreach(@processedList) {
		print $file $_ . "\n";
	} # end foreach
	foreach (@targetList) {
		print $file $_ . "\n";
	} # end foreach
close $file or die $!;

#------------------------------------------------------------------------