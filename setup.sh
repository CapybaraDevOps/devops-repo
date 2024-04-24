#!/bin/bash

# Append Public key to authorized_keys
cat ~/.ssh/vagrant_rsa.pub >> ~/.ssh/authorized_keys
# Set read pervition for privat key
chmod 400 ~/.ssh/vagrant_rsa

# Create SSH config file
cat <<END > ~/.ssh/config
Host 192.168.100.*
    User vagrant
    IdentityFile ~/.ssh/vagrant_rsa
    IdentitiesOnly yes
END
chmod 600 ~/.ssh/config

# Ensure if sftp is installed and started 
sudo apt -y update
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh

# Ensure if rkhunter is installed
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y vsftpd rkhunter
sudo rkhunter --update
sudo rkhunter --propupd
sudo rkhunter -c --enable all --disable none --skip-keypress

