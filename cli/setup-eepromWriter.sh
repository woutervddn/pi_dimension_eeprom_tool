#!/bin/bash
# Make sure only root can run this script

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

#Setup the kernel modules
modprobe w1-gpio gpiopin=18
if [ "$?" -ne 0 ]; then echo "Failed to load w1-gpio"; exit 1; fi

modprobe w1-ds2433
if [ "$?" -ne 0 ]; then echo "Failed to load w1-ds2433"; exit 1; fi

#Return success message
echo "Successfully loaded w1-gpio & w1-ds2433 kernel modules"
echo "Active EEPROM GPIO pin is 18"
