#!/bin/bash

if [[ $# -eq 1 && -f $1 ]]; then

	APP_DIR=$( echo $1 | cut -c 1-$((${#1} - 4)) )

	./apktool b $APP_DIR

	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore BIB.keystore $1 backinblack

	# Verify
	jarsigner -verify -verbose -certs $1

	rm final.apk

	# Align
	/opt/android-sdk/build-tools/25.0.0/zipalign -v 4 $1 final.apk

	# Install
	adb install -r final.apk
else
	echo "Brak aplikacji do zbudowania"
fi
