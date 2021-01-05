# FlowOverlay by @Kri Version 1.1
# Based on KswOverlay by @nicholaschum

This is a tool that automatically creates an overlay for your flow-based tablet.
Available to be used on Mac, Windows and Linux.

## Disclaimer
You MUST have JRE and JDK installed, link below:

JDK: [https://www.oracle.com/java/technologies/javase-jdk14-downloads.html](https://www.oracle.com/java/technologies/javase-jdk14-downloads.html)

JRE: [https://www.java.com/en/download/](https://www.java.com/en/download/)


# Download
On the top right corner of this GitHub page, click on Clone or Download, and then click Download ZIP. Then extract that anywhere.


# Theming Instructions
If you never themed before, these are called overlays. They get "overlaid" on top of your existing application and when the app calls for these resources, 
they take from the overlay first, then the base app.

What you have to do is to take the resources from [https://github.com/Chrisu02/FlowOverlay/tree/master/resources/res](this) link and edit those pictures. 

Depending on the Headunit Resolution  make the images at a specific Resolution for optimal display quality.\
`drawable-mdpi` - for 1280x480  resolution, make tile icons 128x128 pixel, Background Images 1280x480 pixel.\
`drawable-hdpi` - for 1920x720  resolution, make tile icons 192x192 pixel, Background Images 1920x720 pixel.\
`drawable` - for other  resolution, make tile icons 512x512 pixel,Background Images should fit display res.\

If you're editing in one of the `drawable` folders, make sure that the folder in `resources/res` has that folder and named correctly, with the file. 

Do not put in unedited files because bloating up the overlay is not ideal.

Remove all not changed files from all `drawable` folders which should not be compiled.

It is also possible to edit Tile Names.\
To do so there is a preset at `resources/res/values` which can be changed.\
If you want to rename tiles in a different language you need to rename the folder to your specific language.\
For example to change german language you need rename it to `values-de` or for italian language to `values-it`\

Once you're done, follow these next steps to compile.


# Windows Instructions
To use this on Windows, make sure Java is installed and then you are able to make changes to the `resources/res/` folder for image and text changes.

When you are done, click on `compile-windows.bat` and it will automatically compile and sign an overlay APK for you!

To install, run `flowoverlay-installer_windows.bat` and follow instructions.


# Mac Instructions
To use this on Mac, make sure Java is installed and then you are able to make changes to the `resources/res/` folder for image and text changes.

When you are done, click on `compile-mac.command` and it will automatically compile and sign an overlay APK for you!

To install, run `flowoverlay-installer_mac.command` and follow instructions.

# Linux Instructions
To use this on Linux, make sure Java is installed and then you are able to make changes to the `resources/res/` folder for image and text changes.

When you are done, in the folder housing `compile-linux.sh` you will need to open a Terminal window and type `chmod +x compile-linux.sh`, then you can type `./compile-linux.sh` and it will automatically compile and sign an overlay APK for you!

To install, enter `chmod +x flowoverlay-installer_linux.sh` then run `./flowoverlay-installer_linux.sh`.
