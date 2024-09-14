#!/bin/bash

# Input file should be a file containing all HAR URLs (see har-extract.sh)

# Test input file if exist, or exit
if [ ! -f "$1" ]
  then
    echo "Usage: $0 <files.list>"
    exit
fi

URL_LIST=$1


# Cleaning temporary files
# - all content files from LIST
# - LIST file itself

for url in `cat $URL_LIST`
  do
    FILE_TO_CLEAN=`basename $url`
    rm $FILE_TO_CLEAN
  done;
rm $URL_LIST


