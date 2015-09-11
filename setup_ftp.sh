#!/bin/bash

####
# Install and configure an FTP Server
#
# USAGE: ./ftp_setup.sh
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

service vsftpd restart
