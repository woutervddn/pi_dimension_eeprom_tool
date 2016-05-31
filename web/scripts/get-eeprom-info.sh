#!/bin/bash
# Make sure only root can run this script

#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run as root" 1>&2
#	exit 1
#fi

W1_DIR="/sys/bus/w1/devices/w1_bus_master1"

# Load kernel modules
/var/www/scripts/load-kernel-mods.sh

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
			echo "Directory exists"
			missingEeprom=false

			echo "Found EEPROM: $dir"

			# echo the EEPROM ID
			eepromID=$(xxd -p $dir"id")
			echo "  - EEPROM ID: $eepromID"

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
			echo "  - EEPROM swab ID: $swabID"

			# echo the EEPROM reverse ID
			revID=$(echo $swabID|rev)
			echo "  - EEPROM rev ID: $revID"

			# Make a binary backup
			binaryName="original-"$eepromID".bin"
			cp $dir"eeprom" $tmpDir"/"$binaryName

			# View the binary contents
			# echo "  - Binary Content: "
			# hexdump -C $tmpDir"/"$binaryName

			# View the eeprom settings
			usedScript="/home/pi/stratasys-master/stratasys-cli.py"
			echo "  - used script: $usedScript"

			command="eeprom"
			echo "  - command: $command"

			printerType="prodigy"
			echo "  - Printer Type: $printerType"

			echo "  - Used EEPROM UID: $revID"

			binaryFile=$tmpDir"/"$binaryName

			eepromInfoCommand="$usedScript $command -t $printerType -e $revID -i $binaryFile"
			echo "  - Full Command: $eepromInfoCommand"

			echo "-------------"
			echo ""


			# View the current binary information
			$eepromInfoCommand

			# Grab recreate info
			usedScript="/home/pi/stratasys-master/stratasys-cartridge.py"

			echo "hexdump of output file: "
			echo ""

			$usedScript refill -t $printerType -e $revID -i $binaryFile -o $tmpDir/output.bin
			hexdump -C $tmpDir/output.bin

			echo ""

			echo "New Data we'd write to the cartridge:"
			echo
			usedScript="/home/pi/stratasys-master/stratasys-cli.py"
			eepromInfoCommand="$usedScript $command -t $printerType -e $revID -i $tmpDir/output.bin"
			$eepromInfoCommand
			echo

			#read -p "Do you want to write this information to the active EEPROM? " -n 1 -r
			#echo
			#if [[ $REPLY =~ ^[Yy]$ ]]
			#then
			#	echo "Writing to EEPROM. . ."
			#	sudo cp $tmpDir/output.bin $dir"eeprom"
			#fi




			#Cleanup
			rm -rf $tmpDir

			#Unload kernel modules
			/var/www/scripts/unload-kernel-mods.sh

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
