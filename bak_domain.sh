#!/bin/bash

####
# Backup a website and its database.
#
# USAGE: ./bak_domain.sh example.com
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

./bak_website.sh $DOMAIN
./bak_database.sh $DOMAIN
