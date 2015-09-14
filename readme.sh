#!/bin/bash

####
# Generates a readme with explaination of scripts.
#
# USAGE: ./readme.sh
##

echo "# Server-Admin" > readme.md
echo "Linux Admin Scripts for Ubuntu Trusty 14.04 Amd64 Server 20150325 (ami-d05e75b8)" >> readme.md

for SCRIPT in $(ls *.sh); do
  echo $SCRIPT >> readme.md
  awk '/^####$/,/^##$/' $SCRIPT >> readme.md
  echo >> readme.md
done

echo "MIT &copy; 2015 Nick Barth" >> readme.md
