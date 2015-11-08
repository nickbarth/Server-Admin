#!/bin/bash

####
# Install and setup an FTP Server
#
# USAGE: ./setup_ftp.sh
##

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

apt-get install -y vsftpd
sed -i "s/#\(chroot_local_user=YES\)/\1/" /etc/vsftpd.conf
sed -i "s/#\(write_enable=YES\)/\1/" /etc/vsftpd.conf
sed -i "s/\(pam_service_name=\)vsftpd/\1ftp/" /etc/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf

cat << EOF >> /etc/vsftpd.conf
# Support for Passive Mode FTP clients
pasv_enable=YES
pasv_max_port=12100
pasv_min_port=12000
port_enable=YES
pasv_address=$(curl -s ip.appspot.com)

# Default for 775 file uploads
file_open_mode=0777
local_umask=002
EOF

service vsftpd restart
