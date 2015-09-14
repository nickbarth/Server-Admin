#!/bin/bash

DOMAIN=$1

mkdir -p /var/www/$DOMAIN/
curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DOMAIN --strip-components=1 wordpress
