#!/bin/bash

MYSQL_ROOT_PASSWD=$1

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

mysql --host="localhost" --user="root" --execute="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWD');"
