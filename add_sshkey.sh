#!/bin/bash

##
# Add an empty passphrase SSH key
###

sh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
