#!/bin/bash
mysql --host="localhost" --user="root" --execute="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWD');"
