#!/bin/sh

	echo ==============================================================
	echo "  ______ _                ____                 _             ";
	echo " |  ____| |              / __ \               | |            ";
	echo " | |__  | | _____      _| |  | |_   _____ _ __| | __ _ _   _ ";
	echo " |  __| | |/ _ \ \ /\ / / |  | \ \ / / _ \ '__| |/ _  | | | |";
	echo " | |    | | (_) \ V  V /| |__| |\ V /  __/ |  | | (_| | |_| |";
	echo " |_|    |_|\___/ \_/\_/  \____/  \_/ \___|_|  |_|\__,_|\__, |";
	echo "                                                        __/ |";
	echo "  flowOverlay - modified by @Kri                       |___/ ";
	echo " - based on KswOverlay by Nicholas Chum (@nicholaschum)      ";
	echo ==============================================================
echo
echo Compiling overlay...
./.compiler/aapt p -S resources/res -M .compiler/manifest/QC/AndroidManifest.xml -I .compiler/framework-res.apk -F flowoverlay.apk -f

echo Signing overlay APK...
./.compiler/apksigner sign --ks .compiler/overlaysig.jks --ks-pass pass:nicholaschum --key-pass pass:nicholaschum flowoverlay.apk
