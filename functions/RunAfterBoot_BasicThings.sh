#!/bin/bash

#########################################################################################
###
# Create install script to be run after first boot of PI
###

function functionBasicThings {
  echo "Basic settings and installs"
  echo "#########################################################################"

  echo "baswi added - set TIMEZONE"
  rm /etc/localtime
  ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
# baswi: ntpd is NOT needed; systemd-timesyncd also implements the ntp-client, and
# comes pre-installed with systemd

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
  read -r -p "Give password for user: baswi" passwd
  passwd baswi $passwd
  gpasswd -a baswi wheel
  gpasswd -a baswi video
  gpasswd -a baswi audio
  gpasswd -a baswi power
  cp /etc/skel/bashrc /home/baswi/.bashrc
# delete and line with PS1, and change (replace did not work with sed
  sed -i.org '/PS1/d' /home/baswi/.bashrc
  echo "PS1='\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] '" >> /home/baswi/.bashrc
#
sed -i.org 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

#modify /etc/fstab to log into RAM- tested on RPI0
#source: https://wiki.archlinux.org/index.php/Tmpfs
# Some directories where tmpfs is commonly used are /tmp, /var/lock and /var/run.
#  Do *NOT* use it on /var/tmp, because that folder is meant for temporary 
# files that are preserved across reboots.
#
# Arch uses a tmpfs /run directory, with /var/run and /var/lock simply 
# existing as symlinks for compatibility. It is also used for /tmp by the 
# default systemd setup and does not require an entry in fstab unless a 
# specific configuration is needed.  
echo "tmpfs 	/var/log tmpfs defaults,noatime,mode=0755 0 0" >> 
/etc/fstab
echo "tmpfs     /var/cache/pacman tmpfs defaults,noatime        0   0"
}
