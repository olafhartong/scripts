#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2010/11/18/how-to-set-osxs-screen-saver-via-script/
#
# GitRepo: https://github.com/macmule/setscreensaver
#
# License: http://macmule.com/license/
#
####################################################################################################

###########
# 
# HARDCODED VALUES ARE SET HERE
#
###########

startTime="600" 			# Integer - Seconds
justMain=""			# Boolean
screenSaverName=""		# String
screenSaverPath=""		# String
requirePassword="1"		# Integer (1 = true, 0 = false)
timeBeforeRequiringPassword="0"	# Integer - Seconds

####
# IF RUN AS A SCRIPT IN CASPER, CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER AND, IF SO, ASSIGN
####

if [ "$4" != "" ] && [ "$startTime" == "" ]; then
	startTime=$4
fi

if [ "$5" != "" ] && [ "$justMain" == "" ]; then
	justMain=$5
fi

if [ "$6" != "" ] && [ "$screenSaverName" == "" ]; then
	screenSaverName=$6
fi

if [ "$7" != "" ] && [ "$screenSaverPath" == "" ]; then
	screenSaverPath=$7
fi

if [ "$8" != "" ] && [ "$requirePassword" == "" ]; then
	requirePassword=$8
fi

if [ "$9" != "" ] && [ "$timeBeforeRequiringPassword" == "" ]; then
	timeBeforeRequiringPassword=$9
fi


###########
# 
# Get the Universally Unique Identifier (UUID) for the correct platform
# ioreg commands found in a comment at http://www.afp548.com/article.php?story=leopard_byhost_changes
#
###########

	# Check if hardware is PPC or early Intel
	if [[ `ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-50` == "00000000-0000-1000-8000-" ]]; then
		macUUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c51-62 | awk {'print tolower()'}`
	# Check if hardware is new Intel
	elif [[ `ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-50` != "00000000-0000-1000-8000-" ]]; then
		macUUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-62`
	fi

###########

# Get the Username of the currently logged user
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# Query dscl to get the currently logged in users home folder 
loggedInUserHome=`dscl . -read /Users/$loggedInUser | grep NFSHomeDirectory: | /usr/bin/awk '{print $2}'`


###########
#
# For each variable check to see if it has a value. If it does then write the variables value to the applicable plist in the applicable manner
#
###########

# Variables for the ~/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist

# Set bash to become case-insensitive
shopt -s nocaseglob

# Remove the all the com.apple.screensaver* plists, with the Case insensitivity this will also remove the Case insenstivity was updated to remove: 
# com.apple.ScreenSaver.iLifeSlideShows.XX.plist & com.apple.ScreenSaverPhotoChooser.XX.plist saver plists
rm -rf "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver*

# Set bash to become case-sensitive
shopt -u nocaseglob


if [[ -n $startTime ]]; then
	/usr/libexec/PlistBuddy -c "Add :idleTime integer $startTime" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
fi

if [[ -n $justMain ]]; then
	/usr/libexec/PlistBuddy -c "Add :mainScreenOnly bool $justMain" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
fi

# Make sure the moduleDict dictionary exists
	/usr/libexec/PlistBuddy -c "Add :moduleDict dict" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist

if [[ -n $screenSaverName ]]; then
	/usr/libexec/PlistBuddy -c "Add :moduleDict:moduleName string $screenSaverName" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
	/usr/libexec/PlistBuddy -c "Add :moduleName string $screenSaverName" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
fi

if [[ -n $screenSaverPath ]]; then
	/usr/libexec/PlistBuddy -c "Add :moduleDict:path string $screenSaverPath" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
	/usr/libexec/PlistBuddy -c "Add :modulePath string $screenSaverPath" "$loggedInUserHome"/Library/Preferences/ByHost/com.apple.screensaver."$macUUID".plist
fi


# Variables for the ~/Library/Preferences/com.apple.screensaver.plist

# Remove the com.apple.screensaver.plist, comment out if you do not wish to remove this file
rm -rf "$loggedInUserHome"/Library/Preferences/com.apple.screensaver.plist


if [[ -n $requirePassword ]]; then
	/usr/libexec/PlistBuddy -c "Add :askForPassword integer $startTime" "$loggedInUserHome"/Library/Preferences/com.apple.screensaver.plist
fi

if [[ -n $timeBeforeRequiringPassword ]]; then
	/usr/libexec/PlistBuddy -c "Add :askForPasswordDelay integer $timeBeforeRequiringPassword" "$loggedInUserHome"/Library/Preferences/com.apple.screensaver.plist
fi

# Echo out on completion..
echo "Set Screen Saver for user: "$loggedInUser"..."
