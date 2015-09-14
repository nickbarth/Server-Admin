#!/bin/bash

####
# Add a virtual host into Apache for a given domain.
#
# USAGE: ./add_website_apache_config.sh example.com
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

DOMAIN=$1

cat > /etc/apache2/sites-available/$DOMAIN.conf <<- EOF
<VirtualHost *:80>
  ServerName $DOMAIN
  # ServerAlias *.$DOMAIN
  DocumentRoot /var/www/$DOMAIN

  CustomLog /var/log/apache/$DOMAIN_access.log combined
  ErrorLog /var/log/apache/$DOMAIN_error.log

  <Directory />
    Options FollowSymLinks
    AllowOverride All
  </Directory>

  <Directory /var/www/$DOMAIN>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>
</VirtualHost>
EOF

a2ensite $DOMAIN
service apache2 reload
