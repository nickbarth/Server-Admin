#!/bin/bash

####
# Backup a website to a tarball.
#
# USAGE: ./bak_website.sh example.com
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

tar -zcvf $DOMAIN-$(date +%Y-%m-%d).backup.tar.gz
