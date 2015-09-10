#!/bin/bash

# Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

apt-get install -y vsftpd
sed -i "s/#\(chroot_local_user=YES\)/\1/" /etc/vsftpd.conf
sed -i "s/#\(write_enable=YES\)/\1/" /etc/vsftpd.conf

service vsftpd restart
