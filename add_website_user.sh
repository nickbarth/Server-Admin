#!/bin/bash

####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh example_com passwd
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
PASSWORD=$2

adduser --system --ingroup www-data --home /var/www/$DOMAIN $DOMAIN
echo "$DOMAIN:$PASSWORD" | chpasswd

service vsftpd restart
