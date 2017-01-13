#!/bin/bash

installSoftware=false
downloadStratasys=false
deployWeb=false
installPyCrypto=false
scheduleReboots=false
allowRunAsRoot=false
setBootConfig=true
setupWifiHotspot=false

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
    git clone https://github.com/bvanheu/stratasys.git
    # wget https://github.com/bvanheu/stratasys/archive/master.zip
    # unzip master.zip
    # rm master.zip

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

if [ "$scheduleReboots" = true ] ; then
    echo "scheduleing Reboots"
    crontab -l | { cat; echo "0 6 * * * reboot"; } | crontab -

fi

if [ "$allowRunAsRoot" = true ] ; then
    echo "Allowing www-data to run certain commands as root..."
    sudo rm /etc/sudoers.d/999_www-data-nopasswd
    sudo touch /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/whoami" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /sbin/modprobe" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /sbin/rmmod" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /opt/eepromTool/stratasys-master/stratasys-cli.py" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /opt/eepromTool/stratasys-master/stratasys-cartridge.py" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/custom-eeprom.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/get-eeprom-info.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/load-kernel-mods.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/reset-eeprom.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/unload-kernel-mods.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    echo "www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/update-eeprom.sh" | sudo tee -a /etc/sudoers.d/999_www-data-nopasswd
    sudo chmod 0440 /etc/sudoers.d/999_www-data-nopasswd
fi

if [ "$setBootConfig" = true ] ; then
    echo "Setting up the boot config"
    # Remove old line
    sudo sed -i.bak '/dtoverlay=w1-gpio/d' /boot/config.txt
    echo "dtoverlay=w1-gpio,gpiopin=18" | sudo tee -a /boot/config.txt
fi

if [ "$setupWifiHotspot" = true ] ; then

  echo "Setting up a wifi hotspot..."
  cd /opt
  git clone https://github.com/harryallerston/RPI-Wireless-Hotspot.git
  cd RPI-Wireless-Hotspot
  sudo ./install

fi
