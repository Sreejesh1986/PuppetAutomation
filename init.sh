#!/bin/bash

set -e -x

apt-get --yes --quiet update && apt-get -y --quiet upgrade
sudo apt-get install -y --quiet apache2 && sudo apt-get install -y --quiet apache2-utils
sudo systemctl enable apache2 && sudo systemctl start apache2
sudo apt-get install -y --quiet  mysql-client
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor' && sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor' && sudo apt-get -y install mysql-server
sudo apt-get install -y --quiet php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/  
mysql -uroot -ptoor -e "create database wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO root@localhost IDENTIFIED BY 'toor';FLUSH PRIVILEGES"
cd /var/www/html/
sudo mv wp-config-sample.php wp-config.php
perl -pi -e "s'database_name_here'"wordpress"'g" wp-config.php
perl -pi -e "s'username_here'"root"'g" wp-config.php
perl -pi -e "s'password_here'"toor"'g" wp-config.php
sudo systemctl restart apache2.service && sudo systemctl restart mysql.service 