#this file contains all stuff necessary for 
#   ***read only root file system
#   ***run AS ROOT
#
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
echo "tmpfs 	/var/log tmpfs defaults,noatime,mode=0755 0 0" >> /etc/fstab
echo "tmpfs     /var/cache/pacman tmpfs defaults,noatime        0   0" >> /etc/fstab
#
# DHCP does not work with Readonly root, so
#
# source https://www.dinotools.de/2014/03/28/raspi-arch-linux-read-only-root-fs/
#Wird die IP-Adresse per DHCP bezogen und sind die Nameserver nicht fest vorgegeben, muss die Datei /etc/resolv.conf schreibbar sein. Hierfür wird ein Symlink in das /tmp Verzeichnis angelegt.
rm /etc/resolv.conf
ln -s /tmp/resolv.conf /etc/resolv.conf
#
#Adjust journald service to not log the system log to prevent flooding of the /var/log folder
#nano /etc/systemd/journald.conf
#Uncomment and set "Storage=none"
sed -i.org 's/#Storage=auto/Storage=none/' /etc/systemd/journald.conf
#
# sync time; TODO: at every reboot
# systemd-timesyncd does NOT work with RO root FS, but ntpd does
pacman -S ntpd
systemctl disable systemd-timesyncd
ntpd -gq
# create /etc/systemd/system/ntp-once.service
cat <<NTPONCE > /etc/systemd/system/ntp-once.service1
[Unit]
Description=Network Time Service (once)
After=network.target nss-lookup.target
[Service]
Type=oneshot
ExecStart=/usr/bin/ntpd -qg
[Install]
WantedBy=multi-user.target
NTPONCE
systemctl enable ntpd-once
systemctl restart ntpd-once
systemctl enable ntpd


#Put shortcut shell scripts to re-enable read-write temporarily if needed
printf "mount -o remount,rw /\nmount -o remount,rw /boot" > writeenable.sh
printf "mount -o remount,ro /\nmount -o remount,ro /boot" > readonly.sh
chmod 500 writeenable.sh
chmod 500 readonly.sh
#
#Tell the kernel to mount root filesystem read-only!
Finally getting there.. Add ” ro” at the end of your  /boot/cmdline.txt line. BASWI: or replace rw door ro
sed -i.org 's/rw/ro/' /boot/cmdline.txt


