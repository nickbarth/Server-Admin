#!/bin/bash

source ./add_website_user.sh

curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DOMAIN --strip-components=1 wordpress
