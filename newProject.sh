#!/bin/bash

echo "Enter the name of the new project:"

read scanStrVar

newProjectName=${scanStrVar// /_}

mkdir "$newProjectName"

if [ $? -ne 0 ]
then
   exit
fi

mkdir "$newProjectName/images"
mkdir "$newProjectName/clips"
mkdir "$newProjectName/composedClips"
mkdir "$newProjectName/sounds"
mkdir "$newProjectName/normSnds"
mkdir "$newProjectName/finalize"
cp "projectTools/getImgs.sh" "$newProjectName"
cp "projectTools/getSnds.sh" "$newProjectName"
cp "projectTools/moveToClips.sh" "$newProjectName"
cp "projectTools/moveToNormSnds.sh" "$newProjectName"
cp "projectTools/createClip.sh" "$newProjectName"
cp "projectTools/composeClips.sh" "$newProjectName"
cp "projectTools/finalizeComposedClips.sh" "$newProjectName"
cp "projectTools/finalizeConvertToVid.sh" "$newProjectName"
cp "projectTools/finalizeMixAudio.sh" "$newProjectName"

echo "An empty project has been created."

sleep 2
