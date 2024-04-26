#!/bin/bash

# Path constants
logpath=/sftplogs/sftp.log
extlogpath=/sftplogs/sftp_ext.log

# Local variables
hostname=$(hostname)
ip_address=$(ip a | grep -E 'inet (192\.)' | awk '{print $2}' | cut -d '/' -f 1)

# Log writing
echo "$(date +'%Y-%m-%d %H:%M:%S')|$hostname|$ip_address" | sudo tee -a "$logpath"

# Inventory line ip extraction
lines=();
while read -r line; do
    part_after_space=$(echo "$line" | cut -d ' ' -f2-)
    lines+=("$part_after_space"); 
done < "/home/vagrant/inventory"

# SFTP file transfering
echo "Connecting to ${lines[0]}"
sftp "${lines[0]}" << EOF
put $logpath $extlogpath
EOF