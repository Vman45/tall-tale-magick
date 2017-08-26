# Tall Tale Magick
A story telling tool made with linux shell scripts that use imagemagick, sox, and ffmpeg for building animations.  

![](https://github.com/lowlevel86/tall-tale-magick/blob/master/flyingPig.jpg)

![](https://github.com/lowlevel86/tall-tale-magick/blob/master/ghost.jpg)

You can easily create an animation complete with sound using nothing except the command line.  

#### To get started you will need:  
* linux (a nice operating system for developers)  
* wget  
* imagemagick  
* sox  
* ffmpeg  
* nautilus-open-terminal or similar (optional, allows easy access to a terminal by right clicking)  

#### Step 1:  
Create a new project by double clicking 'newProject.sh' and click 'Run in Terminal'. Type in the name of your new project and press enter.  

Note: Make sure the permissions of 'newProject.sh' allows execution.  

#### Step 2:  
Get a terminal within the directory of your project folder (could use nautilus-open-terminal). Type in:  
$ ls (to view the contents of the directory)  
$ bash (make sure there is a space after bash and double click 'getImgs.sh' within the terminal then middle click 'getImgs.sh' to copy it)  
$ bash getImgs.sh (it should look like this)  

Press enter and it should output:  
usage:  
$ bash ./getImgs.sh [image key word or phrase]  

And you use it just like it says.  

Note: This program will download images off the internet using 'wget' and a search engine.  

#### Step 3:  
$ bash moveToClips.sh (it should look like this)  

Press enter and it should output:  
usage:  
$ bash ./moveToClips.sh [variable1:#] and or [variable2:#] ['./directory/image_filename' or drag and drop image file here]  

example:  
bash ./moveToClips.sh mask:2 blur:2.0 ./directory/image_filename  

mask -- mask number to use  
blur -- amount of blur  

Now go into the 'images' folder and use the example:  
$ bash ./moveToClips.sh mask:2 blur:2.0 (drag and drop image)  

Note: It is also possible to use your own images.  

#### Step 4:  
$ bash createClip.sh (it should look like this)  
Now go into the 'clips' folder and use the example and play around.  

#### Step 5:  
$ bash composeClips.sh (it should look like this)  
Now go into the 'composedClips' folder and use the example.  

#### Step 6:  
$ bash finalizeComposedClips.sh (it should look like this)  
Now go into the 'finalize' folder and use the example.  

#### Step 7:  
$ bash finalizeConvertToVid.sh (it should look like this)  
Use the example.  

#### Step 8:  
$ bash getSnds.sh (it should look like this)  

Note: This program will download sounds off the internet using 'wget' and a search engine.  

#### Step 9:  
$ bash moveToNormSnds.sh (it should look like this)  
Now go into the 'sounds' folder and use the example.  

Note: It is also possible to use your own sounds.  

#### Step 10:  
$ bash finalizeMixAudio.sh (it should look like this)  
Go into both the 'normSnds' and 'finalize' folders and try out the different options.
