@echo off
taskkill /f /im adb.exe

echo ==============================================================
echo "  ______ _                ____                 _             ";
echo " |  ____| |              / __ \               | |            ";
echo " | |__  | | _____      _| |  | |_   _____ _ __| | __ _ _   _ ";
echo " |  __| | |/ _ \ \ /\ / / |  | \ \ / / _ \ '__| |/ _` | | | |";
echo " | |    | | (_) \ V  V /| |__| |\ V /  __/ |  | | (_| | |_| |";
echo " |_|    |_|\___/ \_/\_/  \____/  \_/ \___|_|  |_|\__,_|\__, |";
echo "                                                        __/ |";
echo "  flowOverlay v1.1 - modified by @Kri                  |___/ ";
echo " - based on KswOverlay by Nicholas Chum (@nicholaschum)      ";
echo ==============================================================
echo.
echo This will set up your device to be able to easily install
echo overlay APKs through the file browser or directly.
echo Ensure you already have compiled your flowOverlay apk !
echo.
SET /p _IP= enter the IP address of the device (e.g. 192.168.0.1): 
@echo connecting to device ....
:initialconnect
@echo If %_ip% cannot be connected please check IP address again
timeout 2
ping -n 1 %_ip% |find "TTL=" || goto :initialconnect
echo Answer received.
"%cd%\.compiler\adb" connect %_ip%:5555
"%cd%\.compiler\adb" root
"%cd%\.compiler\adb" remount
set _inputname=%_ip%:5555

:menu
cls
echo ==============================================================
echo "  ______ _                ____                 _             ";
echo " |  ____| |              / __ \               | |            ";
echo " | |__  | | _____      _| |  | |_   _____ _ __| | __ _ _   _ ";
echo " |  __| | |/ _ \ \ /\ / / |  | \ \ / / _ \ '__| |/ _` | | | |";
echo " | |    | | (_) \ V  V /| |__| |\ V /  __/ |  | | (_| | |_| |";
echo " |_|    |_|\___/ \_/\_/  \____/  \_/ \___|_|  |_|\__,_|\__, |";
echo "                                                        __/ |";
echo "  flowOverlay v1.1 - modified by @Kri                  |___/ ";
echo " - based on KswOverlay by Nicholas Chum (@nicholaschum)      ";
echo ==============================================================
echo.
echo.  Connected IP Address: %_inputname%
echo.
echo.  Press "1" to install and enable
echo.  Press "2" to update and enable
echo.  Press "5" to enable flowOverlay
echo.  Press "6" to disable flowOverlay
echo.  Press "7" to reboot device
echo.
set installer=
set /P installer= Please select a number or press enter to end the script 
echo.
IF "%installer%"=="1" GOTO :installflow625
IF "%installer%"=="2" GOTO :updateflow625
IF "%installer%"=="5" GOTO :enableflowmanual 
IF "%installer%"=="6" GOTO :disableflow
IF "%installer%"=="7" GOTO :rebooting
IF "%installer%" not defined GOTO :end

::functions

:pingloop
echo Waiting until %_ip% is reachable again...
timeout 3 >nul
ping -n 1 %_ip% |find "TTL=" || goto :pingloop
echo Answer received.
goto :eof

:connecting
echo Connecting to device...
"%cd%\.compiler\adb" disconnect
"%cd%\.compiler\adb" connect "%_inputname%"
timeout 1 >nul
echo Perfoming adb root
"%cd%\.compiler\adb" root
timeout 1 >nul
echo performing adb remount
"%cd%\.compiler\adb" remount
timeout 1 >nul
goto :eof

:disableverity
echo Performing disable-verity
"%cd%\.compiler\adb" disable-verity
timeout 1 >nul
echo rebooting device
start "" /min "%CD%\.compiler\adb.exe" reboot
timeout 1 >nul
goto :eof

:enableflow
echo Activating flow.overlay ...
timeout 1 >nul
"%cd%\.compiler\adb" shell cmd overlay enable flow.overlay
echo.
echo flow.overlay enabled - you may need to reboot device to take effect
goto :eof

:filesSD625
echo Pushing flowoverlay ...
"%cd%\.compiler\adb" push "%cd%\flowoverlay.apk" /storage/emulated/0
"%cd%\.compiler\adb" shell mv /storage/emulated/0/flowoverlay.apk /system/app
"%cd%\.compiler\adb" shell chmod 644 /system/app/flowoverlay.apk
timeout 3 >nul
goto :eof

:filesPX6
echo Pushing flowoverlay ...
"%cd%\.compiler\adb" push "%cd%\flowoverlay-px6.apk" /storage/emulated/0
"%cd%\.compiler\adb" shell mv /storage/emulated/0/flowoverlay-px6.apk /system/app
"%cd%\.compiler\adb" shell chmod 644 /system/app/flowoverlay-px6.apk
timeout 3 >nul
goto :eof

:: scripts

:installflow625
call :pingloop
call :connecting
call :disableverity
call :pingloop
call :connecting
call :filesSD625
echo Rebooting device...
start "" /min "%CD%\.compiler\adb.exe" reboot
call :pingloop
call :connecting
call :enableflow
echo Rebooting device...
start "" /min "%CD%\.compiler\adb.exe" reboot
pause
goto :menu

:updateflow625
call :pingloop
call :connecting
call :filesSD625
call :enableflow
echo Rebooting device...
start "" /min "%CD%\.compiler\adb.exe" reboot
pause
goto :menu

:enableflowmanual
call :connecting
call :enableflow
pause
goto :menu

:disableflow
call :connecting
echo Disabling overlay...
"%cd%\.compiler\adb" shell cmd overlay disable flow.overlay
echo.
echo flow.overlay disabled - you may need to reboot device to take effect
pause
Goto :menu

:rebooting
echo Rebooting device...
start "" /min "%CD%\.compiler\adb.exe" reboot
echo Rebooting your tablet, now wait till it boots up again
pause
goto :menu

:end
pause
exit
