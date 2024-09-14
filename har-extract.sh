#!/bin/bash

# Parent script

# Test input file if exist, or exit
if [ ! -f "$1" ]
  then
    echo "Usage: $0 <file.har> [quality]"
    exit
fi

HAR=$1
URL_LIST=$HAR".list"
OUTPUT_VIDEO_FILE=`basename $HAR .har`".mp4"
OUTPUT_VIDEO_QUALITY=`basename $2 .m3u8`".m3u8"


# Step 1 : HAR analysis
# Output : list of content matching interesting patterns
# Note: param '-r' to display raw output = remove unwanted quotes around the result
echo "Step 1: Looking into $HAR"
cat $HAR | jq -r '.log.entries[] | select((.request.url|endswith(".ts")) or (.request.url|endswith(".m3u8")) or (.request.url|endswith(".key"))) | .request.url' | sort | uniq > $URL_LIST

# Step 2 : HAR extraction based on list from [Step 1]
# Output : 1 file per content
echo "Step 2: extracting raw content"
for url in `cat $URL_LIST`; do ./har-extract-one-content.sh $HAR $url; done;

# Step 3 : Select quality when multiple playlists files (probably not all are complete)
echo "Step 3: selecting quality"
M3U8_PLAYLISTS=`ls *.m3u8`
if [ ! -f $OUTPUT_VIDEO_QUALITY ] && [ `ls *.m3u8 | wc -l` -gt 1 ]
  then
    echo "Multiple playlists : $M3U8_PLAYLISTS"
    read -p "Choose quality: " OUTPUT_VIDEO_QUALITY
elif [ ! -f $OUTPUT_VIDEO_QUALITY ]
  then
    OUTPUT_VIDEO_QUALITY=$M3U8_PLAYLISTS
fi
echo "Quality set to $OUTPUT_VIDEO_QUALITY"

# Step 4 : Run ffmpeg based on m3u8 playlist to decode the video
# Output : an mp4 file
echo "Step 4: ffmpeg"
# ffmpeg -allowed_extensions ALL -protocol_whitelist file,http,https,tcp,tls,crypto -i 480p.m3u8 -c copy $OUTPUT_VIDEO_FILE
ffmpeg -allowed_extensions ALL -i $OUTPUT_VIDEO_QUALITY -c copy $OUTPUT_VIDEO_FILE


# Step 5 : Cleaning temporary files
# - all content files
# - list file
if [ $? -eq 0 ]
  then
    ./har-cleanup.sh $URL_LIST
    echo "Cleaning complete"
  else
    echo "Failed. Not cleaning."
fi

