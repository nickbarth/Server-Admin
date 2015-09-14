#!/bin/bash

####
# Add, configure, and setup a website installation. 
#
# USAGE: ./add_website.sh example.com passwd
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')
PASSWORD=$2

# Create User
./add_website_user.sh $DOMAIN $PASSWORD
./add_website_database.sh $DOMAIN $PASSWORD
./add_website_apache_config.sh $DOMAIN
