# Server-Admin

Linux Admin Scripts for Ubuntu Trusty 14.04 Amd64 Server 20150325 (ami-d05e75b8)

```bash
# Documenation:

add_website_apache_config.sh
####
# Add a virtual host into Apache for a given domain.
#
# USAGE: ./add_website_apache_config.sh example.com
##

add_website_database.sh
####
# Create a database and database admin user.
#
# USAGE: ./add_website_database.sh example.com passwd
##

add_website_full.sh
####
# Add a website with a user, database, and apache config. 
#
# USAGE: ./add_website_full.sh example.com passwd
##

add_website_user.sh
####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh example_com passwd
##

add_website_wordpress.sh
####
# Add, configure, and setup a Wordpress installation. 
#
# USAGE: ./add_website_wordpress.sh example.com passwd
##

bak_database.sh
####
# Backup a database to an SQL file.
#
# USAGE: ./bak_database.sh example.com
##

bak_domain.sh
####
# Backup a website and its database.
#
# USAGE: ./bak_domain.sh example.com
##

bak_website.sh
####
# Backup a website to a tarball.
#
# USAGE: ./bak_website.sh example.com
##

config_database.sh
####
# Configure database connection settings.
#
# USAGE: source ./config_database.sh
#
# EXPORTS: MYSQL_HOST, MYSQL_ADMIN, MYSQL_PASSWORD
# eg. main.example.us-east-1.rds.amazonaws.com, root, passwd
##

readme.sh
####
# Generates a readme with explaination of scripts.
#
# USAGE: ./readme.sh
##

setup_database.sh
####
# Install and setup a MySQL Server.
#
# USAGE: ./setup_database.sh
##

setup_ftp.sh
####
# Install and setup an FTP Server
#
# USAGE: ./setup_ftp.sh
##

setup_lamp.sh
####
# Run full LAMP server setup with FTP.
#
# USAGE: ./setup_lamp.sh
##

setup_server.sh
####
# Install and setup a server stack.
#
# USAGE: ./setup_server.sh
##

```

MIT &copy; 2015 Nick Barth
