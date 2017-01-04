#!/bin/bash

installSoftware=true
downloadStratasys=true

apache2Dir=$(which apache2)
php5Dir=$(which php)


if [ "$installSoftware" = true ] ; then
    if [[ -n "${apache2Dir/[ ]*\n/}" ]] && [[ -n "${php5Dir/[ ]*\n/}" ]]
    then
	echo "Apache2 and PHP are installed, continuing"
        #execute if the the variable is not empty and contains non space characters
    else
	echo "Apache2 and/or PHP are not installed.. Installing now"
	sudo apt-get update
	sudo apt-get install apache2 php
        #execute if the variable is empty or contains only spaces
    fi
fi

if [ "$downloadStratasys" = true ] ; then
    echo "downloading bvanheu's Stratasys Library"
    if [ -d "/tmp/eepromTool" ]; then rm -Rf /tmp/eepromTool; fi
    mkdir /tmp/eepromTool
    cd /tmp/eepromTool
    wget https://github.com/bvanheu/stratasys/archive/master.zip
    unzip master.zip
    rm master.zip

    if [ -d "/opt/eepromTool" ]; then sudo rm -Rf /opt/eepromTool; fi
    sudo mkdir /opt/eepromTool/
    sudo cp -r /tmp/eepromTool/* /opt/eepromTool/
    sudo chmod 775 -R /opt/eepromTool/
fi

