#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;
use constant false => 0;
use constant true  => 1;

#------------------------------------------------------------------------
# read required files into arrays

open my $file, '<', '/home/xxxx/xxxx/xxxx/xxxx/List1.txt' or die $!;
chomp(my @masterList = <$file>);
close $file or die $!;

#------------------------------------------------------------------------
# declare vars

my @dirList; 	# original list of dir names before regex
my @dirNames; 	# modified list of dir names for use as keys
my @fileList; 	# list of names
my @processAry; # list of file names to process
my %nameCount; 	# number of times an item exists
my %nameList; 	# stores the item by name
my %hasDir; 	# T/F if dir for item already exists
my %fileDest; 	# filename and destination pairs
my @createDir; 	# list of items that need to have dir created
my %createList; # final dir names to be created

#------------------------------------------------------------------------
# init hashTable to zero and load array into another

for (@masterList) {
	my $temp = [];
	$nameCount{$_} = 0;
	$nameList{$_} = $temp;
} # end for

#------------------------------------------------------------------------
# get the names of all of the folders in a certain directory

# set starting directory to search for files
my $dir = dir('/home/xxxx/xxxx/xxxx');

# iterate over the contents of $dir
while (my $file = $dir->next) {
	# see if it is a directory
	if ( $file->is_dir() ) {
		push(@dirList, $file); 	# add original names to dirList
		#print "file before: " . $file . "\n\n";
		$file =~ s/\sS\w*$//; 	# fix file name
		#print "file after: " . $file . "\n\n";
		push(@dirNames, $file); # add modified name to dupe ary
	} # end if
	else {
		$file =~ s/$dir\/?//; 	# record list of non-dir names
		push(@fileList, $file);
	} # end else
next } # end while

# remove bs dir info from front of array
shift(@dirList);
shift(@dirList);
shift(@dirNames);
shift(@dirNames);

print "\n=======================================================\n\n";

my $num = @dirNames;
print "printing list of $num directories:\n\n";
foreach (@dirNames) {
	$_ =~ s/$dir\/?//;
	print $_ . "\n";
} # end foreach

print "\n=======================================================\n\n";

print "printing list of files:\n\n";
foreach (@fileList) {
	print $_ . "\n";
} # end foreach

#------------------------------------------------------------------------
# count the number of items

print "\n=======================================================\n\n";

# match items from the target list
foreach my $i (0 .. $#fileList) {
	# identify items by filename
	if ($fileList[$i] =~ /xxxx/ && $fileList[$i] =~ /xxxx/) {
		print "trying to match: " . $fileList[$i] . "\n";
		# force name to lower case
		my $tempItem = lc $fileList[$i];
		# list of items to search against
		foreach my $itemName (@masterList) {
			# split the items name into tempList
			my @tempList = split(' ', $itemName);
			# for every word in the items name
			my $flag = true;
			foreach my $token (@tempList) {
				# if the word is not in the list
				# check lowercase == lowercase
				if ($tempItem !~ /\L$token/) {
					$flag = false;
				} # end if
			} # end foreach
			# if all words of items name exist in list
			if ($flag) {
				$nameCount{$itemName} += 1;
				print "   item name is: " . $itemName . "\n";
				print "   match found: " . $fileList[$i] . "\n";
				push(@{$nameList{$itemName}} , $fileList[$i]);
			} # end if
		} # end foreach
		print "\n";
	} # end if
} # end foreach

print "\n=======================================================\n\n";

# remove empty item names
for (keys %nameCount) {
	if ($nameCount{$_} == 0) {
		delete $nameCount{$_};
	} # end if
	else {
		print "existing files: " . $_ . "\n";
	} # end else
} # end for

print "\n=======================================================\n\n";

# print the item names by key
foreach my $key (keys %nameList) {
	if (@{$nameList{$key}}) {
		print "key: $key\n";
		push(@processAry, $key);
	} # end if
	else {
		delete $nameList{$key};
	} # end else
	foreach (@{$nameList{$key}}) {
		print "   $_\n";
	} # end foreach
} # end foreach

#------------------------------------------------------------------------
# identify proper file targets, and match against a master list

print "\n=======================================================\n\n";

# init hashTable to false
# following loop can only set true values correctly
for (@processAry) {
	$hasDir{$_} = false;
} # end for

# match items to existing directory
foreach my $item (@processAry) {
	print "checking for existing dir: " . $item . "\n";
	my $flag;
	foreach my $i (0 .. $#dirNames) {
		# split the item name into tempList
		my @tempList = split(' ', $dirNames[$i]);
		# for every word in the item name
		$flag = true;
		foreach my $token (@tempList) {
			# if the word is not in the list
			# check lowercase == lowercase
			if ($item !~ /\L$token/) {
				$flag = false;
			} # end if
		} # end foreach
		# if dir exists, set hash value to true
		if ($flag) {
			# match every file name of that item to existing dir
			foreach (@{$nameList{$item}}) {
				print "   filename: $_\n";
				$fileDest{$_} = $dirList[$i];
			} # end for
			print "   dir name is: $dirNames[$i]\n";
			print "   original dir is: $dirList[$i]\n";
			print "   match found: $item\n";
			$hasDir{$item} = true;
			print "      hasDir: $hasDir{$item}\n";
		} # end if
	} # end foreach
	print "\n";
} # end foreach

print "\n=======================================================\n\n";

# this used to only have value for debug purposes
for (keys %hasDir) {
	# hash of item with a directory
	if ($hasDir{$_}) {
		print "key: $_\n";
		print "has dir: $hasDir{$_}\n\n";
	} # end if
	else {
		$hasDir{$_} = false;
		print "key: $_\n";
		print "no dir: $hasDir{$_}\n\n";
	} # end else
} # end for

print "\n=======================================================\n\n";

# pair single files with existing folders
for my $myKey (keys %fileDest) {
	# hash of item with a directory
		foreach ($fileDest{$myKey}) {
			print " key: $myKey\n";
			# fix spaces for bash output
			$fileDest{$myKey} =~ s/\s/\\ /g;
			print "dest: $fileDest{$myKey}\n\n";
		} # end foreach
} # end for

print "\n=======================================================\n\n";

# find item with 3 and no dir
print "has 3+ :\n";
for my $name (keys %nameCount) {
	# if there are more than 3
	if ($nameCount{$name} >= 3 && !$hasDir{$name}) {
		foreach ($nameList{$name}) {
			print "      key: $name\n";
			push(@createDir, $name);
		} # end foreach
	} # end if
} # end for

# for every item that needs a dir
for (@createDir) {
	my ($name, $temp) = ($_, $_);
	# make the words upper case
	$name =~ s/(\w+)/\u$1/g;
	print "   proper: $name\n";
	# get the filename
	my @tmpAry = @{$nameList{$_}};
	$temp = $tmpAry[0];
	print "     file: $temp\n";
	# get the info
	my ($token) = $temp =~ /(S\d+)/;
	print "   token: $token\n";
	# concat name
	my $dirName = $name . " " . $token;
	# fix spaces for bash output
	$dirName =~ s/\s/\\ /g;
	print "      dir: $dirName\n\n";
	$createList{$_} = $dirName;
} # end for

#------------------------------------------------------------------------
# make a shell script to do the actual processing

open $file, '>', '/home/xxxx/xxxx/myPerlCreateDirScript.sh' or die $!;

my $cmd = "mv";

print $file "#!/bin/bash\n\n";
print $file "cd ~/xxxx/xxxx\n\n";

print $file "echo \"MAKING NEW DIRECTORIES:\"" . "\n\n";
print $file "echo \"\"" . "\n\n";

foreach my $key (keys %createList) {
	print $file "echo \"$createList{$key}\"" . "\n\n";
	print $file "mkdir " . $createList{$key} . "\n\n";
	# get file names for 3+ count
	my @names = @{$nameList{$key}};
	# for each name, add to list with correct dest
	for (@names) {
		$fileDest{$_} = $createList{$key};
	} # end for
} # end foreach

print "\n=======================================================\n\n";
print "file: $_\ndest: $fileDest{$_}\n\n" for (keys %fileDest);
print "=======================================================\n\n";
print $file "echo \"\"" . "\n\n";

foreach (keys %fileDest) {
	print $file "echo \"MOVING: " . $_ . "\"" . "\n\n";
	print $file $cmd . " " . $_ . " " . $fileDest{$_} . "\n\n";
} # end foreach

print $file "exit 0";

close $file or die $!;

#------------------------------------------------------------------------
