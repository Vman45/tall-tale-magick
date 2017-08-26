#!/bin/sh

if [ -z $1 ]; then

echo "usage:"
echo "$ bash ./getSnds.sh [sound key word or phrase]"
echo ""
exit

fi

phrase=`echo $* | sed -e 's/ /+/g'`

folderName=`echo $* | sed -e 's/ /_/g'`


URL="http://www.findsounds.com/isapi/search.dll?keywords=$phrase"

mkdir ./sounds/$folderName

wavlinks=$(wget --user-agent 'Mozilla/5.0' -qO - "$URL" | grep -Eo "http://[a-zA-Z0-9./?=_-]*" | grep "\.wav")

incNum=0

for i in $wavlinks;
do

incNum=$(($incNum + 1))

wget $i -O ./sounds/$folderName/$incNum.wav

done
