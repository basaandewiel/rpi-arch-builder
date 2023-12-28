#!/bin/bash
#
# ***************************************
# Install file for Domoticz 	        
#          run as non-roor user
# ***************************************
# HISTORY
# 180818 both arch AUR packages don't compile or give runtime errors;
#        source downloaded from domoticz website; instructions saved in mindmap
# 180818 moved installation of openzwave to first in script
# 171226uupdated
#
#
# install openzwave
cd ~
wget https://aur.archlinux.org/cgit/aur.git/snapshot/openzwave-git.tar.gz
tar -xvf openzwave-git.tar.gz
cd openzwave-git
makepkg -s
makepkg --nobuild
cd src/open-zwave/
grep -rIn Werror
echo "remove all occurences of Werror by hand; press key when ready"
read -n 1 -s
cd ~/openzwave-git
echo "remove ONLY OLD openzwave*.pkg.tar.xz; next command installs openzwave*.tar.xz"
read -n 1 -s
sudo pacman -U openzwave-*.pkg.tar.xz
#
#
# install domoticz
cd ~
sudo pacman -S --noconfirm --needed python-pip
echo "next command needed to prevent error about OPENSSL"
sudo pip install requests
cd ~
#wget https://aur.archlinux.org/cgit/aur.git/snapshot/domoticz.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/domoticz-latest.tar.gz
#
tar -xvf domoticz-latest.tar.gz
cd domoticz-latest
#cd domoticz-git
#
#180630 do not remove openzwave, because I need it
# remove openzwave including single quotes from PKGBUILD file, because it gives compile problems
#sed  -i.bak "s/'openzwave-git' //" PKGBUILD
#sed  -i.bak "s/'lua52' /lua/" PKGBUILD

echo "building starts, lasts more than 1 hour op RPI-2,about hour on RPI3"
makepkg -s
#
echo "remove ONLY OLD domoticz*.pkg.tar.xz; next command installs domoticz*.tar.xz"
read -n 1 -s
#
sudo pacman -U domoticz-*.pkg.tar.xz
# create service file
sudo su
cat <<EOFSF >> /usr/lib/systemd/system/domoticz.service
[Unit]
Description=Domoticz Daemon
After=network.target

[Service]
Environment=LD_PRELOAD=/usr/lib/libcurl.so.3
User=http
ExecStart=/opt/domoticz/domoticz -www 8080
WorkingDirectory=/opt/domoticz
RestartSec=5
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOFSF
#
sudo systemctl enable domoticz
sudo systemctl start domoticz
sudo systemctl status domoticz
read -n1 -r -p "Manually IMPORT backed up database with settings via browser port 8080 - Press space if ready" key
read -n1 -r -p "Manually RESTORE /opt/domotics/scripts/* - Press space if ready" key

