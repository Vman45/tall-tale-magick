#!/bin/bash


if [ -z "$1" ] || [ ! -f $1 ]
then
   echo "usage:"
   echo "$ bash ./sndLooper.sh [sound file] [length to loop sound] [variable1:#] and or [variable2:#] and or [variable3:#]..."
   echo ""
   echo "examples:"
   echo "bash ./sndLooper.sh snd.wav loopingLgth:3.0"
   echo "bash ./sndLooper.sh snd.wav loopingLgth:2.0 cutOutBgn:0.5 cutOutEnd:1.0 rmBgning:1 rmEnding:1 fastenLeeway:0.01"
   echo ""
   echo "loopingLgth -- the length of the looping audio"
   echo "cutOutBgn -- where audio for the loop begins in seconds"
   echo "cutOutEnd -- where audio for the loop ends in seconds, -1 = end of sound"
   echo "rmBgning -- 0 = do not remove beginning (before 'cutOutBgn'), 1 = remove beginning"
   echo "rmEnding -- 0 = do not remove ending (after 'cutOutEnd'), 1 = remove ending"
   echo "fastenLeeway -- margin amount in seconds used for connecting a sound clip into a loop"
   echo ""
   echo "Note that this script will return the length of the input sound in seconds."
   echo "Note that this script will create a tempory directory with the same name as the sound file plus '_tmp' appended to it."
   echo "Note that the output will have the same name as the sound file plus '_loop' appended to it."
   echo ""
   exit
fi


# set the default value for each variable
loopingLgthVar=0
cutOutBgnVar=0.0
cutOutEndVar=-1
rmBgningVar=1
rmEndingVar=1
fastenLeewayVar=0.005


# find which of the variables exist
for var in "$@";
do

if [[ $var == $1 ]]
then
   # ignore the first argument
   continue
fi

variableExists="FALSE"

if [[ $var == *"loopingLgth:"* ]]
then
   if [[ $var != "loopingLgth:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   loopingLgthExists="TRUE"
   loopingLgthVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "loopingLgth = $loopingLgthVar"
   variableExists="TRUE"
fi

if [[ $var == *"cutOutBgn:"* ]]
then
   if [[ $var != "cutOutBgn:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   cutOutBgnExists="TRUE"
   cutOutBgnVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "cutOutBgn = $cutOutBgnVar"
   variableExists="TRUE"
fi

if [[ $var == *"cutOutEnd:"* ]]
then
   if [[ $var != "cutOutEnd:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   cutOutEndExists="TRUE"
   cutOutEndVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "cutOutEnd = $cutOutEndVar"
   variableExists="TRUE"
fi

if [[ $var == *"rmBgning:"* ]]
then
   if [[ $var != "rmBgning:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   rmBgningExists="TRUE"
   rmBgningVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "rmBgning = $rmBgningVar"
   variableExists="TRUE"
fi

if [[ $var == *"rmEnding:"* ]]
then
   if [[ $var != "rmEnding:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   rmEndingExists="TRUE"
   rmEndingVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "rmEnding = $rmEndingVar"
   variableExists="TRUE"
fi

if [[ $var == *"fastenLeeway:"* ]]
then
   if [[ $var != "fastenLeeway:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   fastenLeewayExists="TRUE"
   fastenLeewayVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "fastenLeeway = $fastenLeewayVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


sndFile=$1

# find the length of the sound
sndLgth=`soxi -d "$sndFile"`
sndLgthHr=$(echo $sndLgth | cut -d':' -f1)
sndLgthMin=$(echo $sndLgth | cut -d':' -f2)
sndLgthSec=$(echo $sndLgth | cut -d':' -f3)
sndLgthInSecs=$(awk "BEGIN{print $sndLgthHr*60*60 + $sndLgthMin*60 + $sndLgthSec}")
echo "length of audio:$sndLgthInSecs"


if [[ $loopingLgthVar == "0" ]]
then
   exit
fi

if [[ $cutOutEndVar == "-1" ]]
then
   cutOutEndVar=$sndLgthInSecs
fi

sndFilename=$(basename "$sndFile")
sndFilenameExt="${sndFilename##*.}"
tmpDir="$(dirname $sndFile)/${sndFilename%.*}_tmp"
outputFile="$(dirname $sndFile)/${sndFilename%.*}_loop.$sndFilenameExt"

mkdir $tmpDir


# cut the sound into 3 pieces
if [[ $cutOutBgnVar != "0" ]] && [[ $rmBgningVar == "0" ]]
then
   sox $sndFile $tmpDir/bgn.wav trim 0 $cutOutBgnVar
fi

sox -V1 $sndFile $tmpDir/loop.wav trim 0 $cutOutEndVar trim $cutOutBgnVar

if [[ $cutOutEndVar != "-1" ]] && [[ $rmEndingVar == "0" ]]
then
   sox $sndFile $tmpDir/end.wav trim $cutOutEndVar
fi

sndLgth=`soxi -d "$tmpDir/loop.wav"`
sndLgthHr=$(echo $sndLgth | cut -d':' -f1)
sndLgthMin=$(echo $sndLgth | cut -d':' -f2)
sndLgthSec=$(echo $sndLgth | cut -d':' -f3)
roughLoopLgth=$(awk "BEGIN{print $sndLgthHr*60*60 + $sndLgthMin*60 + $sndLgthSec}")

roughLoopLgthHalf=`awk "BEGIN{print $roughLoopLgth/2.0}"`


sox $tmpDir/loop.wav $tmpDir/loopHalf1.wav trim $roughLoopLgthHalf
sox $tmpDir/loop.wav $tmpDir/loopHalf2.wav trim 0 $roughLoopLgthHalf

sox $tmpDir/loopHalf1.wav $tmpDir/loopHalf2.wav $tmpDir/newLoop.wav splice $roughLoopLgthHalf,0,$fastenLeewayVar

sndLgth=`soxi -d "$tmpDir/newLoop.wav"`
sndLgthHr=$(echo $sndLgth | cut -d':' -f1)
sndLgthMin=$(echo $sndLgth | cut -d':' -f2)
sndLgthSec=$(echo $sndLgth | cut -d':' -f3)
newLoopLgth=$(awk "BEGIN{print $sndLgthHr*60*60 + $sndLgthMin*60 + $sndLgthSec}")


# calculate the number of loops to cover "loopingLgth"
loopCnt=$(awk "BEGIN{print int($loopingLgthVar / $newLoopLgth) + 1}")

# create the looping audio
sox $tmpDir/newLoop.wav $tmpDir/multiLoop.wav repeat $loopCnt trim 0 $loopingLgthVar


sndLgth=`soxi -d "$tmpDir/multiLoop.wav"`
sndLgthHr=$(echo $sndLgth | cut -d':' -f1)
sndLgthMin=$(echo $sndLgth | cut -d':' -f2)
sndLgthSec=$(echo $sndLgth | cut -d':' -f3)
multiLoopLgth=$(awk "BEGIN{print $sndLgthHr*60*60 + $sndLgthMin*60 + $sndLgthSec}")


if [[ $rmBgningVar == "0" ]] && [[ $rmEndingVar == "0" ]]
then
   sox $tmpDir/multiLoop.wav $tmpDir/end.wav -t sox - splice $multiLoopLgth,0,$fastenLeewayVar | sox $tmpDir/bgn.wav - $outputFile splice $cutOutBgnVar,0,$fastenLeewayVar
fi

if [[ $rmBgningVar == "1" ]] && [[ $rmEndingVar == "0" ]]
then
   sox $tmpDir/multiLoop.wav $tmpDir/end.wav $outputFile splice $multiLoopLgth,0,$fastenLeewayVar
fi

if [[ $rmBgningVar == "0" ]] && [[ $rmEndingVar == "1" ]]
then
   sox $tmpDir/bgn.wav $tmpDir/multiLoop.wav $outputFile splice $cutOutBgnVar,0,$fastenLeewayVar
fi

if [[ $rmBgningVar == "1" ]] && [[ $rmEndingVar == "1" ]]
then
   cp $tmpDir/multiLoop.wav $outputFile
fi


rm -r $tmpDir
