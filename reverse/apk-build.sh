#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
KEY=$SCRIPTPATH/BIB.keystore
APKTOOL=$SCRIPTPATH/apktool

OUT_APP="/tmp/final.apk"

if [[ $# -eq 1 && -f $1 ]]; then

	APP_DIR=$( echo $1 | cut -c 1-$((${#1} - 4)) )
	
	$APKTOOL b $APP_DIR

	OUTPUT_APP=$APP_DIR-mod.apk

	cp $APP_DIR/dist/$1 $OUTPUT_APP

	echo "Pass: asdf1234"
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEY $OUTPUT_APP backinblack

	# Verify
	jarsigner -verify -verbose -certs $1

	if [[ -f $OUTPUT_APP ]]; then
		rm $OUTPUT_APP
	fi

	# Align
	zipalign -v 4 $PWD/$OUTPUT_APP $OUT_APP

	# Install
	adb install -r $OUT_APP
else
	echo "Brak aplikacji do zbudowania"
fi
