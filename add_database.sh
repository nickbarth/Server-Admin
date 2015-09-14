#!/bin/bash

####
# Create a database and database admin user.
#
# USAGE: ./create_database main.example.us-east-1.rds.amazonaws.com mysql_root _passwd example_com _expasswd
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

MYSQL_HOST=$1
MYSQL_ADMIN=$2
MYSQL_PASSWORD=$3

DATABASE=$4
PASSWORD=$5

mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DATABASE;"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$DATABASE'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DATABASE.* TO '$DATABASE'@'%';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"
