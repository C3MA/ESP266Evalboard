# Base System

The raspberry will open an access point.

## Hardware
Prequirements are :
* Raspberry Pi 3
* Raspberry Pi 2 with Wifi Dongle.

each version must be installed with **raspbian** a *debian* based operation system for these hardware.

## Software

Always it is a good idea to update the packages sources:
`sudo apt update`   

### Wifi
The wifi is realized with the service *hostapd*.

The configuration is done with the following configuration file */etc/hostapd/hostapd.conf*.
The example configuration looks like the following:
`interface=wlan0`   
``   
`ssid=WLAN1`   
`channel=1`   
`hw_mode=g`   
`ieee80211n=1`   
`ieee80211d=1`   
`country_code=DE`   
`wmm_enabled=1`   
``   
``   
`auth_algs=1`   
`wpa=2`   
`wpa_key_mgmt=WPA-PSK`   
`rsn_pairwise=CCMP`   
`wpa_passphrase=c3ma_123`   

### DHCP Server
In order, that each device in the new wifi gets an IP address, there is a DHCP server.
It is configured with the following steps:
After installing *dnsmasq*, its configuration is done in the file */etc/dnsmasq.conf*.
The example configuration looks like this:

`interface=wlan0`   
`dhcp-range=192.168.1.100,192.168.1.150,24h`   
`dhcp-option=option:dns-server,192.168.1.1`   

### Activation
In order to use the new settings the easiest way is to reboot the device:
`sudo reboot`   

## Communication Server
The communication between the devices is realized with the MQTT protocol.
Therefor a MQTT Server must be installed on the raspberry.

It was used **moqquitto**.

The package must be installed:
`sudo apt install mosquitto`   

And no configuration is necessary.
