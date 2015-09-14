#!/bin/bash


echo "# Server-Admin" > readme.md
echo "# Linux Admin Scripts for Ubuntu Trusty 14.04 Amd64 Server 20150325 (ami-d05e75b8)" >> readme.md

echo "MIT &copy; 2015 Nick Barth"


for SCRIPT in $(ls *.sh); do
  echo $SCRIPT
  awk '/^####$/,/^##$/' $SCRIPT
  echo
done
