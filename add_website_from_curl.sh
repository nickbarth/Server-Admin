#!/bin/bash

####
# Add a website with a user, database, and apache config. 
#
# USAGE: ./add_full_website.sh example.com passwd
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
PASSWORD=$2

# Import: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
source ./database_config.sh

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN
echo "$DOMAIN:$PASSWORD" | chpasswd

service vsftpd restart

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
PASSWORD=$2

mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DOMAIN;"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$DOMAIN'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DOMAIN.* TO '$DOMAIN'@'%';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

cat > /etc/apache2/sites-available/$DOMAIN.conf <<- EOF
<VirtualHost *:80>
  ServerName $DOMAIN
  # ServerAlias *.$DOMAIN
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
