#!/bin/bash

####
# Run full LAMP server setup with FTP.
#
# USAGE: ./setup_lamp.sh
##

source setup_server.sh
source setup_ftp.sh
source setup_database.sh

a2dissite 000-default.conf
rm /etc/apache2/sites-available/000-default.conf

a2enmod proxy
a2enmod proxy_http
a2enmod proxy_connect
a2enmod rewrite

service apache2 restart
