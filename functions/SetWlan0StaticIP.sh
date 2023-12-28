#!/bin/bash
#
#########################################################################################
# ***Run this script after Reboot***
# 190928  baswi created, I only use static IPs
#
#
  echo "Setup Fixed IP settings for WLAN"
  echo "***PRE: eth0 is already configured as static; see that script"
  echo "#########################################################################"
    read -p 'Enter IP Address: ' ethernetIp
    read -p 'Enter IP Subnet, example: 24: ' ethernetMask
    read -p 'Enter Gateway: ' ethernetGateway
    read -p 'Enter DNS 1: 8.8.8.8 ' ethernetDns1
    read -p 'Enter DNS 2: 4.4.4.4 ' ethernetDns2
#baswi snap ik niet    read -p 'Enter DNS Search domain: ' dnsSearch

#create systemd-networkd config file
# 181228  
cat << EOF1 > /etc/systemd/network/wlan0.network 
[Match]
Name=wlan0
[Network]
Address=$ethernetIp/24
Gateway=$ethernetGateway
DNS=192.168.1.1 #IP of LOCAL switch router; ISProuter not visible in this subnet
DNS=8.8.4.4
EOF1

