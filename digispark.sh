#!/bin/bash

# Digispark installer.
# Written by James Muirhead.
# 2015-10-12
# http://www.sheffieldhardwarehackers.org.uk

# CHANGE LOG
# 2015-10-16 - Only installs 32-bit extensions if 64 bit OS detected.
# 2015-11-04 - Now creates UDEV rule for DigiSpark & DgiSpark Pro.

if [ $(whoami) == "root" ]
then
	apt-get update

	# Installs required library.
	apt-get -y install libusb-dev

	# Checks for 64-bit environment and installs 32-bit extensions, if required.
	uname -a | grep x86_64
	if [ $? == 0 ]
	then
		apt-get -y install lib32stdc++6
	fi

	# Creates UDEV rule for DigiSpark
	echo "# Rule to allow use of the basic DigiSpark (ATtiny85) board in the Arduino IDE 1.6.3+" > /etc/udev/rules.d/99digispark.rules
	echo "# Written by James Muirhead (@PhantomFreak), 2015-10-12." >> /etc/udev/rules.d/99digispark.rules
	echo "# http://www.sheffieldhardwarehackers.org.uk" >> /etc/udev/rules.d/99digispark.rules
	echo "" >> /etc/udev/rules.d/99digispark.rules
	echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0753", MODE="0660", GROUP="dialout"' >> /etc/udev/rules.d/99digispark.rules
	
	# Creates UDEV rule for DigiSpark Pro.
	echo "# Rule to allow the use of DigiSpark Pro (ATtiny167) board in the Arduino IDE 1.6.3+" > /etc/udev/rules.d/99digispark-pro.rules
	echo "# Written by James Muirhead (@PhantomFreak), 2015-11-04." >> /etc/udev/rules.d/99digispark-pro.rules
	echo "# http://www.sheffieldhardwarehackers.org.uk" >> /etc/udev/rules.d/99digispark-pro.rules
	echo "" >> /etc/udev/rules.d/99digispark.rules
	echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0753", MODE="16d0", GROUP="dialout"' >> /etc/udev/rules.d/99digispark-pro.rules

	# Restarts UDEV
	service udev restart

	echo "All done, please close all open Arduino IDE windows & reopen before attemptting to upload code."
	exit 0
else
	echo "You are not root, please use sudo or su to continue."
	exit 1
fi
