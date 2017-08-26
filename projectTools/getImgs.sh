#!/bin/sh

if [ -z $1 ]; then

echo "usage:"
echo "$ bash ./getImgs.sh [image key word or phrase]"
echo ""
exit

fi

phrase=`echo $* | sed -e 's/ /+/g'`

folderName=`echo $* | sed -e 's/ /_/g'`


URL="http://www.google.com/search?tbm=isch&tbs=sur:fmc&ie=ISO-8859-1&hl=en&source=hp&biw=&bih=&q=$phrase&btnG=Search+Images&gbv=1"


mkdir ./images/$folderName

for i in `seq 1 20`;
do

imagelink=$(wget --user-agent 'Mozilla/5.0' -qO - "$URL" | sed 's/</\n</g' | grep '<img' | head -n"$i" | tail -n1 | sed 's/.*src="\([^"]*\)".*/\1/')
wget $imagelink -O ./images/$folderName/$i

done
