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
service apache2 restart
