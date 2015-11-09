#!/bin/bash

####
# Setup a website with a user, database, and apache config via curl piped to bash. 
#
# USAGE: bash <(curl -s https://raw.githubusercontent.com/nickbarth/Server-Admin/master/curl_add_website.sh) example.com passwd
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

# Configure Script.
# Import: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
if [ ! -f ~/config.sh ]; then
  echo "Configuration file not found." 1>&2
  exit 2
else
  source ~/config.sh
  
  IDOMAIN=$1
  DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
  PASSWORD=$2
fi

if [ -z "$DOMAIN" ] || [ -z "$PASSWORD" ]; then
  echo "Domain and password required." 1>&2
  exit 3
fi

# Protect from MySQL username length error.
MYSQL_USER="${DOMAIN:0:15}"

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN
echo "$DOMAIN:$PASSWORD" | chpasswd

service vsftpd restart

mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DOMAIN;"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DOMAIN.* TO '$MYSQL_USER'@'%';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"

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
