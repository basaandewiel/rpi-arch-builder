#install SAMBA
sudo pacman -S --needed samba
#udo scp -P321 baswi@rpi3:/etc/samba/smb.conf ./ 
sudo pdbedit -a -u baswi #create samba user
sudo systemctl enable smb.service
sudo systemctl start smb
sudo systemctl status smb
read -p "check whether smb service is running" key
