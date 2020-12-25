#!/bin/bash
set +v

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[1;32m'
PURPLE='\033[0;35m'
STD='\033[0;0;39m'

header(){
	
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
}

menu(){
	clear
	header
	echo -e "${PURPLE}"
	echo -e Connected IP Address: ${headunit_ip}
	echo -e "${STD} "
	echo  [1] Snapdragon 625 initial setup and enable
	echo  [2] Snapdragon 625 update and enable
	echo  [3] PX6 initial setup and enable
	echo  [4] PX6 update and enable
	echo  [5] Enable flowOverlay
	echo  [6] Disable flowOverlay
	echo  [7] Reboot device
	echo  [8] Reveal factory passcode
	echo  [9] Enable safe media bypass \(100% volume after reboot\)
	echo  [0] Exit
	echo  " "

}

menu_options(){
	local choice
	read -p "Enter a choice [0 - 9] " choice
	case $choice in
		1) clear; installflow625 ;;
		2) clear; updateflow625 ;;
		3) clear; installflowPX6 ;;
		4) clear; updateflowPX6 ;;
		5) clear; enableflowmanual ;;
		6) clear; disableflow ;;
		7) clear; rebootdevice ;;
		8) clear; get_passcode ;;
		9) clear; enable_safe_media_bypass;;
		0) exit 0;;
		*) echo -e "${RED}Not sure what you mean! Try again.${STD}" && sleep 1 && menu
	esac
}

networkcheck() {
	echo Waiting for $headunit_ip to become available...
	#until ping -c1 $headunit_ip >/dev/null 2>&1; do sleep 2; done
	until nc -vzw 2 $headunit_ip 5555 >/dev/null 2>&1; do sleep 3; done
	echo Found device
	sleep 1
}

connecting() {
	echo Connecting to device...
	.compiler/adb disconnect > /dev/null
	.compiler/adb connect $headunit_ip
	sleep 1
	echo Perfoming adb root
	.compiler/adb root > /dev/null
	sleep 1
	echo Performing adb remount
	.compiler/adb remount  > /dev/null
	sleep 1
}

disableverity() {
	echo Disabling verity
	.compiler/adb disable-verity > /dev/null
}

enableflow() {
	echo Activating flow.overlay
	sleep 1
	.compiler/adb shell cmd overlay enable flow.overlay
	echo -e "${GREEN}flow.overlay ENABLED${STD}"
}

filesSD625() {
	echo Pushing flowoverlay ...
	.compiler/adb push flowoverlay.apk /storage/emulated/0
	.compiler/adb shell mv /storage/emulated/0/flowoverlay.apk /system/app
	.compiler/adb shell chmod 644 /system/app/flowoverlay.apk
	sleep 3
}

filesPX6() {
	echo Pushing flowoverlay ...
	.compiler/adb push flowoverlay-px6.apk /storage/emulated/0
	.compiler/adb shell mv /storage/emulated/0/flowoverlay-px6.apk /system/app
	.compiler/adb shell chmod 644 /system/app/flowoverlay-px6.apk
	sleep 3
}

pause() {
	read -rsp $'Press any key to continue...\n' -n 1 key
}

rebootdevice() {
	read -rsp $'Rebooting in 5 seconds or press a key to reboot now...\n' -n 1 -t 5;
	echo Rebooting device...
	.compiler/adb reboot & # does not always receive a response so continue with script in the meantime
	sleep 8 # wait before trying to reconnect
}

#-----------------------------------
#
#	Menu functions
#
#-----------------------------------

installflow625() {
	networkcheck
	connecting
	disableverity
	rebootdevice
	networkcheck
	connecting
	filesSD625
	rebootdevice
	networkcheck
	connecting
	enableflow
	rebootdevice
	pause
}


updateflow625() {
	networkcheck
	connecting
	filesSD625
	enableflow
	rebootdevice
	pause
}

installflowPX6() {
	networkcheck
	connecting
	disableverity
	rebootdevice
	networkcheck
	connecting
	filesPX6
	rebootdevice
	networkcheck
	connecting
	enableflow
	rebootdevice
	pause
}


updateflowPX6() {
	networkcheck
	connecting
	filesPX6
	enableflow
	rebootdevice
	pause
}


enableflowmanual() {
	connecting
	enableflow
	pause
}

get_passcode() {
	#connecting
	echo Fetching passcode from device...
	#.compiler/adb shell cat /mnt/vendor/persist/OEM/factory_config.xml | grep password
	passcode=$(.compiler/adb shell cat /mnt/vendor/persist/OEM/factory_config.xml  2>/dev/null | grep password | sed "s/[^0-9]//g")
	if [ $passcode ]
	then
		echo  -e "Passcode: ${GREEN}${passcode}${STD}"
	else
		echo -e "${RED}Passcode not found${STD}"
	fi
	pause
}

get_factoryconfig() {
	echo Downloading factory config from device...
	.compiler/adb pull /mnt/vendor/persist/OEM/factory_config.xml
	pause
}

install_buildprop() {
	.compiler/adb push build.prop /storage/emulated/0/ 
	.compiler/adb shell mv /storage/emulated/0/build.prop /system/build.prop
	.compiler/adb shell chmod 644 /system/build.prop
}

enable_safe_media_bypass() {
	networkcheck
	connecting
	disableverity
	rebootdevice
	networkcheck
	connecting
	.compiler/adb pull /system/build.prop > /dev/null
	cp build.prop build.prop.backup > /dev/null

	CHECKEXISTS=$(grep "audio.safemedia.bypass" build.prop)

	if [ -z "$CHECKEXISTS" ]
	then
		printf "\n\n# Safe Media Bypass for External USB Sound Cards\naudio.safemedia.bypass=true\n" >> build.prop
		echo -e "${YELLOW}\n"
		diff -y build.prop.backup build.prop
		echo -e "${STD}\n"
		echo -e "This will allow you to keep 100% volume setting after reboot with an external audio device:\n"
		echo -e "Above are the OLD and NEW versions side by side. There should be 2 new lines at the end. Changes are indicated by > preceeding the lines:\n"

		while true; do
			echo -e "${RED}***** WARNING ***** ***** WARNING ***** ***** WARNING ***** ***** WARNING *****"
			echo -e "This will attempt to automatically patch your build.prop file but has the potential to brick your device."
			echo -e "You must verify the changes displayed above. No responsibility can be taken for any issues caused. \n${STD}"
		    read -p "Does the above look correct and are you ready to push the updated file back to your device? [y/N]" yn
		    case $yn in
		        [Yy]* ) install_buildprop; break;;
		        [Nn]* ) exit;;
		        * ) echo "Please type y or n.";;
		    esac
		done
	else
		echo -e "${RED}ERROR: audio.safemedia.bypass already exists in config. Please check the file manually. Aborting${STD}"
	fi
	pause
}

disableflow() {
	connecting
	echo Disabling overlay...
	.compiler/adb shell cmd overlay disable flow.overlay
	echo -e "${RED}flow.overlay DISABLED${STD}"
	pause
}

#-----------------------------------
#
#	Main script
#
#-----------------------------------


if [ -z "$1" ]
then
	header
	echo This will set up your device to be able to easily install
	echo overlay APKs through the file browser or directly.
	echo Ensure you already have compiled your flowOverlay apk !
	echo -e "${STD} "

	read -p "Enter the IP address of the device (e.g. 192.168.0.1): " headunit_ip
	export headunit_ip=$headunit_ip
else
    export headunit_ip=$1
fi

# Initial connection

.compiler/adb disconnect > /dev/null
networkcheck
.compiler/adb connect $headunit_ip
.compiler/adb root
.compiler/adb remount

while true
do
 
	menu
	menu_options
done