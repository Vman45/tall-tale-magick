#!/bin/bash


if [ -z $1 ]
then
   echo "usage:"
   echo "$ bash ./composeClips.sh [composed clip folder name] [folder number:1 or 2 or 3...] [variable1:#] and or [variable2:#]"
   echo ""
   echo "example:"
   echo "bash ./composeClips.sh scene1 switch:0 overlap:10 folderNum:1"
   echo ""
   echo "folderNum -- sequence number of the folder that will be used for merging"
   echo "switch -- 0 or 1 to change if the clip will merge infront or behind"
   echo "overlap -- number of frames to overlap clips"
   echo ""
   exit
fi

composeFolder="./composedClips/$1"

if [ ! -s "$composeFolder" ]
then
   mkdir "$composeFolder"
fi


# set the default value for each variable
folderNumVar=-1
switchVar=0
overlapVar=0

# find which of the variables exist
for var in "$@";
do

if [[ $var == $1 ]]
then
   # ignore the first argument
   continue
fi

variableExists="FALSE"

if [[ $var == *"folderNum:"* ]]
then
   if [[ $var != "folderNum:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   folderNumExists="TRUE"
   folderNumVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "folderNum = $folderNumVar"
   variableExists="TRUE"
fi

if [[ $var == *"switch:"* ]]
then
   if [[ $var != "switch:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   switchExists="TRUE"
   switchVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "switch = $switchVar"
   variableExists="TRUE"
fi

if [[ $var == *"overlap:"* ]]
then
   if [[ $var != "overlap:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   overlapExists="TRUE"
   overlapVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "overlap = $overlapVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


clipNumber=`printf "%04d_" $folderNumVar`
clipFolder=`echo ./clips/$clipNumber*`

if [ ! -s $clipFolder ]
then
   echo "Clip folder number does not exist."
   echo ""
   exit
fi


# find how many frames are in the composed clips folder
composedFrameBgn=500002
i=$((composedFrameBgn-1))
composeImgFile=`printf "$composeFolder/%06d.png" $i`
while [ -s "$composeImgFile" ]
do
   composedFrameBgn=$((composedFrameBgn-1))
   i=$((composedFrameBgn-1))
   composeImgFile=`printf "$composeFolder/%06d.png" $i`
done

composedFrameCnt=0
i=$((composedFrameBgn+composedFrameCnt))
composeImgFile=`printf "$composeFolder/%06d.png" $i`
while [ -s "$composeImgFile" ]
do
   composedFrameCnt=$((composedFrameCnt+1))
   i=$((composedFrameBgn+composedFrameCnt))
   composeImgFile=`printf "$composeFolder/%06d.png" $i`
done

echo "Number of frames in the composed clips folder: $composedFrameCnt"

# find how many frames are in the clips folder
clipFrameCnt=0
i=$((clipFrameCnt+1))
clipImgFile=`printf "$clipFolder/%04d.png" $i`
while [ -s "$clipImgFile" ]
do
   clipFrameCnt=$((clipFrameCnt+1))
   i=$((clipFrameCnt+1))
   clipImgFile=`printf "$clipFolder/%04d.png" $i`
done

echo "Number of frames in clip: $clipFrameCnt"


# find if the overlap variable is too large
if [[ $composedFrameCnt != "0" ]]
then
   if (( $(bc <<< "$overlapVar > $clipFrameCnt") )) || (( $(bc <<< "$overlapVar > $composedFrameCnt") ))
   then
      echo "The overlap variable is too large."
      exit
   fi
fi


# only copy the new clips if there is nothing in the composed clips folder
if [[ $composedFrameCnt == "0" ]]
then
   echo "Copying clips to the composed clips folder."
   
   composedFrameBgn=500000
   
   for i in `seq 1 $clipFrameCnt`;
   do
      clipImgFile=`printf "$clipFolder/%04d.png" $i`
      
      newComposedFrameNum=$((composedFrameBgn+i))
      composeImgFile=`printf "$composeFolder/%06d.png" $newComposedFrameNum`
      
      cp $clipImgFile $composeImgFile
   done
   
   exit
fi


# merge the new clip with the contents in the composed clips folder
if [[ $switchVar == "0" ]]
then
   echo "Merging the new clip infront of the composed clips."
   
   for i in `seq 1 $clipFrameCnt`;
   do
      clipImgFile=`printf "$clipFolder/%04d.png" $i`
      
      newComposedFrameNum=$((composedFrameBgn+composedFrameCnt+(i-1)-overlapVar))
      composeImgFile=`printf "$composeFolder/%06d.png" $newComposedFrameNum`
      
      if (( $(bc <<< "$i <= $overlapVar") ))
      then
         convert $clipImgFile $composeImgFile -compose overlay -composite $composeImgFile
      else
         cp $clipImgFile $composeImgFile
      fi
   done
else
   echo "Merging the new clip behind the composed clips."
   
   for i in `seq 1 $clipFrameCnt`;
   do
      clipImgFile=`printf "$clipFolder/%04d.png" $i`
      
      newComposedFrameNum=$((composedFrameBgn-clipFrameCnt+(i-1)+overlapVar))
      composeImgFile=`printf "$composeFolder/%06d.png" $newComposedFrameNum`
      
      if (( $(bc <<< "$newComposedFrameNum >= $composedFrameBgn") ))
      then
         convert $clipImgFile $composeImgFile -compose overlay -composite $composeImgFile
      else
         cp $clipImgFile $composeImgFile
      fi
   done
fi
