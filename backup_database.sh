#!/bin/bash

mysqldump -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST $MYSQL_DB > $MYSQL_DB-$(date +%Y-%m-%d).backup.sql
