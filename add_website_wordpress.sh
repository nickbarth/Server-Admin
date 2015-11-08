#!/bin/bash

####
# Add, configure, and setup a Wordpress installation. 
#
# USAGE: ./add_website_wordpress.sh example.com passwd
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
PASSWORD=$2

# Create User
./add_website.sh $DOMAIN $PASSWORD

# Download Files
curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory /var/www/$DOMAIN --strip-components=1 wordpress

# Configure Wordpress
cd /var/www/$DOMAIN
mv wp-config-sample.php wp-config.php

# Database
sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', '$DOMAIN'/" wp-config.php
sed -i "s/'DB_USER', 'username_here'/'DB_USER', '$DOMAIN'/" wp-config.php
sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '$PASSWORD'/" wp-config.php
sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '$PASSWORD'/" wp-config.php

# Salts
curl -s https://api.wordpress.org/secret-key/1.1/salt/ | while read LINE; do
  FIND=$(echo $LINE | grep -o "'[^']*',")
  LINENUMBER=$(grep -n "$FIND" ./wp-config.php | awk -F: '{ print $1 }')
  sed -i "${LINENUMBER}d" ./wp-config.php
  sed -i "${LINENUMBER}i${LINE}" ./wp-config.php
done

# FTP
cat >> ./wp-config.php <<- EOF
define('FS_METHOD', 'ftpext');
define('FTP_BASE', '${DOMAIN['http_path']}');
define('FTP_USER', '${DOMAIN['ftp_user']}');
define('FTP_PASS', '${DOMAIN['ftp_password']}');
define('FTP_HOST', '${DOMAIN['url']}');
define('FTP_SSL', false);
EOF

echo "Wordpress installed to ${DOMAIN['http_path']}."
