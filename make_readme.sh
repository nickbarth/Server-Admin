#!/bin/bash

for SCRIPT in $(ls *.sh); do
  echo $SCRIPT
  awk '/^####$/,/^##$/' $SCRIPT
  echo
done
