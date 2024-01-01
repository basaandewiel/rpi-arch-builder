
cd /srv/http
sudo git clone -b 2.7.0 --depth 1 https://github.com/kimai/kimai.git
cd kimai/
# install pre requisites
sudo pacman -S --needed composer
sudo pacman -S --needed mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb

#enable and install required php extensions by editing /etc/php/php.ini
#gd
#intl
#iconv
#xsl
#pdo
#pdo-mysql

#change value of memory_limit from 128 to 256 in /etc/php/php.ini

sudo pacman -S --needed php-gd
sudo pacman -S --needed php-xsl

#Now install all dependencies:
composer update
composer install --optimize-autoloader -n

echo "edit .env and set correct user(default kimai), password (default kimai) and mariadb version"

#Connect to your database as root user:
sudo su
mysql -u root

echo "And execute the following statements:

CREATE DATABASE IF NOT EXISTS `kimai`;
echo "change my-super-secret-password in next line"
CREATE USER IF NOT EXISTS `kimai`@127.0.0.1 IDENTIFIED BY "my-super-secret-password";
GRANT select,insert,update,delete,create,alter,drop,index,references ON `kimai`.* TO kimai@127.0.0.1;

    Replace “my-super-secret-password” with a strong password a"

#TROUBLE shooting
#look at /srv/http/kimai/var/log/prod.log
