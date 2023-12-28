#!/bin/bash

#########################################################################################
###
# install rsnapshot including rsync
# 
###

read -n1 -r -p "Rsnapshot, script should run as root" key
echo "#########################################################################"
#
cd ~
#
sudo pacman -S rsync
#
echo "configure rsync"
#
echo "sudo su does not work in script; the cat command is not executed"
cat <<EOFCF > /etc/rsyncd.conf
#uid = nobody
#gid = nobody #baswi: commented out to prevent error message
use chroot = no
max connections = 4
syslog facility = local5

lock file = /var/run/rsyncd.lock
pid file = /run/rsyncd.pid
log file = /var/log/rsync.log

[ftp]
        path = /srv/ftp
        comment = ftp area

#below contains private data, must be adapted

[downloads]
comment = download complete foler
path = /mnt/usbdisk1/downloads/complete
read only = yes
list = yes

[backupbaswi]
comment = Backup van baswi
path = /mnt/usbdisk1/backup/bas
read only = no
list = yes

[backupmarieke]
comment = Backup van Marieke
path = /mnt/usbdisk1/backup/Marieke-2
read only = no
list = yes

EOFCF
#
echo "start rsyncd on boot, door te koppelen aan netw socket"
sudo systemctl enable rsyncd.socket
sudo systemctl start rsyncd.socket
sudo systemctl status rsyncd.socket
read -n1 -r -p "Check status and Press space to continue..." key
#
# Install rsnapshot
sudo pacman -S rsnapshot
echo "edit /etc/rsnapshot.conf (see http://www.rsnapshot.org/howto/1.2/rsnapshot-HOWTO.en.html) (or copy from backup)"
#use TABS iso spaces in this config file
#check for syntax errors in config file
rsnapshot configtest 
read -n1 -r -p "Correct possible errors in config file; Press space to continue..." key
