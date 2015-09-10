#!/bin/bash

####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh
###

USER=$1
useradd --system --home /var/www/$USER --group www-data $USER

mkdir /var/www/$USER
