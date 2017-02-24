#!/bin/bash
# Make sure only root can run this script

#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run as root" 1>&2
#	exit 1
#fi

W1_DIR="/var/www/eeprom/test/"

# Listen if directory exists every 5 seconds
while true
do
	#Show files w1_bus_master1
	#ls $W1_DIR

	missingEeprom=true
	#Loop through matching eeprom folders
	itterationCount=0
	dirs=$W1_DIR/23-*/
	for dir in $dirs
	do
		if [ -d $dir ]; then
			(( itterationCount++ ))
			if [ $itterationCount -gt 1 ]; then
				echo "Another eeprom directory exists"
			else
        echo "An eeprom directory exists"
      fi
			missingEeprom=false

			echo "Found EEPROM: $dir"

			{ # try
				# echo the EEPROM ID
				eepromID=$(xxd -p $dir"id")
			} || { # catch
			    # save log for exception
					echo "you are not looking for $dir"
					echo "it must be a previously inserted eeprom"
					echo "moving on to next folder"
					echo "--------"
					continue
			}

			eepromID=$(xxd -p $dir"id")
			echo "  - EEPROM ID: $eepromID"


			#exit before wait (development)
			exit 1

			#wait a minute
			sleep 60
		fi
	done

	if [ "$missingEeprom" = true ]; then
		echo "No EEPROM found. Waiting 5 seconds..."
	fi

	#wait 5 sec
	sleep 5
done
