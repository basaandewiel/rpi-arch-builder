#install zigbee2mqtt
read -p "answer yes to remove node-js BUT KEEP nodejs-lts-hydrogen" key
sudo pacman -S --needed zigbee2mqtt

node --version
npm --version
read -p "node must be v18 or higher; npm >=9.x" key
sudo rm -rf /opt/zigbee2mqtt
sudo mkdir /opt/zigbee2mqtt
sudo chown -R ${USER}: /opt/zigbee2mqtt/
git clone --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt
cd /opt/zigbee2mqtt/
npm ci
npm run build

read -p "put in Zigbee USB stick (without USB extender; that can lead to crash is my experience)" keya
read -p "find out serial port, like /dev/ttyAMA10 that USB stick uses, fr via dmesg, and fill in this device in /etc/zigbee2mqtt/configuration.yaml" key

cat <<EOF > /opt/zigbee2mqtt/data/configuration.yaml
homeassistant: false
permit_join: true
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://192.168.1.1
serial:
  port: /dev/ttyUSB0
advanced:
  homeassistant_legacy_entity_attributes: false
  network_key: GENERATE
  legacy_api: false
  legacy_availability_payload: false
frontend:
  port: 4002
device_options:
      legacy: false
EOF

sudo chown -R zigbee2mqtt:zigbee2mqtt /opt/zigbee2mqtt


#@@@ create service file


sudo systemctl start zigbee2mqtt
sudo systemctl enable zigbee2mqtt
systemctl status zigbee2mqtt

read -p "check status; als in con*.yaml a network key should be generated" key

# front end available at port 4002 (port configured above)
