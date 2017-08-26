#!/bin/bash


if [ -z $1 ] || [ -z $2 ]
then
   echo "usage:"
   echo "$ bash ./finalizeComposedClips.sh [finalized images folder name] [composed clip folder name] [variable1:#]"
   echo ""
   echo "example:"
   echo "bash ./finalizeComposedClips.sh finalFrames scene1 noise:0.25"
   echo ""
   echo "noise -- 0.0 to 1.0 how much noise to add to video"
   echo ""
   exit
fi

framesFolder="./finalize/$1"

if [ ! -s "$framesFolder" ]
then
   mkdir "$framesFolder"
fi


composeFolder="./composedClips/$2"

if [ ! -s $composeFolder ]
then
   echo "Composed clip folder name does not exist."
   echo ""
   exit
fi


# set the default value for each variable
noiseVar=0

# find which of the variables exist
for var in "$@";
do

if [[ $var == $1 ]] || [[ $var == $2 ]]
then
   # ignore the first and second argument
   continue
fi

variableExists="FALSE"

if [[ $var == *"noise:"* ]]
then
   if [[ $var != "noise:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   noiseExists="TRUE"
   noiseVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "noise = $noiseVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


# find how many frames are in the composed clip folder
composeFrameBgn=500002
i=$((composeFrameBgn-1))
composeImgFile=`printf "$composeFolder/%06d.png" $i`
while [ -s "$composeImgFile" ]
do
   composeFrameBgn=$((composeFrameBgn-1))
   i=$((composeFrameBgn-1))
   composeImgFile=`printf "$composeFolder/%06d.png" $i`
done

composeFrameCnt=0
i=$((composeFrameBgn+composeFrameCnt))
composeImgFile=`printf "$composeFolder/%06d.png" $i`
while [ -s "$composeImgFile" ]
do
   composeFrameCnt=$((composeFrameCnt+1))
   i=$((composeFrameBgn+composeFrameCnt))
   composeImgFile=`printf "$composeFolder/%06d.png" $i`
done

echo "Number of frames in the composed clip folder: $composeFrameCnt"

# find how many frames are in the finalize folder
finalizeFrameCnt=0
i=$((finalizeFrameCnt+1))
finalizeImgFile=`printf "$framesFolder/%06d.jpg" $i`
while [ -s "$finalizeImgFile" ]
do
   finalizeFrameCnt=$((finalizeFrameCnt+1))
   i=$((finalizeFrameCnt+1))
   finalizeImgFile=`printf "$framesFolder/%06d.jpg" $i`
done

echo "Number of frames in the finalize folder: $finalizeFrameCnt"


# copy the new clips to the finalize folder.
echo "Copying clips to the finalize folder."

for i in `seq 1 $composeFrameCnt`;
do
   composeImgFileNum=$((composeFrameBgn+(i-1)))
   composeImgFile=`printf "$composeFolder/%06d.png" $composeImgFileNum`
   
   newFinalizeFrameNum=$((finalizeFrameCnt+i))
   finalizeImgFile=`printf "$framesFolder/%06d.jpg" $newFinalizeFrameNum`
   
   convert -size 426x240 xc: +noise Random -threshold 50% -evaluate Multiply $noiseVar -blur 0x2 $composeImgFile -compose screen -composite $finalizeImgFile
done
