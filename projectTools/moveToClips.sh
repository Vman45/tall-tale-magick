#!/bin/bash

if [ -z "$1" ]
then
   echo "usage:"
   echo "$ bash ./moveToClips.sh [variable1:#] and or [variable2:#] ['./directory/image_filename' or drag and drop image file here]"
   echo ""
   echo "example:"
   echo "bash ./moveToClips.sh mask:2 blur:2.0 ./directory/image_filename"
   echo ""
   echo "mask -- mask number to use"
   echo "blur -- amount of blur"
   echo ""
   exit
fi


# set the default value for each variable
maskVar=1
blurVar=1.0

# find which of the variables exist
for var in "$@";
do

variableExists="FALSE"

if [[ $var == *"mask:"* ]]
then
   if [[ $var != "mask:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   maskExists="TRUE"
   maskVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "mask = $maskVar"
   variableExists="TRUE"
fi

if [[ $var == *"blur:"* ]]
then
   if [[ $var != "blur:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   blurExists="TRUE"
   blurVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "blur = $blurVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   img="$var"
fi

done


imgDir=`dirname "$img"`
folderName=`basename "$imgDir"`

echo folderName: $folderName

lastClipFolder="`ls clips | tail -n 1`"

echo lastClipFolder: $lastClipFolder

lastClipNumber=`echo $lastClipFolder | cut -d"_" -f1`

echo lastClipNumber: $lastClipNumber

lastClipNumInc=`expr $lastClipNumber + 1`
newClipNumber=`printf "%04d\n" $lastClipNumInc`

echo newClipNumber: $newClipNumber

newClipFolder=$newClipNumber"_"$folderName

echo newClipFolder: $newClipFolder


mkdir ./clips/$newClipFolder


imgWidthHeight=`identify -format '%wx%h' "$img"`

echo imgWidthHeight: $imgWidthHeight

#convert is an ImageMagick program (it first changes mask.png size the mask is used as opacity data) then it makes a composite using both the given image and the mask
#The image is also changed to grayscale
convert "$img" \( ../projectTools/mask$maskVar.png -scale $imgWidthHeight! \) -compose CopyOpacity -composite -colorspace gray -scale 426x240 -blur 0x$blurVar ./clips/$newClipFolder/0.png
