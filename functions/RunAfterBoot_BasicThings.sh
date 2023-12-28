#!/bin/bash

#########################################################################################
###
# script to be run AS ROOT after first boot of PI
###
  read -r -p "Are you ROOT?" notrelevant

  echo "Basic settings and installs"
  echo "#########################################################################"

  echo "baswi added - set TIMEZONE"
  rm /etc/localtime
  ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
# baswi: normally ntpd is NOT needed; systemd-timesyncd also implements the ntp-client, and
# comes pre-installed with systemd
# but for a read only root FS it is different; see read only root FS script
  echo "Basic security settings"
  sed -i.org 's/#Port 22/Port 321/' /etc/ssh/sshd_config
  echo "# baswi - added next lines via script" >> /etc/ssh/sshd_config
  echo "AllowUsers baswi" >> /etc/ssh/sshd_config
  echo "PermitRootLogin no" >> /etc/ssh/sshd_config
#
#
  echo "Add user BASWI"
  pacman -S sudo
  useradd -m -g users -s /bin/bash baswi
#  read -r -p "Give password for user baswi: " passwd
  passwd baswi 
  gpasswd -a baswi wheel
  gpasswd -a baswi video
  gpasswd -a baswi audio
  gpasswd -a baswi power
#  cp /etc/skel/bashrc /home/baswi/.bashrc #231228 not present
# delete and line with PS1, and change (replace did not work with sed
  sed -i.org '/PS1/d' /home/baswi/.bashrc
  echo "PS1='\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] '" >> /home/baswi/.bashrc
#
sed -i.org 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# restart sshd to make changes effective; NB: no root login via SSH
systemctl restart sshd

pacman -S vim git

