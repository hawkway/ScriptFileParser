#!/usr/bin/python

#---------------------------------------------------------------------
# import required libraries

import sys
import re

#---------------------------------------------------------------------
# load files from folder into a list

with open('/home/xxxx/xxxx/xxxx/xxxx/list.txt', 'r') as myFile:
	myList = myFile.readlines()

# remove newline chars
for i, item in enumerate(myList):
	myList[i] = item.strip()

#---------------------------------------------------------------------
# load names into a list

with open('/home/xxxx/xxxx/xxxx/xxxx/masterList.txt', 'r') as myFile:
	masterList = myFile.readlines()

# remove newline chars
for i, item in enumerate(masterList):
	masterList[i] = item.strip()

#---------------------------------------------------------------------
# load names of processed files into list

with open('/home/xxxx/xxxx/xxxx/xxxx/processedList.txt', 'r') as myFile:
	processedList = myFile.readlines()

# remove newline chars
for i, item in enumerate(processedList):
	processedList[i] = item.strip()

#---------------------------------------------------------------------
# check if a digit is contained in a given string

def isNumber(s):
	return any(i.isdigit() for i in s)

#---------------------------------------------------------------------
# remove words containing digits, add the rest to a list

def removeDigits(myTitle):
	wordList = []
	for word in myTitle:
		hasDigits = isNumber(word)
		print "has digits? " + str(hasDigits)
		print "  word is: " + word
		if not hasDigits:
			wordList.append(word)
	wordList.pop()
	print
	return ' '.join(wordList)

#---------------------------------------------------------------------
# take two lists of strings, if masterItem is in localItem,
# record the index in the localList and return index list

def findMatches(myMaster, myLocal):
	resultsIndex = []
	for i in range(len(myMaster)):
		print 'myMaster: ' + myMaster[i]
		for j in range(len(myLocal)):
			print 'myLocal: ' + myLocal[j]
			if re.search(myMaster[i], myLocal[j], re.IGNORECASE):
				print
				print "MATCH FOUND"
				print "  myMaster: " + myMaster[i]
				print "  myLocal: " + myLocal[j]
				resultsIndex.append(j);
				print
		print
	return resultsIndex

#---------------------------------------------------------------------
# declare global vars

myItems = []
splitNames = []
myNames = []

print

#---------------------------------------------------------------------
# identify new items by two specific substrings

for itemName in myList:
	if 'xxxx' and 'xxxx' in itemName:
		myItems.append(itemName)
#print "myItems: "
#print myItems

#---------------------------------------------------------------------
# split file names in directory by decimal or underscore

for i in range(len(myItems)):
	myTokens = re.split('[\._]', myItems[i])
	#print myTokens
	splitNames.append(myTokens)
#print "\nsplitNames: "
#print splitNames

#---------------------------------------------------------------------
# remove words containing digits and add to a new list

for i in splitNames:
	myNames.append(removeDigits(i))
print "testing the array for matches: "
print myNames
print

#---------------------------------------------------------------------
# compare the potential targets to the names in the masterList

print 'FINDING MATCH INDEX'
print

print 'MASTER LIST'
print masterList
print

matchIndex = findMatches(masterList, myNames)

matchedNames = []
finalNames = []

for i, mIndex in enumerate(matchIndex):
	matchedNames.append(myItems[mIndex])
print "MATCHED NAMES"
print matchedNames
print

#---------------------------------------------------------------------
# compare final targets to previously processed items

print 'FINDING REMOVAL INDEX'
print

removalIndex = findMatches(processedList, matchedNames)

# make sure index elements are in the right order
# prevents nullPointer
removalIndex.sort(reverse = True)

# remove the items that have already been processed
for index in removalIndex:
	print "   trying to pop index: " + str(index)
	print "   removing name: " + matchedNames[index]
	del matchedNames[index]
	print
print "FINAL NAMES"
print matchedNames
print

#---------------------------------------------------------------------
# create bash script for copying files
dest = '~/xxxx/xxxx/'
cmd = 'cp -R'

# write the script
with open('/home/xxxx/xxxx/myParseScript.sh', 'w') as myFile:
	myFile.write('#!/bin/bash\n\n')
		myFile.write('cd ~/xxxx/xxxx/xxxx\n\n')
	for name in matchedNames:
		myFile.write('echo \"COPYING: ' + name + '\"\n\n')
		myFile.write(cmd + ' ' + name + ' ' + dest + '\n\n')
	myFile.write('exit 0')

# append selected files to the processed items list
with open('/home/xxxx/xxxx/xxxx/xxxx/processedList.txt', 'a') as myFile:
	for name in matchedNames:
		myFile.write(name + '\n')

#---------------------------------------------------------------------
