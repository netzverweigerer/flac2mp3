#!/bin/bash

# Simple script to convert FLAC to MP3
# http://github.com/netzverweigerer
# Usage: flac2mp3.sh <file1> [<file2> <file3> ...]

# Set options for LAME encoder
lame_opts="--vbr-new -V 2 -b 192 "

function dep_exit () {
    echo "Depency not found: $@"
    exit 1
}

for dep in flac lame metaflac; do
    which "$dep" >/dev/null 2>&1 || dep_exit "$dep"
done

for x in "${@}"
    do
    echo "Performing: $x"
    FLAC=${x}
    MP3=`basename "${FLAC%.flac}.mp3"`
    [ -r "$FLAC" ] || { echo can not read file \"$FLAC\" >&1 ; exit 1 ; } ;
    TITLE="`metaflac --show-tag=TITLE "$FLAC" | awk -F = '{ printf($2) }'`"
    ALBUM="`metaflac --show-tag=ALBUM "$FLAC" | awk -F = '{ printf($2) }'`"
    ARTIST="`metaflac --show-tag=ARTIST "$FLAC" | awk -F = '{ printf($2) }'`"
    TRACKNUMBER="`metaflac --show-tag=TRACKNUMBER "$FLAC" | awk -F = '{ printf($2) }'`"
    GENRE="`metaflac --show-tag=GENRE "$FLAC" | awk -F = '{ printf($2) }'`"
    COMMENT="`metaflac --show-tag=COMMENT "$FLAC" | awk -F = '{ printf($2) }'`"
    DATE="`metaflac --show-tag=DATE "$FLAC" | awk -F = '{ printf($2) }'`"
    flac -dc "$FLAC" | lame ${lame_opts} --tt "$TITLE" --tn "$TRACKNUMBER" --tg "$GENRE" --ty "$DATE" --ta "$ARTIST" --tl "$ALBUM" --add-id3v2 - "$MP3"
done



