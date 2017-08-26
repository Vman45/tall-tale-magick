#!/bin/bash


if [ -z $1 ]
then
   echo "usage:"
   echo "$ bash ./finalizeMixAudio.sh [output name] [audio file number:1 or 2 or 3...] [variable1:#] and or [variable2:#] and or [variable3:#]..."
   echo ""
   echo "examples:"
   echo "bash ./finalizeMixAudio.sh final testType:1 testMargin:2 sndNum:1 sndLoc:0.0"
   echo "bash ./finalizeMixAudio.sh final bpFreq:800 bpWidth:60 clipBgn:0 clipEnd:-1 fadeIn:0.05 fadeOut:0.05 gainNorm:-6 sndNum:1 sndLoc:0.0"
   echo ""
   echo "sndNum -- sequence number of the audio file that will be used"
   echo "testType -- For a quick test within a trimmed video clip. 0 = no test, 1 = no mixing, 2 = mix with the soundtrack"
   echo "testMargin -- margin size in seconds for testing within a trimmed video clip"
   echo "sndLoc -- sound location in seconds"
   echo "gainNorm -- volume normalization level in dB"
   echo "bpFreq -- bandpass location in Hz"
   echo "bpWidth -- bandpass width in Hz"
   echo "clipBgn -- where to start the audio in seconds"
   echo "clipEnd -- where to end the audio in seconds"
   echo "fadeIn -- amount of time in seconds to fade in"
   echo "fadeOut -- amount of time in seconds to fade out"
   echo ""
   exit
fi


# set the default value for each variable
sndNumVar=-1
testTypeVar=0
testMarginVar=1.5
sndLocVar=0
gainNormVar=-6
bpFreqVar=800
bpWidthVar=1600
clipBgnVar=0
clipEndVar=-1
fadeInVar=0.0
fadeOutVar=0.0


# find which of the variables exist
for var in "$@";
do

if [[ $var == $1 ]]
then
   # ignore the first argument
   continue
fi

variableExists="FALSE"

if [[ $var == *"sndNum:"* ]]
then
   if [[ $var != "sndNum:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   sndNumExists="TRUE"
   sndNumVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "sndNum = $sndNumVar"
   variableExists="TRUE"
fi

if [[ $var == *"testType:"* ]]
then
   if [[ $var != "testType:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   testTypeExists="TRUE"
   testTypeVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "testType = $testTypeVar"
   variableExists="TRUE"
fi

if [[ $var == *"testMargin:"* ]]
then
   if [[ $var != "testMargin:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   testMarginExists="TRUE"
   testMarginVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "testMargin = $testMarginVar"
   variableExists="TRUE"
fi

if [[ $var == *"sndLoc:"* ]]
then
   if [[ $var != "sndLoc:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   sndLocExists="TRUE"
   sndLocVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "sndLoc = $sndLocVar"
   variableExists="TRUE"
fi

if [[ $var == *"gainNorm:"* ]]
then
   if [[ $var != "gainNorm:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   gainNormExists="TRUE"
   gainNormVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "gainNorm = $gainNormVar"
   variableExists="TRUE"
fi

if [[ $var == *"bpFreq:"* ]]
then
   if [[ $var != "bpFreq:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   bpFreqExists="TRUE"
   bpFreqVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "bpFreq = $bpFreqVar"
   variableExists="TRUE"
fi

if [[ $var == *"bpWidth:"* ]]
then
   if [[ $var != "bpWidth:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   bpWidthExists="TRUE"
   bpWidthVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "bpWidth = $bpWidthVar"
   variableExists="TRUE"
fi

if [[ $var == *"clipBgn:"* ]]
then
   if [[ $var != "clipBgn:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   clipBgnExists="TRUE"
   clipBgnVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "clipBgn = $clipBgnVar"
   variableExists="TRUE"
fi

if [[ $var == *"clipEnd:"* ]]
then
   if [[ $var != "clipEnd:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   clipEndExists="TRUE"
   clipEndVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "clipEnd = $clipEndVar"
   variableExists="TRUE"
fi

if [[ $var == *"fadeIn:"* ]]
then
   if [[ $var != "fadeIn:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   fadeInExists="TRUE"
   fadeInVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "fadeIn = $fadeInVar"
   variableExists="TRUE"
fi

if [[ $var == *"fadeOut:"* ]]
then
   if [[ $var != "fadeOut:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   fadeOutExists="TRUE"
   fadeOutVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "fadeOut = $fadeOutVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


# create the names of the audio and video files
outputName=$1
vidFile="./finalize/"$outputName"_No_Audio.avi"
vidSndFile="./finalize/"$outputName".avi"
sndTrackFile="./finalize/"$outputName".wav"
oldSndTrackFile="./finalize/"$outputName"_Old.wav"

testVidSndFile="./finalize/"$outputName"_Test.avi"
testSndFile="./finalize/"$outputName"_Test.wav"


# find if the video file being used exists
if [ ! -s $vidFile ]
then
   echo "Video file does not exist."
   echo ""
   exit
fi


# find if the sound file being used exists
sndNumber=`printf "%02d_\n" $sndNumVar`
sndFile=`echo ./normSnds/$sndNumber*`

if [ ! -s $sndFile ]
then
   echo "Sound file does not exist."
   echo ""
   exit
fi


# find the length of the video
vidLgth=`ffmpeg -i $vidFile 2>&1 | grep "Duration" | sed 's/ //g' | cut -d',' -f1`
vidLgthHr=$(echo $vidLgth | cut -d':' -f2)
vidLgthMin=$(echo $vidLgth | cut -d':' -f3)
vidLgthSec=$(echo $vidLgth | cut -d':' -f4)

vidLgthInSecs=`bc <<< "scale=6; $vidLgthSec + $vidLgthMin*60 + $vidLgthHr*60*60"`
echo "length of video in seconds:" $vidLgthInSecs


# find the length of the sound
sndLgth=`soxi -d "$sndFile"`
sndLgthHr=$(echo $sndLgth | cut -d':' -f1)
sndLgthMin=$(echo $sndLgth | cut -d':' -f2)
sndLgthSec=$(echo $sndLgth | cut -d':' -f3)

# find the start and length of the trim effect for sox
trimStart=$clipBgnVar
if [[ $clipEndVar == "-1" ]]
then
   trimLgth=`bc <<< "scale=6; $sndLgthSec - $clipBgnVar"`
else
   trimLgth=`bc <<< "scale=6; $clipEndVar - $clipBgnVar"`
fi

sndLgthInSecs=$trimLgth
echo "length of sound after clipping:" $sndLgthInSecs


# output audio and video

if [ ! -s $sndTrackFile ]
then
   sox -n -r 44100 -e floating-point -c 2 $sndTrackFile trim 0 $vidLgthInSecs
fi

if [[ $testTypeVar == "0" ]]
then
   # mix new sound with soundtrack
   cp $sndTrackFile $oldSndTrackFile
   sox -V1 -G -D $sndFile -c 2 -p gain -n $gainNormVar trim $trimStart $trimLgth bandpass $bpFreqVar $bpWidthVar fade $fadeInVar $sndLgthInSecs $fadeOutVar pad $sndLocVar 0 trim 0 $vidLgthInSecs | sox -G -D - -m -v 1 $oldSndTrackFile $sndTrackFile fade 0.5 $vidLgthInSecs 0.5

   # mix soundtrack with video
   ffmpeg -loglevel 0 -i $vidFile -i $sndTrackFile -acodec pcm_s16le -vcodec copy -shortest $vidSndFile
fi


# find the test audio and video start and duration times
testVidStart=`bc <<< "scale=6; $sndLocVar - $testMarginVar"`

if (( $(bc <<< "$testVidStart >= 0") ))
then
   testSndLoc=$testMarginVar
   testVidLgth=`bc <<< "scale=6; $sndLgthInSecs + $testMarginVar + $testMarginVar"`
else
   testSndLoc=`bc <<< "scale=6; $testMarginVar + $testVidStart"`
   testVidLgth=`bc <<< "scale=6; $sndLgthInSecs + $testMarginVar + $testMarginVar + $testVidStart"`
   testVidStart=0
fi


# output test audio and video
if [[ $testTypeVar == "1" ]]
then
   sox -V1 -G -D $sndFile -c 2 $testSndFile gain -n $gainNormVar trim $trimStart $trimLgth bandpass $bpFreqVar $bpWidthVar fade $fadeInVar $sndLgthInSecs $fadeOutVar pad $testSndLoc $testMarginVar
   
   ffmpeg -loglevel 0 -ss $testVidStart -i $vidFile -t $testVidLgth -i $testSndFile -acodec pcm_s16le -vcodec copy -shortest $testVidSndFile
fi

if [[ $testTypeVar == "2" ]]
then
   sox -V1 -G -D $sndFile -c 2 -p gain -n $gainNormVar trim $trimStart $trimLgth bandpass $bpFreqVar $bpWidthVar fade $fadeInVar $sndLgthInSecs $fadeOutVar pad $sndLocVar 0 trim 0 $vidLgthInSecs | sox -G -D - -m -v 1 $sndTrackFile $testSndFile trim $testVidStart $testVidLgth
   
   ffmpeg -loglevel 0 -ss $testVidStart -i $vidFile -t $testVidLgth -i $testSndFile -acodec pcm_s16le -vcodec copy -shortest  $testVidSndFile
fi
