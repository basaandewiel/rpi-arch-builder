# 
# HISTORY
# 171230 baswi created - manually tested on 171230
# 180713 baswi added "User=baswi" in motion service file; necessary for cadaver to be able to find $HOME variable	
#
# 	180521 odnerstaande werkt niet meer; toen volgende gedaan
#	$pacaur -S motion	#dit leek te werken
#
# not sure of ffmpeg is necessary
sudo pacman -Sy ffmpeg
#
wget https://github.com/Motion-Project/motion.git
autoreconf -fiv
./configure
make
sudo make install
echo "The default configuration file: /usr/local/etc/motion/motion-dist.conf"
echo "You need to rename/copy it to motion.conf for Motion to find it. "
echo "More configuration examples as well as init scripts can be found in /usr/local/share/motion/examples."
#
cp /usr/local/etc/motion/motion-dist.conf /usr/local/etc/motion/motion.conf
cp /usr/local/etc/motion/camera2-dist.conf /usr/local/etc/motion/camera2.conf
#
echo "MANUALLY edit motion.conf and camera?.conf files"
echo "NB: info below contains private settngs for me, and don't apply in general"
echo "camera2.conf should contain
netcam_url      rtsp://E35067479:51669@192.168.1.29:8554/2.3gp
width 640
height 360
on_movie_start  bash -x /home/baswi/scripts/on_motion_begin.bash %f
on_movie_end bash -x /home/baswi/scripts/on_motion_end.bash %f
target_dir /tmp
picture_filename CAM2_%v-%Y%m%d%H%M%S-%q"
#
#
# install ao openRTSP
sudo pacman -S live-media
#
# install megatools, to be able to save images on MEGA
yay -S megatools
#
#
# create motion service file
#
cat <<EOFMOTIONSERVICE > /usr/lib/systemd/system/motion.service

[Unit]
Description=Motion daemon
After=local-fs.target network.target

[Service]
User=baswi
PIDFile=/var/run/motion.pid
ExecStart=/usr/bin/motion -n
Type=simple
StandardError=null
RestartSec=5
Restart=on-failure
ExecStopPost=/usr/bin/rm /tmp/*.{jpg,mkv}


[Install]
WantedBy=multi-user.target
#
EOFMOTIONSERVICE
#
#

# enable and start motion service
sudo systemctl enable motion
sudo systemctl start motion
sudo systemctl status motion
#
