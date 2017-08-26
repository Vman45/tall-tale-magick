#!/bin/bash


if [ -z $1 ] || [ -z $2 ]
then
   echo "usage:"
   echo "$ bash ./finalizeConvertToVid.sh [video name] [finalized images folder name] [variable1:#] and or [variable2:#]"
   echo ""
   echo "example:"
   echo "bash ./finalizeConvertToVid.sh final finalFrames startFrame:0 endFrame:-1"
   echo ""
   echo "startFrame -- starting frame number"
   echo "endFrame -- ending frame number"
   echo ""
   exit
fi

videoName="./finalize/$1_No_Audio.avi"

framesFolder="./finalize/$2"

if [ ! -s "$framesFolder" ]
then
   echo "Finalized folder name does not exist."
   echo ""
   exit
fi


# set the default value for each variable
startFrameVar=0
endFrameVar=-1

# find which of the variables exist
for var in "$@";
do

if [[ $var == $1 ]] || [[ $var == $2 ]]
then
   # ignore the first and second argument
   continue
fi

variableExists="FALSE"

if [[ $var == *"startFrame:"* ]]
then
   if [[ $var != "startFrame:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   startFrameExists="TRUE"
   startFrameVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "startFrame = $startFrameVar"
   variableExists="TRUE"
fi

if [[ $var == *"endFrame:"* ]]
then
   if [[ $var != "endFrame:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   endFrameExists="TRUE"
   endFrameVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "endFrame = $endFrameVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


# convert images to video
frameCnt=$((endFrameVar-startFrameVar))

if [[ $endFrameVar == "-1" ]]
then
   ffmpeg -loglevel panic -f image2 -start_number $startFrameVar -i $framesFolder/%06d.jpg -vcodec copy -r 25 $videoName
else
   ffmpeg -loglevel panic -f image2 -start_number $startFrameVar -i $framesFolder/%06d.jpg -frames $frameCnt -vcodec copy -r 25 $videoName
fi
