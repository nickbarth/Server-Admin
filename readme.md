# Server-Admin

Linux Admin Scripts for Ubuntu Trusty 14.04 Amd64 Server 20150325 (ami-d05e75b8)

```bash
add_database.sh
####
# Create a database and database admin user.
#
# USAGE: ./create_database main.example.us-east-1.rds.amazonaws.com mysql_root _passwd example_com _expasswd
##

add_website.sh
####
# Add a virtual host into Apache for a given domain.
#
# USAGE: ./add_website.sh example.com
##

add_website_user.sh
####
# Create a website user and give them a folder with FTP access.
#
# USAGE: ./add_website_user.sh example_com
##

add_website_wordpress.sh

backup_database.sh

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
# USAGE: ./setup_database.sh "%MySQLRootPasswd%"
##

setup_ftp.sh
####
# Install and configure an FTP Server
#
# USAGE: ./ftp_setup.sh
##

setup_lamp.sh
####
# Run full server setup.
#
# USAGE: ./setup_lamp.sh
##

setup_server.sh
####
# Install and setup a LAMP server stack.
#
# USAGE: ./server_setup.sh
##

```

MIT &copy; 2015 Nick Barth
