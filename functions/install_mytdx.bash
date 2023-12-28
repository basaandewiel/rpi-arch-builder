#
#Oude mytinytodolist deed het wel (op RPI4:4000)
#MyTDX deed het niet op port 5000; ook niet op port 6000 (blijft ie oneindig lang laden)
#maar wel op port 4001.
#Port 5000 wordt voor upnp gebruikt; blijkbaar is die op RPI4 bezet? maar dat blijkt niet uit netstat -tulpn#
#
#NB: als je systemctl restart nginx - doet, dan haalt hij niet alle oude processen weg;
#hierdoor kunnen poorten in gebruik blijven.
#Check met: netstat -tulpn
#
#Doe eerst pkill nginx, en dan 
#systemctl restart nginx
#-
#
# Install myTDX
# Run as ROOT
#
# 
# HISTORY
# 190929 baswi created
#
# install necesary packages
pacman -S nginx
pacman -S php-cgi
pacman -S php-fpm
pacman -S php-sqlite
#
# configuration files
#
read -p "uncomment /etc/php/php.ini ;extension=pdo_sqlite" key
#
echo "edit /etc/php/php-fpm.d/www.conf"
echo "180217 baswi commented next line, and added line after that"
echo ";listen = /run/php-fpm/php-fpm.sock"
echo "listen = 127.0.0.1:9000"
read -p "press key after finishing editing"

#
mkdir /etc/nginx/conf.d
cd /etc/nginx/conf.d
cat <<EOF1 >myTDX.conf
#
# /etc/nginx/conf.d/myTDX.conf
#
#
server {
    listen 5000 default_server;
#       listen [::]:4000 default_server;
    root /srv/http/myTDX;
    server_name _;
    autoindex off;
    proxy_intercept_errors on;
#       error_page 404 /pihole/index.php;
    index myTDX/index.php index.php index.html index.htm;
    location / {
        expires max;
        try_files $uri $uri/ =404;
        add_header X-Pi-hole "A black hole for Internet advertisements";
    }
    location ~ \.php$ {
        include fastcgi.conf;
        fastcgi_intercept_errors on;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_param SERVER_NAME \$host;
    }
    location ~ /\.ht {
        deny all;
    }
}

EOF1
#
read -p "DIY - cp -r RPI3/etc/nginx RPI4/etc/" key

# make some file writeble
chmod 777 /srv/http/myTDX/db/config.php
chmod 777 /srv/http/myTDX/db/todolist.db

# create relative tmp directory; necessary if you want to use password (and file based sessions)
mkdir /srv/http/myTDX/tmp

echo "DIY - cp -r RPI3/srv/http RPI4/srv/"
echo "DIY - chown -R http:http *"
read -p "cp server files, includes db, to /srv/http/myTDX" key
#
systemctl start php-fpm
systemctl enabel php-fpm
systemctl start nginx
systemctl enable nginx
read -p "open laptop: RPI4:port:test.php" key
read -p "open http://192.168.2.14:5000/setup.php" key
#
#Check port usage 
netstat -tulpn
# restart nginx does not make all nginx ports unused, so kill all nginx processes
pkill nginx
systemctl restart nginx
