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

tar -zcvf $DOMAIN-$(date +%Y-%m-%d).backup.tar.gz
