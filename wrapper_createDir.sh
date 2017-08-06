#!/bin/bash

# call perl script to do the heavy lifting
perl ~/bin/checkDir.pl

# call the created bash script to move the files
sh ~/bin/myPerlCreateDirScript.sh

# exit cleanly
exit 0