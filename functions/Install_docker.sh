# Install Docker and enable Docker deamon
# Run as ROOT
# *************NOT YET TESTED ***********
# 
# HISTORY
# 190527 baswi created
pacman -S docker
# default Docker can only be run as root
# create group docker
groupadd docker
gpasswd -a baswi docker
#
systemctl start docker.service 
systemctl enable docker.service
#
