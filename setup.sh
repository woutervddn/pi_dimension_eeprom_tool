#!/bin/bash

installSoftware=true
downloadStratasys=true
deployWeb=true
installPyCrypto=true
scheduleReboots=true
allowRunAsRoot=true
setupWifiHotspot=true

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


if [ "$setupWifiHotspot" = true ] ; then

    sudo apt-get install hostapd dnsmasq

    echo "Setting up Wifi Hotspot"

    echo 'denyinterfaces wlan0' | cat - /etc/dhcpcd.conf > /tmp/dhcpcd.conf && sudo mv /tmp/dhcpcd.conf /etc/dhcpcd.conf

    echo 'source-directory /etc/network/interfaces.d' > /etc/network/interfaces
    echo 'auto lo' >> /etc/network/interfaces
    echo 'iface lo inet loopback' >> /etc/network/interfaces
    echo '' >> /etc/network/interfaces
    echo 'auto eth0' >> /etc/network/interfaces
    echo 'iface eth0 inet manual' >> /etc/network/interfaces
    echo '' >> /etc/network/interfaces
    echo 'allow-hotplug wlan0' >> /etc/network/interfaces
    echo 'iface wlan0 inet static' >> /etc/network/interfaces
    echo 'address 172.24.1.1' >> /etc/network/interfaces
    echo 'netmask 255.255.255.0' >> /etc/network/interfaces
    echo 'network 172.24.1.0' >> /etc/network/interfaces
    echo 'broadcast 172.24.1.255' >> /etc/network/interfaces

    sudo service dhcpcd restart
    sudo ifdown wlan0
    sudo ifup wlan0


    echo '# This is the name of the WiFi interface we configured above' > /etc/hostapd/hostapd.conf
    echo 'interface=wlan0' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use the nl80211 driver with the brcmfmac driver' >> /etc/hostapd/hostapd.conf
    echo 'driver=nl80211' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# This is the name of the network' >> /etc/hostapd/hostapd.conf
    echo 'ssid=Eeprom' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use the 2.4GHz band' >> /etc/hostapd/hostapd.conf
    echo 'hw_mode=g' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use channel 6' >> /etc/hostapd/hostapd.conf
    echo 'channel=6' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Enable 802.11n' >> /etc/hostapd/hostapd.conf
    echo 'ieee80211n=1' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Enable WMM' >> /etc/hostapd/hostapd.conf
    echo 'wmm_enabled=1' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Enable 40MHz channels with 20ns guard interval' >> /etc/hostapd/hostapd.conf
    echo 'ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Accept all MAC addresses' >> /etc/hostapd/hostapd.conf
    echo 'macaddr_acl=0' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use WPA authentication' >> /etc/hostapd/hostapd.conf
    echo 'auth_algs=1' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Require clients to know the network name' >> /etc/hostapd/hostapd.conf
    echo 'ignore_broadcast_ssid=0' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use WPA2' >> /etc/hostapd/hostapd.conf
    echo 'wpa=2' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use a pre-shared key' >> /etc/hostapd/hostapd.conf
    echo 'wpa_key_mgmt=WPA-PSK' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# The network passphrase' >> /etc/hostapd/hostapd.conf
    echo 'wpa_passphrase=0102030405' >> /etc/hostapd/hostapd.conf
    echo '' >> /etc/hostapd/hostapd.conf
    echo '# Use AES, instead of TKIP' >> /etc/hostapd/hostapd.conf
    echo 'rsn_pairwise=CCMP' >> /etc/hostapd/hostapd.conf

    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
    echo 'interface=wlan0      # Use interface wlan0  ' > /etc/dnsmasq.conf
    echo 'listen-address=172.24.1.1 # Explicitly specify the address to listen on  ' >> /etc/dnsmasq.conf
    echo 'bind-interfaces      # Bind to the interface to make sure we aren't sending things elsewhere  ' >> /etc/dnsmasq.conf
    echo 'server=8.8.8.8       # Forward DNS requests to Google DNS  ' >> /etc/hostapd/hostapd.conf
    echo 'domain-needed        # Dont forward short names  ' >> /etc/hostapd/hostapd.conf
    echo 'bogus-priv           # Never forward addresses in the non-routed address spaces.  ' >> /etc/hostapd/hostapd.conf
    echo 'dhcp-range=172.24.1.50,172.24.1.150,12h # Assign IP addresses between 172.24.1.50 and 172.24.1.150 with a 12 hour lease time  ' >> /etc/dnsmasq.conf

    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
    sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
    sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

    echo 'iptables-restore < /etc/iptables.ipv4.nat' | cat - /etc/rc.local > /tmp/rc.local && sudo mv /tmp/rc.local /etc/rc.local

    sudo service hostapd start
    sudo service dnsmasq start

    sudo reboot

fi
