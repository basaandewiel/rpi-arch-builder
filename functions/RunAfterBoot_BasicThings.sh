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
#  sed -i.org 's/#Port 22/Port 321/' /etc/ssh/sshd_config #240120 just use default port nr 
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
  gpasswd -a baswi http # so I can easily edit srv/http/ files
#
 cat <<EOF > /home/baswi/.bashrc
#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias ll='ls -l'
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# colors generated with LS_COLOR generator; https://geoff.greer.fm/lscolors/
PS1='\[\e[1;32m\][\u@\h:\w]$\[\e[0m\] '
export SYSTEMD_LESS=FRXMK
export TERM=linux
EOF


cat <<EOF > /root/.bashrc
#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias ll='ls -l'
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# colors generated with LS_COLOR generator; https://geoff.greer.fm/lscolors/
PS1='\[\e[1;31m\][\u@\h:\w]$\[\e[0m\] '
export SYSTEMD_LESS=FRXMK
export TERM=linux
EOF
#


#
sed -i.org 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# restart sshd to make changes effective; NB: no root login via SSH
systemctl restart sshd

pacman -S --needed vim git cronie base-devel syncthing postfix
#gnupg needed for creating encrypted tgz
pacman -S --needed gnupg
read -r -p "run gpg --full-generate-key #default answers" notrelevant

#install mail
pacman -S postfix #mail server
systemctl enable postfix.service
systemctl start postfix.service
pacman -S mailx #mail client

cat <<EOF > /etc/postfix/main.cf
compatibility_level = 3.9
queue_directory = /var/spool/postfix
command_directory = /usr/bin
daemon_directory = /usr/lib/postfix/bin
data_directory = /var/lib/postfix
mail_owner = postfix
myhostname = localhost
mydomain = localdomain
inet_interfaces = $myhostname, localhost
mydestination = $myhostname, localhost.$mydomain, localhost
unknown_local_recipient_reject_code = 550
mynetworks_style = host
default_transport = error: outside mail is not deliverable
alias_maps = lmdb:/etc/postfix/aliases
alias_database = $alias_maps
debug_peer_level = 2
debugger_command =
	 PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
	 ddd $daemon_directory/$process_name $process_id & sleep 5
sendmail_path = /usr/bin/sendmail
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
setgid_group = postdrop
html_directory = no
manpage_directory = /usr/share/man
sample_directory = /etc/postfix
readme_directory = /usr/share/doc/postfix
inet_protocols = ipv4
meta_directory = /etc/postfix
shlib_directory = /usr/lib/postfix
EOF


sudo systemctl enable cronie
sudo systemctl start cronie

# create swap partition
swapon --show
mkswap /dev/sda5
swapon /dev/sda5

