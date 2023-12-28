#!/bin/bash
#
#########################################################################################
# ***Run this script after Reboot***
# 180817  baswi created, I only use static IPs
#
#
  echo "Setup Fixed IP settings for Ethernet"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' ethernetIp
    read -p 'Enter IP Subnet, example: 24: ' ethernetMask
    read -p 'Enter Gateway: ' ethernetGateway
    read -p 'Enter DNS 1: 8.8.8.8 ' ethernetDns1
    read -p 'Enter DNS 2: 4.4.4.4 ' ethernetDns2
#baswi snap ik niet    read -p 'Enter DNS Search domain: ' dnsSearch

#create systemd-networkd config file
# 181228  
cat << EOF1 > /etc/systemd/network/eth0.network 
[Match]
Name=eth0
[Network]
Address=$ethernetIp/24
Gateway=$ethernetGateway
DNS=192.168.1.1 #IP of LOCAL switch router; ISProuter not visible in this subnet
DNS=8.8.4.4
EOF1

#Next, you need to disable netctl. To find out what is enabled that is netctl related, run the following command:
sudo systemctl list-unit-files | grep netcl
read -n1  "$ sudo systemctl disable <all services outputted by previous command> <mailto:netctl@enp0s3.service>" key
echo "And, remove netctl package from your Arch Linux using command:"
sudo pacman -Rns netctl
echo "Also, Don’t forget to stop and disable dhcp service."
sudo systemctl stop dhcpcd
sudo systemctl disable dhcpcd
echo "Then, enable and start systemd-networkd service as shown below:"
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
echo "Reboot your system. And, check if IP address is correctly assigned using command:$ ip addr"
#
# 181228  make systemm use the DNS entry specified in eth0.network
# this does NOT work in read only root
systemctl enable systemd-resolved
systemctl start systemd-resolved
systemctl status systemd-resolved
