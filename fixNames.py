#!/usr/bin/python

#---------------------------------------------------------------------
# import required libraries

import re
import copy

#---------------------------------------------------------------------
# load files from folder into a list

with open('/home/xxxx/xxxx/xxxx/xxxx/list.txt', 'r') as myFile:
	myList = myFile.readlines()

# remove newline chars
for i, item in enumerate(myList):
	myList[i] = item.strip()

#---------------------------------------------------------------------
# load files from folder into a list

with open('/home/xxxx/xxxx/xxxx/xxxx/outputNames.txt', 'r') as myFile:
	myNames = myFile.readlines()

# remove newline chars
for i, item in enumerate(myNames):
	myNames[i] = item.strip()

#---------------------------------------------------------------------
# check if a digit is contained in a given string

def isNumber(s):
	return any(i.isdigit() for i in s)

#---------------------------------------------------------------------
# remove words containing digits, add the rest to a list

def removeDigits(myTitle, count):
	wordList = []
	for word in myTitle:
		hasDigits = isNumber(word)
		print "has digits? " + str(hasDigits)
		print "  word is: " + word
		if not hasDigits:
			wordList.append(word)
	for i in range(count):
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
# take two lists of strings, if local is in master,
# record the index in the local and return index list

# same as other function, but searches the local string as
# a substring of the master/source string

def reverseMatches(myMaster, myLocal):
	resultsIndex = []
	for i in range(len(myMaster)):
		print 'myMaster: ' + myMaster[i]
		for j in range(len(myLocal)):
			print 'myLocal: ' + myLocal[j]
			if re.search(myLocal[j], myMaster[i], re.IGNORECASE):
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

tempList = []
myTokens = []
hasLower = []		# original copy of the lower list
splitNames = []
lowerString = []
listString = []
properNames = []

print

#---------------------------------------------------------------------
# get list of lowercase names to be fixed

for name in myNames:
	if name.islower():
		tempList.append(name)

for i in range(len(tempList)):
	myTokens = re.split('[\._]', tempList[i])
	#print myTokens
	splitNames.append(myTokens)

for i in splitNames:
	lowerString.append(removeDigits(i, 2))
print "testing the array for matches: "
print lowerString
print

#-----------------------------------------------------
# get a full list of files where lowercase is
# lowercase file's index are needed from this list

myTokens[:] = []
splitNames[:] = []

for i in range(len(myNames)):
	myTokens = re.split('[\._]', myNames[i])
	#print myTokens
	splitNames.append(myTokens)
print splitNames

for i in splitNames:
	hasLower.append(removeDigits(i, 2))
#print "testing the array for matches: "
print hasLower
print

#---------------------------------------------------------------------
# make a copy of original files, and force to lowercase

tempList[:] = [] # clear tempList
myTokens[:] = []
splitNames[:] = []

listString = copy.deepcopy(myList)

for i, s in enumerate(myList):
	listString[i] = s.lower()

#-----------------------------------------------------
# find the index of the lowercase names in their
# original list, save as sourceName[]

print 'FINDING SOURCE NAME INDEX'
print

tempList[:] = [] # clear tempList
sourceName = []

sourceNameIndex = findMatches(lowerString, hasLower)

# select uppercase name with correct index
for index in sourceNameIndex:
	print "   accessing index: " + str(index)
	print "   selecting name: " + myNames[index]
	tempList.append(myNames[index])
	print

sourceName = copy.deepcopy(tempList)

print 'FILES TO BE RENAMED:'
print sourceName
print

#-----------------------------------------------------
# find text match files to be renamed with their
# original formatting in the main myList array

# the index of these files are saved

print 'FINDING PROPER NAME INDEX'
print

tempList[:] = [] # clear tempList

properNameIndex = reverseMatches(sourceName, listString)

# select uppercase name with correct index
for index in properNameIndex:
	print "   accessing index: " + str(index)
	print "   selecting name: " + myList[index]
	tempList.append(myList[index])
	print
print 'FILES WILL BE RENAMED TO:'
print tempList

#---------------------------------------------------------------------
# create bash script for copying files

dest = '~/xxxx/xxxx/'
cmd = 'mv'

# write the script
with open('/home/xxxx/xxxx/fixNamesScript.sh', 'w') as myFile:
	myFile.write('#!/bin/bash\n\n')
        myFile.write('cd ~/xxxx/xxxx\n\n')
	for i, name in enumerate(sourceName):
		myFile.write('echo \"FIXING: ' + name + '\"\n\n')
		myFile.write(cmd + ' ' + myNames[i] + ' ' + dest + myList[properNameIndex[i]] + '.xxx' + '\n\n')
	myFile.write('exit 0')

#---------------------------------------------------------------------
