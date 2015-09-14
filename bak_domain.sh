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
