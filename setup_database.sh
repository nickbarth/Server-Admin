#!/bin/bash

####
# Install and setup a MySQL Server.
#
# USAGE: ./setup_database.sh "%MySQLRootPasswd%"
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

MYSQL_ROOT_PASSWD=$1

DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
mysql --host="localhost" --user="root" --execute="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWD');"
