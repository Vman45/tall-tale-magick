#!/bin/bash


if [ -z $1 ]
then
   echo "usage:"
   echo "$ bash ./createClip.sh [folder number:1 or 2 or 3...] [variable1:#] and or [variable2:#] and or [variable3:#]..."
   echo ""
   echo "example:"
   echo "bash ./createClip.sh frames:125 fadeIn:25 fadeOut:25 mirror:1 opacity:100 animatePerim:10 animateVigor:70 scaleA:1.0 scaleB:1.0 rotA:0 rotB:0 xA:213 yA:120 xB:213 yB:120 folderNum:1"
   echo ""
   echo "folderNum -- sequence number of the folder where the frames will be created"
   echo "frames -- number of frames"
   echo "fadeIn -- number of frames to fade in"
   echo "fadeOut -- number of frames to fade out"
   echo "mirror -- 0 or 1 to flip image horizontally"
   echo "opacity -- 0 to 100% effects transparency"
   echo "animatePerim -- 0 to 100%+ animates and confines the amount the image moves"
   echo "animateVigor -- 0 to 100% controls automatic animation speed"
   echo "scaleA -- +-1.0 starting image scale"
   echo "scaleB -- +-1.0 ending image scale"
   echo "rotA -- (degrees) starting image rotation"
   echo "rotB -- (degrees) ending image rotation"
   echo "xA -- (pixels) starting image location"
   echo "yA -- (pixels) starting image location"
   echo "xB -- (pixels) ending image location"
   echo "yB -- (pixels) ending image location"
   echo ""
   exit
fi


# set the default value for each variable
folderNumVar=-1
framesVar=125
fadeInVar=-1
fadeOutVar=-1
mirrorVar=0
opacityVar=100
animatePerimVar=0
animateVigorVar=0
scaleAVar=1.0
scaleBVar=1.0
rotAVar=0
rotBVar=0
xAVar=213
yAVar=120
xBVar=213
yBVar=120


# find which of the variables exist
for var in "$@";
do

variableExists="FALSE"

if [[ $var == *"folderNum:"* ]]
then
   if [[ $var != "folderNum:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   folderNumExists="TRUE"
   folderNumVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "folderNum = $folderNumVar"
   variableExists="TRUE"
fi

if [[ $var == *"frames:"* ]]
then
   if [[ $var != "frames:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   framesExists="TRUE"
   framesVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "frames = $framesVar"
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

if [[ $var == *"mirror:"* ]]
then
   if [[ $var != "mirror:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   mirrorExists="TRUE"
   mirrorVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "mirror = $mirrorVar"
   variableExists="TRUE"
fi

if [[ $var == *"opacity:"* ]]
then
   if [[ $var != "opacity:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   opacityExists="TRUE"
   opacityVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "opacity = $opacityVar"
   variableExists="TRUE"
fi

if [[ $var == *"animatePerim:"* ]]
then
   if [[ $var != "animatePerim:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   animatePerimExists="TRUE"
   animatePerimVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "animatePerim = $animatePerimVar"
   variableExists="TRUE"
fi

if [[ $var == *"animateVigor:"* ]]
then
   if [[ $var != "animateVigor:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   animateVigorExists="TRUE"
   animateVigorVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "animateVigor = $animateVigorVar"
   variableExists="TRUE"
fi

if [[ $var == *"scaleA:"* ]]
then
   if [[ $var != "scaleA:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   scaleAExists="TRUE"
   scaleAVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "scaleA = $scaleAVar"
   variableExists="TRUE"
fi

if [[ $var == *"scaleB:"* ]]
then
   if [[ $var != "scaleB:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   scaleBExists="TRUE"
   scaleBVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "scaleB = $scaleBVar"
   variableExists="TRUE"
fi

if [[ $var == *"rotA:"* ]]
then
   if [[ $var != "rotA:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   rotAExists="TRUE"
   rotAVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "rotA = $rotAVar"
   variableExists="TRUE"
fi

if [[ $var == *"rotB:"* ]]
then
   if [[ $var != "rotB:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   rotBExists="TRUE"
   rotBVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "rotB = $rotBVar"
   variableExists="TRUE"
fi

if [[ $var == *"xA:"* ]]
then
   if [[ $var != "xA:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   xAExists="TRUE"
   xAVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "xA = $xAVar"
   variableExists="TRUE"
fi

if [[ $var == *"yA:"* ]]
then
   if [[ $var != "yA:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   yAExists="TRUE"
   yAVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "yA = $yAVar"
   variableExists="TRUE"
fi

if [[ $var == *"xB:"* ]]
then
   if [[ $var != "xB:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   xBExists="TRUE"
   xBVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "xB = $xBVar"
   variableExists="TRUE"
fi

if [[ $var == *"yB:"* ]]
then
   if [[ $var != "yB:"* ]]; then echo "\""$var"\"" "is not a variable"; exit; fi
   yBExists="TRUE"
   yBVar=`echo "$var" | sed 's/.*:\(.*\).*/\1/'`
   echo "yB = $yBVar"
   variableExists="TRUE"
fi

if [[ $variableExists == "FALSE" ]]
then
   echo "\""$var"\"" "is not a variable"
   exit
fi

done


imgNumber=`printf "%04d_\n" $folderNumVar`
imgFolder=`echo ./clips/$imgNumber*`

echo $imgFolder

if [ ! -s $imgFolder ]
then
   echo "Folder does not exist."
   echo ""
   exit
fi


# later add switch for flipping image horizontally
if [[ $mirrorVar != "0" ]]
then
   flopSwitch="-flop"
else
   flopSwitch=""
fi


# initialize variables for finding the transparency of the image
fadeInAmt=0
fadeOutAmt=0


# initialize variables for automatically animating the image
newVarsfrequency=0

# find the amount of movement defined by "animateVigor"
animAmt=`bc <<< "scale=6; $animatePerimVar / 100.0"`

autoScaleA=1.0
autoScaleB=`bc <<< "scale=6; 1.0 + ($RANDOM / 32767.0 * 2.0 - 1.0) * $animAmt"`

autoRotA=0
autoRotB=`bc <<< "scale=6; ($RANDOM / 32767.0 * 2.0 - 1.0) * 180 * $animAmt"`

xAutoLocA=213
yAutoLocA=120
xAutoLocB=`bc <<< "scale=6; 213 + ($RANDOM / 32767.0 * 2.0 - 1.0) * 213 * $animAmt"`
yAutoLocB=`bc <<< "scale=6; 120 + ($RANDOM / 32767.0 * 2.0 - 1.0) * 120 * $animAmt"`


for i in `seq 1 $framesVar`;
do

   echo $imgFolder/`printf "%04d" $i`.png
   
   
   # #################### find the transparency of the image ####################
   
   # initialize variables for finding the transparency of the image
   opaqueAmt=100
   
   # find amount to fade in
   if (( $(bc <<< "$fadeInVar > 0") )) && (( $(bc <<< "$i <= $fadeInVar") ))
   then
      # the first frame is completely transparent
      if [[ "$i" != "1" ]]
      then
         fadeInAmt=`bc <<< "scale=6; $fadeInAmt + 100.0 / $fadeInVar"`
      fi
      
      opaqueAmt=`bc <<< "scale=6; ($opaqueAmt / 100.0 * $fadeInAmt)"`
   fi
   
   # find amount to fade out
   if (( $(bc <<< "$fadeOutVar <= $framesVar") )) && (( $(bc <<< "$i > $((framesVar-fadeOutVar))") ))
   then
      fadeOutAmt=`bc <<< "scale=6; $fadeOutAmt + 100.0 / $fadeOutVar"`
      
      opaqueAmt=`bc <<< "scale=6; ($opaqueAmt / 100.0 * (100-$fadeOutAmt))"`
   fi
   
   # calculate how transparent the image should be
   transparent=`bc <<< "scale=6; 100 - ($opacityVar / 100.0 * $opaqueAmt)"`
   
   # #################### end of find the transparency of the image ####################
   
   
   # #################### find scale, rotation, & translation of image ####################
   
   # formula used:
   # result = (B - A) * Percent_of_Change + A
   
   imgScale=`bc <<< "scale=6; ($scaleBVar - $scaleAVar) * (($i-1)/$framesVar) + $scaleAVar"`
   
   imgRot=`bc <<< "scale=6; ($rotBVar - $rotAVar) * (($i-1)/$framesVar) + $rotAVar"`
   
   xImgLoc=`bc <<< "scale=6; ($xBVar - $xAVar) * (($i-1)/$framesVar) + $xAVar"`
   yImgLoc=`bc <<< "scale=6; ($yBVar - $yAVar) * (($i-1)/$framesVar) + $yAVar"`
   
   # #################### end of find scale, rotation, & translation of image ####################
   
   
   # #################### automatic random animation ####################
   
   # reassign new variables at a frequency defined by "animateVigor"
   if (( $(bc <<< "$newVarsfrequency >= (100 - $animateVigorVar)") ))
   then
      # reassign random scale, rotation, & translation variables
      autoScaleA=$autoScaleB
      autoScaleB=`bc <<< "scale=6; 1.0 + ($RANDOM / 32767.0 * 2.0 - 1.0) * $animAmt"`
      
      autoRotA=$autoRotB
      autoRotB=`bc <<< "scale=6; ($RANDOM / 32767.0 * 2.0 - 1.0) * 180 * $animAmt"`
      
      xAutoLocA=$xAutoLocB
      yAutoLocA=$yAutoLocB
      xAutoLocB=`bc <<< "scale=6; 213 + ($RANDOM / 32767.0 * 2.0 - 1.0) * 213 * $animAmt"`
      yAutoLocB=`bc <<< "scale=6; 120 + ($RANDOM / 32767.0 * 2.0 - 1.0) * 120 * $animAmt"`
      
      newVarsfrequency=0
   fi
   
   
   # find the percent of change for the automatic scale, rotation, & translation animations
   if (( $(bc <<< "(100 - $animateVigorVar) != 0") ))
   then
      chgAmt=`bc <<< "scale=6; $newVarsfrequency / (100 - $animateVigorVar)"`
   else
      chgAmt=1.0
   fi
   
   
   # formula used:
   # result = (B - A) * Percent_of_Change + A
   
   autoScale=`bc <<< "scale=6; ($autoScaleB - $autoScaleA) * $chgAmt + $autoScaleA"`
   
   autoRot=`bc <<< "scale=6; ($autoRotB - $autoRotA) * $chgAmt + $autoRotA"`
   
   xAutoLoc=`bc <<< "scale=6; ($xAutoLocB - $xAutoLocA) * $chgAmt + $xAutoLocA"`
   yAutoLoc=`bc <<< "scale=6; ($yAutoLocB - $yAutoLocA) * $chgAmt + $yAutoLocA"`
   
   
   newVarsfrequency=`bc <<< "scale=6; $newVarsfrequency + 1"`
   
   
   # add automatic animated scale to current scale
   imgScale=`bc <<< "scale=6; $autoScale * $imgScale"`
   
   # add automatic animated rotation to current rotation
   imgRot=`bc <<< "scale=6; ($autoRot - $imgRot) * 0.5 + $imgRot"`
   
   # add automatic animated location to current location
   xImgLoc=`bc <<< "scale=6; ($xAutoLoc - $xImgLoc) * 0.5 + $xImgLoc"`
   yImgLoc=`bc <<< "scale=6; ($yAutoLoc - $yImgLoc) * 0.5 + $yImgLoc"`
   
   # #################### end of automatic random animation ####################
   
   
   # create image using the imageMagick program "convert"
   
   # use ./imgFolder/0.png for creating a clip
   # -alpha on -- add or preserve alpha channel
   # -flop ($flopSwitch) -- horizontally flips image
   # -channel A -evaluate subtract -- % makes image more transparent
   # -background rgba\(0,0,0,0\) -- makes the background transparent
   # -gravity center -- moves image to the center
   # -extent 426x240 -- change canvas edges to a different size
   # -distort ScaleRotateTranslate 'center,position xScale,yScale rotation xNewLoc,yNewLoc'
   # $imgFolder/`printf "%04d" $i`.png is the output image
   convert $imgFolder/0.png \
   -alpha on \
   $flopSwitch \
   -channel A -evaluate subtract $transparent% \
   -background rgba\(0,0,0,0\) \
   -gravity center \
   -extent 426x240 \
   -distort ScaleRotateTranslate "213,120 $imgScale,$imgScale $imgRot $xImgLoc,$yImgLoc" \
   $imgFolder/`printf "%04d" $i`.png

done
