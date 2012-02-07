#!/bin/bash
IFS=$'\n';
echo "creating directories..."
for d in `find . -type d`
do
  echo "16b/$d"
  mkdir -p 16b/$d
done;
echo "converting files..."
for f in `find . -iname "*.wav"`
do
  echo $f
  ffmpeg -i $f -acodec pcm_s16le 16b/$f
done;
