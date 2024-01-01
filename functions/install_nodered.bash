echo "RUN AS ROOT" 

yay -S --needed nodejs-node-red
# create service file
sudo su
cat <<EOF > /etc/systemd/system/nodered.service 
[Unit]
Description=nodered
[Service]
Type=simple
#Restart=always
#RestartSec=10
ExecStart=/usr/bin/node-red-pi --max-old-space-size=256 --userDir /home/baswi/.node-red
[Install]
WantedBy=default.target
EOF

systemctl enable nodered
systemctl start nodered

