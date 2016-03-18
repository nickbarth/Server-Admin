#!/usr/bin/env bash

####
# Setup a new server with a lamp stack.
#
# USAGE: sudo bootstrap.sh
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

IDOMAIN='example.com'
MYSQL_PASSWORD='mysql'
PASSWORD='password'
DOMAIN=$(echo ${IDOMAIN,,} | sed 's/\./_/g')
DATABASE=${DOMAIN}

# update and upgrade dependencies
apt-get -y update
apt-get -y upgrade

# install apache, php, and other dependencies
apt-get install -y apache2 mysql-client php5 vsftpd ufw php5-common php5-mysql php5-xmlrpc php5-cgi php5-curl php5-gd php5-cli php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt libapache2-mod-php5 libapache2-mod-security2 libapache2-mod-evasive libxml2 ca-certificates git curl make

# install mysql and give password to installer
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"
apt-get -y install mysql-server

# install phpmyadmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
apt-get -y install phpmyadmin

# setup apache
echo "$(curl -s ip.appspot.com) $(hostname)" >> /etc/hosts
a2dissite 000-default.conf
rm /etc/apache2/sites-available/000-default.conf
rm -rf /var/www/html/

echo "ServerName localhost" >> /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_connect
a2enmod rewrite
a2enmod security2
a2enmod evasive

service apache2 restart

# install composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# setup website
adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN
echo "$DOMAIN:$PASSWORD" | chpasswd

cat > /etc/apache2/sites-available/$DOMAIN.conf <<- EOF
<VirtualHost *:80>
  ServerName $IDOMAIN
  # ServerAlias *.$IDOMAIN
  DocumentRoot /var/www/$DOMAIN

  CustomLog /var/log/apache2/${DOMAIN}_access.log combined
  ErrorLog /var/log/apache2/${DOMAIN}_error.log

  <Directory />
    Options FollowSymLinks
    AllowOverride All
  </Directory>

  <Directory /var/www/$DOMAIN>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>
</VirtualHost>
EOF

a2ensite $DOMAIN
service apache2 reload
service vsftpd restart

# setup website database
MYSQL_USER="${USERNAME:0:15}"

mysql --host="localhost" --user="root" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DATABASE;"
mysql --host="localhost" --user="root" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="localhost" --user="root" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DATABASE.* TO '$MYSQL_USER'@'%';"
mysql --host="localhost" --user="root" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"

# set permissions
mkdir -p /var/www/${DOMAIN} && cd /var/www/${DOMAIN}
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod 666 .htaccess
chown -R ${DOMAIN}:www-data /var/www/${DOMAIN}

# setup ftp
sed -i "s/#\(chroot_local_user=YES\)/\1/" /etc/vsftpd.conf
sed -i "s/#\(write_enable=YES\)/\1/" /etc/vsftpd.conf
sed -i "s/\(pam_service_name=\)vsftpd/\1ftp/" /etc/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf

cat << EOF >> /etc/vsftpd.conf
# Support for Passive Mode FTP clients
pasv_enable=YES
pasv_max_port=12100
pasv_min_port=12000
port_enable=YES
pasv_address=$(curl -s ip.appspot.com)

# 750 file uploads
file_open_mode=0777
local_umask=027
EOF

service vsftpd restart

# log credentials
mkdir -p ~/domains/ && tee ~/domains/$DOMAIN.sh <<- EOF
declare -A DOMAIN=()
DOMAIN['url']=$IDOMAIN
DOMAIN['name']=$DOMAIN
DOMAIN['http_path']="/var/www/$DOMAIN"
DOMAIN['http_config']="/etc/apache2/sites-available/$DOMAIN.conf"
DOMAIN['logs_access']="/var/log/apache2/${DOMAIN}_access.log"
DOMAIN['logs_error']="/var/log/apache2/${DOMAIN}_error.log"
DOMAIN['database_name']="$DOMAIN"
DOMAIN['database_host']="$MYSQL_HOST"
DOMAIN['database_user']="$MYSQL_USER"
DOMAIN['database_password']="$PASSWORD"
DOMAIN['ftp_user']="$DOMAIN"
DOMAIN['ftp_password']="$PASSWORD"
EOF
