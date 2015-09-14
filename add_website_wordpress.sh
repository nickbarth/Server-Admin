#!/bin/bash

DOMAIN=$1
curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DOMAIN --strip-components=1 wordpress
