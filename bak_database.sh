#!/bin/bash

####
# Backup a database to an SQL file.
#
# USAGE: ./bak_database.sh example.com
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Import: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
source ./database_config.sh

# Domain lowercased and no periods eg. example_com
DOMAIN=$(echo ${1,,} | sed 's/\./_/g')

mysqldump -u $MYSQL_ADMIN -p$MYSQL_PASSWD -h $MYSQL_HOST $DOMAIN > $DOMAIN-$(date +%Y-%m-%d).backup.sql
