#!/bin/bash
# Make sure only root can run this script


# Check if w1-gpio is loaded
sudo /sbin/modinfo w1-gpio
if [ "$?" -ne 0 ]; then
  #Setup the kernel modules
  /sbin/modprobe w1-gpio gpiopin=18
  if [ "$?" -ne 0 ]; then echo "Failed to load w1-gpio"; exit 1; fi
fi

sudo /sbin/modinfo w1-ds2433
if [ "$?" -ne 0 ]; then
  /sbin/modprobe w1-ds2433
  if [ "$?" -ne 0 ]; then echo "Failed to load w1-ds2433"; exit 1; fi
fi

#Return success message
echo "Successfully loaded w1-gpio & w1-ds2433 kernel modules"
echo "Active EEPROM GPIO pin is 18"
