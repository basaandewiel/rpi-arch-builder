#!/bin/bash

#########################################################################################
###
# install rsnapshot including rsync
###

echo "Rsnapshot"
echo "#########################################################################"
#
cd ~
#
sudo pacman -S rsync
#
echo "configure rsync"
#
sudo cat <<EOFCF > /etc/rsyncd.conf
#uid = nobody
#gid = nobody #baswi: commneted, anders kreeg ik foutmelding
use chroot = no
max connections = 4
syslog facility = local5

lock file = /var/run/rsyncd.lock
pid file = /run/rsyncd.pid
log file = /var/log/rsync.log

[ftp]
        path = /srv/ftp
        comment = ftp area

#below added by baswi

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

}
