#!/bin/bash

if [ -z "$1" ]
then

echo "usage:"
echo "$ bash ./moveToNormSnds.sh ['./directory/sound_filename' or drag and drop sound file here]"
echo ""
exit

fi

snd="$1"

sndDir=`dirname "$snd"`
folderName=`basename "$sndDir"`

echo $folderName

lastSndFile="`ls normSnds | tail -n 1`"

echo lastSndFile: $lastSndFile

lastSndFileNum=`echo $lastSndFile | cut -d"_" -f1`

echo lastSndFileNum: $lastSndFileNum

lastSndFileNumInc=`expr $lastSndFileNum + 1`
newSndFileNum=`printf "%02d\n" $lastSndFileNumInc`

echo newSndFileNum: newSndFileNum

newSndFile=$newSndFileNum"_"$folderName".wav"

echo newSndFile: $newSndFile

sox -D "$snd" -e floating-point --norm normSnds/$newSndFile vol 0.7 rate -s -a 44100
