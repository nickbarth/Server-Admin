#!/bin/bash

####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh
###

USER=$1

adduser --system --ingroup www-data --home /var/www/$USER $USER

service vsftpd restart
