#
#	Install script for Radicale - address and calendar server
#
read -n1 -r -p "PRECONDITION: pacaur installed; hit any key" key

#install AUR package radicale
pacaur -S --noedit --noconfirm radicale
#install AUR package apache-tools
pacaur -S --noedit --noconfirm apache-tools
#
sudo mkdir /etc/radicale
read -r -p "Give userid for end user of radicale" userid
sudo htpasswd -c -s /etc/radicale/users $userid
echo "calendars are stored at /var/lib/radicale/collections/<userid>"
#
read -n1 -r -p "MANUALLY copy /etc/radicale/config from backup; when done press any key" key
sudo cp /mnt/backup_plain/bas/daily.0/homeserver3/etc/etc/radicale/config /etc/radicale/config
echo "or edit manually"
#under auth
#	type = htpasswd
#	htpasswd_filename = /etc/radicale/users
#	htpasswd_encryption = sha1
#  under rights
#	*Do NOT do this* type = owner_only *gives problems when creating more than 1 users Davdroid accounts 
#
echo "copy calenders from backup" 
echo "radicale folder names are changed with regard to older version; default storage location is now:"
echo "	/var/lib/radicale/collection-root/<user>" 
echo "cp -r /BACKUPLOCATION/var/lib/radicale/collections /var/lib/radicale/collection-root/<user>"
echo "IF you want to import ICS file: curl -u 'user:password' -X PUT http://localhost:5232/user/calendar --data-binary @cal.ics"
read "hit any key when ready" key
#
echo "change service file, to prevent error 30: read-only file system"
#sed -i.bak "s/'#ReadWritePaths=/var/lib/radicale/collections/'/'ReadWritePaths=/var/lib/radicale'/"
read -n1 -r -p "MANUALLY add - ReadWritePaths=/var/lib/radicale -in file/usr/lib/systemd/system/radicale.service; press key"
#
#
# start server at boot
sudo systemctl enable radicale
sudo systemctl start radicale
sudo systemctl status radicale
