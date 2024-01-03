pacman -S encfs
#pacman -S fuse2	***weet niet of dat nodig is
#zorg dat kernel module fuse is loaded on boot
echo "fuse" > /etc/modules-load.d/fuse.conf
