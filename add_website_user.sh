#!/bin/bash

####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh example_com
###

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo -n "DOMAIN: "
  read $DOMAIN
fi

# Lowercase and no periods
DOMAIN=$(echo ${DOMAIN,,} | sed 's/\./_/g')

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN

service vsftpd restart
