#!/bin/bash

####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh example_com
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Lowercase and no periods
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN

service vsftpd restart
