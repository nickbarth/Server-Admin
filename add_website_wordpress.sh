#!/bin/bash

echo -n "Domain: "
read DOMAIN

curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DOMAIN --strip-components=1 wordpress
