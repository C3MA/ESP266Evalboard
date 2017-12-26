# OpenHAB
Is a homeautomation project, called **open Home Automation Bus** (<http://openhab.org>) with the focus provide a central plattform where different sensors and actors can be connected 
## Installation
Prequirements are :
* Raspberry Pi 3
* Raspberry Pi 2 with Wifi Dongle.

each version must be installed with **raspbian** a *debian* based operation system for these hardware. 

OpenHABian is a tiny terminal command line tool, that installs all dependencies. In order to install it, the following commands must be executed:


`cd /opt/`   
`sudo git clone https://github.com/openhab/openhabian.git`   
`sudo ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config`   

The program can now be executed from the commandline:

`sudo openhabian-config`   

