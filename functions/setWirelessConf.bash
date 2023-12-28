#!/bin/bash
#
#samenvatting
#    wpa_supplicant - zorg voor netwerkauthenticatie (ssid en key)
#    systemd-networkd - zorgt voor toekenning IP address
#
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
#als deze niet wordt uitgevoerd tijdens boot, dan komt wlan0 niet up - in     
sudo systemctl enable wpa_supplicant@wlan0   
#so that is connects during boot <mailto:wpa_supplicant@wlan0>
sudo  ip link set wlan0 up
cat <<EOF2 > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

network={
         ssid="netwerk2"
         psk="password" }
EOF2
#
echo 'edit /etc/wpa_supplicant/wpa_supplicant.conf, with right network password