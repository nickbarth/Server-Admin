#!/bin/bash

####
# Add a website with a user, database, and apache config. 
#
# USAGE: bash <(curl -s https://raw.githubusercontent.com/nickbarth/Server-Admin/master/add_website_from_curl.sh) example.com passwd
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
  
  RAWDOMAIN=$1
  DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
  PASSWORD=$2
fi

# Check length of domain to protect from MySQL username length error.
if [ ${#DOMAIN} -ge 15 ]; then
  echo "Domain user is longer than allowed for MySQL."
  exit
fi

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN
echo "$DOMAIN:$PASSWORD" | chpasswd

service vsftpd restart

mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DOMAIN;"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$DOMAIN'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DOMAIN.* TO '$DOMAIN'@'%';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"

cat << EOF >> /etc/apache2/sites-available/$DOMAIN.conf
<VirtualHost *:80>
  ServerName $RAWDOMAIN
  # ServerAlias *.$RAWDOMAIN
  DocumentRoot /var/www/$DOMAIN

  CustomLog /var/log/apache/$DOMAIN_access.log combined
  ErrorLog /var/log/apache/$DOMAIN_error.log

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

cat << EOF >> ~/websites.txt
=======
DOMAIN: $RAWDOMAIN
PATH: /var/www/$DOMAIN
DATABASE:
  - DB: $DOMAIN
  - HOST: $MYSQL_HOST
  - USER: $DOMAIN
  - PASS: $PASSWORD
FTP:
  - USER: $DOMAIN
  - PASS: $PASSWORD
EOF
