#
# ***************************************
# install file for TRACKS, see http://www.getontracks.org/
#           run as normal user
# 171227 tracks only works with following versions of ruby(bundler)
#	ruby 2.3.1p112 (2016-04-26) 
#	bundler 1.12.5
#	These versions are retrieved from arm arch archive, and saved on private backup
# ***************************************
#
sync
sleep 2
# get OLD version of ruby packages
wget http://tardis.tiny-vps.com/aarm/packages/r/ruby/ruby-2.3.1-1-armv7h.pkg.tar.xz
sudo pacman -U ruby-2.3.1-1-armv7h.pkg.tar.xz
wget http://tardis.tiny-vps.com/aarm/packages/r/ruby-bundler/ruby-bundler-1.12.5-1-any.pkg.tar.xz
sudo pacman -U ruby-bundler-1.12.5-1-any.pkg.tar.xz
# prevent that these packages are upgraded by pacman
sudo sed -i.bak 's/#IgnorePkg   =/IgnorePkg   =ruby*/' /etc/pacman.conf
#
# nodejs replaces ruby which gives compile problems on ARM
sudo pacman -S --noconfirm --needed nodejs python3
cd ~ 
wget https://aur.archlinux.org/cgit/aur.git/snapshot/tracks.tar.gz
tar -xvf tracks.tar.gz
sed -i.bak "s/'ruby-bundler'//" ~/tracks/PKGBUILD
echo "Remove ruby package from PKGBUILD, because we need the old packages that are already installed"
echo "*** next command - makepkg - will fail, we know ..." 
cd tracks
makepkg -s
# 171228 gives error: An error occurred while instaling libv8 (3.16.14.7); make sure that 'gem install libv8 '3.16.14.7' 
# succeeds before bundling
# 
gem install libv8 -v 3.16.14.7 -- --with-system-v8
bundle config build.libv8 --with-system-v8
#
#
# delete line with rubyracer in Gemfile; must be done AFTER makepkg -s command
# modify and create backup
cd src/TracksApp-tracks-4070f4e/
cp Gemfile Gemfile.org
sed -i.bak '/rubyracer/d' ./Gemfile
read -n1 -r -p "CHECK Gemfile Press space to continue..." key
bundle install --without development, test
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
echo "GTD Tracks is ready"
read -n1 -r -p "TRACKS installed - Press space to continue..." key
#
# create tracks service file
sudo su
cat <<EOFSF > /etc/systemd/system/tracks.service
[Unit]
Description=Tracks
After=network.target

[Service]
#User=http                      ; to prevent error in journalctl
ExecStart=/usr/bin/bundle exec rails server -e production

WorkingDirectory= /home/baswi/tracks/src/TracksApp-tracks-4070f4e
RestartSec=5
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOFSF
#
read -n1 -r -p "Press ctrl-D to return to normal user" key
#
echo "copy BACKUPDB /home/baswi/tracks/src/TracksApp-tracks-4070f4e/db/tracks.sqlite3.db"
read -n1 -r -p "Copy current tracks-database out of backup" key
#
#
sudo systemctl start tracks
sudo systemctl enable tracks
sudo systemctl status tracks
read -n1 -r -p "Check status and Press space to continue..." key
#
