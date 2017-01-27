#!/bin/bash
if [[ $# -eq 1 && -f $1 ]]; then

	APP_DIR=$( echo $1 | cut -c 1-$((${#1} - 4)) )

	OUT_APP="final.apk"
	./apktool b $APP_DIR

	OUTPUT_APP=$APP_DIR-mod.apk

	cp $APP_DIR/dist/$1 ./$APP_DIR-mod.apk



	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore BIB.keystore $OUTPUT_APP backinblack

	# Verify
	jarsigner -verify -verbose -certs $1

	if [[ -f $$OUTPUT_APP ]]; then
		rm $$OUTPUT_APP
	fi

	# Align
	/opt/android-sdk/build-tools/25.0.0/zipalign -v 4 $OUTPUT_APP final.apk

	# Install
	adb install -r final.apk
else
	echo "Brak aplikacji do zbudowania"
fi
