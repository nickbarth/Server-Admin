#!/bin/bash

####
# Add a website with a user, database, and apache config. 
#
# USAGE: bash <(curl -s https://raw.githubusercontent.com/nickbarth/Server-Admin/master/curl_add_wordpress.sh) example.com
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

# Configure Script.
if [ ! -f ~/domains/$DOMAIN.sh ]; then
  echo "Configuration file not found." 1>&2
  exit 2
else
  source ~/domains/$DOMAIN.sh
fi

# Download Files
mkdir -p /var/www/${DOMAIN['name']} && cd /var/www/${DOMAIN['name']}
curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory /var/www/${DOMAIN['name']} --strip-components=1 wordpress

# Configure Wordpress
mv wp-config-sample.php wp-config.php

# Database
sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', '${DOMAIN['database_name']}'/" wp-config.php
sed -i "s/'DB_USER', 'username_here'/'DB_USER', '${DOMAIN['database_user']}'/" wp-config.php
sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '${DOMAIN['database_host']}'/" wp-config.php
sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '${DOMAIN['database_password']}'/" wp-config.php

# Salts
curl -s https://api.wordpress.org/secret-key/1.1/salt/ | while read LINE; do
  FIND=$(echo $LINE | grep -o "'[^']*',")
  LINENUMBER=$(grep -n "$FIND" ./wp-config.php | awk -F: '{ print $1 }')
  sed -i "${LINENUMBER}d" ./wp-config.php
  sed -i "${LINENUMBER}i${LINE}" ./wp-config.php
done
