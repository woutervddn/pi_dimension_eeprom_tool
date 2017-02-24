#!/bin/bash
# Make sure only root can run this script

#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run as root" 1>&2
#	exit 1
#fi

#quantity=$1
quantity=92.3
W1_DIR="/sys/bus/w1/devices/w1_bus_master1"

# Load kernel mods
/var/www/html/scripts/load-kernel-mods.sh


# Listen if directory exists every 5 seconds
while true
do
	#Show files w1_bus_master1
	#ls $W1_DIR

	missingEeprom=true
	#Loop through matching eeprom folders
	dirs=$W1_DIR/23-*/
	for dir in $dirs
	do
		if [ -d $dir ]; then
			#echo "Directory exists"
			missingEeprom=false

			#echo "Found EEPROM: $dir"
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

			#echo the EEPROM ID
			eepromID=$(xxd -p $dir"id")
			#echo "  - EEPROM ID: $eepromID"

			#Make a temp dir, remove it if it already exists
			tmpDir="/tmp/eepromWriter"
			if [ -d $tmpDir ]; then
				rm -rf $tmpDir
			fi
			mkdir $tmpDir

			#write the eeprom id to the uid file
			echo "$eepromID" > $tmpDir/uid
			#binary swab the little endian & big endian with dd conv=swab
			(dd conv=swab < $tmpDir/uid > $tmpDir/swab_uid) > /dev/null 2>&1

			# echo the EEPROM swab ID
			swabID=$(cat $tmpDir/swab_uid)
			#echo "  - EEPROM swab ID: $swabID"

			# echo the EEPROM reverse ID
			revID=$(echo $swabID|rev)
			#echo "  - EEPROM rev ID: $revID"

			# Make a binary backup
			binaryName="original-"$eepromID".bin"
			cp $dir"eeprom" $tmpDir"/"$binaryName

			# View the binary contents
			# echo "  - Binary Content: "
			#hexdump -C $tmpDir"/"$binaryName

			# View the eeprom settings
			usedScript="/opt/eepromTool/stratasys-master/stratasys-cli.py"
			#echo "  - used script: $usedScript"

			command="eeprom"
			#echo "  - command: $command"

			printerType="fox2"
			#echo "  - Printer Type: $printerType"

			#echo "  - Used EEPROM UID: $revID"

			binaryFile=$tmpDir"/"$binaryName

			eepromInfoCommand="$usedScript $command -t $printerType -e $revID -i $binaryFile"
			#echo "  - Full Command: $eepromInfoCommand"

			#echo "-------------"
			#echo ""


			# View the current binary information
			#$eepromInfoCommand

			# Grab recreate info
			usedScript="/opt/eepromTool/stratasys-master/stratasys-cli.py"

			#echo "hexdump of output file: "
			#echo ""
			if [ ! -f ./serial.number ]; then
			    echo "No serialnumberfile found!"
					touch ./serial.number
					echo "900000000" > serial.number
			fi
			typeset -i serialNumber=$(cat serial.number)
			(( serialNumber++ ))
			echo $serialNumber > serial.number

			$usedScript eeprom -t $printerType -e $revID --serial-number $serialNumber.0 --material-name ABS-M30 --manufacturing-lot 9999 --manufacturing-date "2017-01-01 01:01:01" --use-date "2017-01-01 01:01:01" --initial-material $quantity --current-material $quantity --key-fragment 4141414141414141 --version 1 --signature STRATASYS -o $tmpDir/output.bin

			#hexdump -C $tmpDir/output.bin


			echo ""

			echo "New Data:"
			echo
			usedScript="/opt/eepromTool/stratasys-master/stratasys-cli.py"
			eepromInfoCommand="$usedScript $command -t $printerType -e $revID -i $tmpDir/output.bin"
			$eepromInfoCommand
			echo

			echo "Allowing ourselves to write to the eeprom"
			/bin/chmod 777 -R $dir"eeprom"

			echo "Writing to EEPROM. . ."
			/bin/dd if=$tmpDir/output.bin of=$dir"eeprom"

			echo "writing Successful, cleaning up. . ."


			#Cleanup
			rm -rf $tmpDir


			#Unload kernel mods
			/var/www/html/scripts/unload-kernel-mods.sh

			echo "Exiting. . ."
			#exit before wait (development)
			exit 1

			#wait a minute
			#sleep 60
		fi
	done

	if [ "$missingEeprom" = true ]; then
		echo "No EEPROM found. Waiting 5 seconds..."
	fi

	#wait 5 sec
	sleep 5
done
