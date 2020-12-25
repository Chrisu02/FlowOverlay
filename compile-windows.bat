@echo off

echo ==============================================================
echo "  ______ _                ____                 _             ";
echo " |  ____| |              / __ \               | |            ";
echo " | |__  | | _____      _| |  | |_   _____ _ __| | __ _ _   _ ";
echo " |  __| | |/ _ \ \ /\ / / |  | \ \ / / _ \ '__| |/ _` | | | |";
echo " | |    | | (_) \ V  V /| |__| |\ V /  __/ |  | | (_| | |_| |";
echo " |_|    |_|\___/ \_/\_/  \____/  \_/ \___|_|  |_|\__,_|\__, |";
echo "                                                        __/ |";
echo "  flowOverlay - modified by @Kri                       |___/ ";
echo " - based on KswOverlay by Nicholas Chum (@nicholaschum)      ";
echo ==============================================================
echo.
echo You must have Java installed on your computer (JDK and JRE)
echo If you do not have it installed, please install it before
echo running this program.

pause

echo Compiling overlay...
"%cd%\.compiler\aapt.exe" p -S "%cd%\resources\res" -M "%cd%\.compiler\manifest\QC\AndroidManifest.xml" -I "%cd%\.compiler\framework-res.apk" -F flowoverlay.apk -f

echo Signing overlay APK...
"%cd%\.compiler\apksigner.bat" sign --ks "%cd%\.compiler\overlaysig.jks" --ks-pass pass:nicholaschum --key-pass pass:nicholaschum flowoverlay.apk