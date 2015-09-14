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

sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', '$DOMAIN'/" wp-config.php
sed -i "s/'DB_USER', 'username_here'/'DB_USER', '$DOMAIN'/" wp-config.php
sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '$PASSWORD'/" wp-config.php
sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '$PASSWORD'/" wp-config.php



