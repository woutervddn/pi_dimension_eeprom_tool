#!/bin/bash

installSoftware=true
downloadStratasys=true
deployWeb=true
installPyCrypto=true

startDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
        sudo apt-get install -y apache2 php5 libapache2-mod-php5
        sudo service apache2 restart
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

if [ "$deployWeb" = true ] ; then
    echo "deploying webdir to /var/www/html/"
    #clearing the html folder
    sudo rm -rf /var/www/html/*

    #copying the web folder to /var/www/html/
    sudo cp -r ${startDIR}/web/* /var/www/html/

fi

if [ "$installPyCrypto" = true ] ; then
    echo "installing Py Crypto"
    apt-get install autoconf g++ python2.7-dev
    pip install pycrypto

fi
