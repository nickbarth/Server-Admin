#!/bin/bash

####
# Install and setup a MySQL Server.
#
# USAGE: ./setup_database.sh
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Import: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
source ./database_config.sh

DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
mysql --host="$MYSQL_HOST" --user="$MYSQL_ADMIN" --execute="SET PASSWORD FOR '$MYSQL_ADMIN'@'$MYSQL_HOST' = PASSWORD('$MYSQL_PASSWORD');"
