#!/bin/bash
# Make sure only root can run this script

#remove the kernel modules
/sbin/rmmod w1-gpio
if [ "$?" -ne 0 ]; then echo "Failed to unload w1-gpio"; exit 1; fi

/sbin/rmmod w1-ds2433
if [ "$?" -ne 0 ]; then echo "Failed to unload w1-ds2433"; exit 1; fi

#Return success message
echo "Successfully unloaded w1-gpio & w1-ds2433 kernel modules"
