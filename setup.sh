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
sudo apt update
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh

