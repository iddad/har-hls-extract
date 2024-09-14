# har-hls-extract
Extract a HLS stream from a HAR archive using a simple shell script.

Feel free to use it, modify, extend, share.

# Usage
```sh
./har-extract.sh <archive.har> [quality]
```

# How does it work?
* Open and read the HAR archive
* Extract each stream content (playlist, video parts, optional encryption)
* Deserialize content if necessary
* Convert to a single video file using FFmpeg (mp4 format).

# Requirements
* A HAR archive containing a complete HLS stream
* `jq` dependency for JSON analysis
* `ffmpeg` dependency to open and convert the extracted stream to a final video file.

This script does not install anything on your computer, so you're safe.

# Installation
Just make the scripts executable, and install `jq` and `ffmpeg` if you don't already have those tools.
```sh
chmod +x har-extract.sh
chmod +x har-extract-one-content.sh
chmod +x har-cleanup.sh
```

# What it does NOT do
This is a very simple script, easy to read and easy to maintain. Therefore it has some limitations:
* it does not check if the stream if complete
* if does not handle multiple streams of the same quality in the same HAR archive
