#!/bin/bash

DIRECTORY=$1
curl -s https://wordpress.org/latest.tar.gz | tar -zxf - --directory $DIRECTORY --strip-components=1 wordpress
