#!/bin/bash
echo "Start docker-entrypoint.sh"

set -e

# Environment variables that are used if not empty:
#   PASSWORD

#Folder for sshd. No Change.
mkdir -p /var/run/sshd

# Config SSH
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#
sed -ri 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
#

#Set password
echo "Set  password of user for sshd"
echo 'root:'$PASSWORD |chpasswd

echo "Run sshd"

#while true; do sleep 1; done

exec "$@"
