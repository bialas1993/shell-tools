#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
KEY=$SCRIPTPATH/BIB.keystore
APKTOOL=$SCRIPTPATH/apktool

OUT_APP="/tmp/final.apk"

if [[ $# -eq 1 ]]; then
	#replace .apk extension
	#APP_DIR=$(realpath $( echo $1 | cut -c 1-$((${#1} - 4)) ))
	APP_DIR=$(realpath $1 )
	APP=$1.apk
	if [[ -d $APP_DIR ]]; then

		$APKTOOL b $APP_DIR

		OUTPUT_APP=$APP_DIR-mod.apk


		cp $APP_DIR/dist/$APP $OUTPUT_APP

		echo "Pass: asdf1234"
		jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEY $OUTPUT_APP backinblack

		# Verify
		jarsigner -verify -verbose -certs $APP

		if [[ -f $OUT_APP ]]; then
			rm $OUT_APP
		fi

		zipalign -v 4 $OUTPUT_APP $OUT_APP

		adb install -r $OUT_APP
	
	fi
else
	echo "Not found apk to build."
fi
