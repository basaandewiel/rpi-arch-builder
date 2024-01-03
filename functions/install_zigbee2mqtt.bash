#install zigbee2mqtt
echo -p "answer yes to remove node-js BUT KEEP nodejs-lts-hydrogen" key
sudo pacman -S --needed zigbee2mqtt

echo -p "put in Zigbee USB stick (without USB extender; that can lead to crash is my experience)" keya
sudo systemctl start zigbee2mqtt
sudo systemctl enable zigbee2mqtt
systemctl status zigbee2mqtt

echo -p "check status" 


    /etc/zigbee2mqtt/configuration.yaml
        first add next to config
            advanced:
            network_key:GENERATE
        after starting generates the network_key you can see below
        homeassistant: false
        permit_join: true
        mqtt:
          base_topic: zigbee2mqtt
          server: mqtt://192.168.1.1
        serial:
          port: /dev/ttyUSB0
        advanced:
          network_key:
            - 132
            - 202
            - 121
            - 0
            - 231
            - 150
            - 231
            - 219
            - 252
            - 196
            - 231
            - 71
            - 190
            - 75
            - 72
            - 186
          homeassistant_legacy_entity_attributes: false
          legacy_api: false
          legacy_availability_payload: false
        frontend:
          port: 4002
        device_options:
          legacy: false
        devices:
          '0xcc86ecfffeab7f88':
            friendly_name: '0xcc86ecfffeab7f88'
          '0xb4e3f9fffe780c32':
            friendly_name: '0xb4e3f9fffe780c32'

# front end available at port 4002 (port configured above)
