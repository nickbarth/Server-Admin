#!/bin/bash

####
# Setup a new database via curl piped to bash. 
#
# USAGE: bash <(curl -s https://raw.githubusercontent.com/nickbarth/Server-Admin/master/curl_add_database.sh) database username password
##

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

# Configure Script.
# Import: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
if [ ! -f ~/config.sh ]; then
  echo "Configuration file not found." 1>&2
  exit 2
else
  source ~/config.sh
  
  DATABASE=$1
  USERNAME=$2
  PASSWORD=$3
fi

if [ -z "$DATABASE" ] || [ -z "$USERNAME" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Database, Username, and password required." 1>&2
  exit 3
fi

# Protect from MySQL username length error.
MYSQL_USER="${USERNAME:0:15}"

mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE DATABASE $DATABASE;"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$PASSWORD';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $DATABASE.* TO '$MYSQL_USER'@'%';"
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --password="$MYSQL_PASSWORD" --execute="FLUSH PRIVILEGES;"
