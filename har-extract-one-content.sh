#!/bin/bash

# Input file should be a HAR archive file (see har-extract.sh)

# Test input file if exist, or exit
if [ ! -f "$1" ] || [ -z "$2" ]
  then
    echo "Usage: $0 <file.har> <url-to-extract>"
    exit
fi

HAR=$1
URL_TO_EXTRACT=$2
FILENAME=`basename $URL_TO_EXTRACT`
FILENAME_DECODED=$FILENAME".decoded64"

# -----------------------------------------------------------------------------
# Test if the CONTENT exists in the HAR file
CONTENT_EXISTS=`jq 'try [.log.entries[] | select(.request.url == "'$URL_TO_EXTRACT'") | .response.content.text][0]' $HAR`
if [ "null" = "$CONTENT_EXISTS" ] # BROKEN
  then
    echo "Error: given URL does not exist: $URL_TO_EXTRACT"
    exit
fi
# -----------------------------------------------------------------------------


# Extract the content and write it in a file
cat $HAR | jq -r '[.log.entries[] | select(.request.url == "'$URL_TO_EXTRACT'") | .response.content.text][0]' > $FILENAME
#echo "Extracted $FILENAME"

# Decode base64 if necessary (can't know before trying)
base64 -d $FILENAME > $FILENAME_DECODED 2>&1

# Override the encoded file if the decoding was a success
if [ $? -eq 0 ]
  then
    mv $FILENAME_DECODED $FILENAME
    echo "Extracted $FILENAME (b64)"
  else
    rm $FILENAME_DECODED
    echo "Extracted $FILENAME (binary)"
fi
