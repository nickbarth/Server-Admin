#!/bin/bash

####
# Add, configure, and setup a Wordpress installation. 
#
# USAGE: ./add_website.sh example.com
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

source ./add_website_user.sh

curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DOMAIN --strip-components=1 wordpress
