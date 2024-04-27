#!/bin/bash

# Path constants
logpath=/var/log/sftp.log
temp_log=/tmp/sftp_from_node.log

# Local variables
hostname=$(hostname)
ip_address=$(ip a | grep -E 'inet (192\.)' | awk '{print $2}' | cut -d '/' -f 1)

# Log writing
log_data="$(date +'%Y-%m-%d %H:%M:%S')|$hostname|$ip_address"

# Inventory line ip extraction
lines=();
while read -r line; do
    part_after_space=$(echo "$line" | cut -d ' ' -f2-)
    lines+=("$part_after_space");
done < "inventory"

# SFTP file transfering
for ip in "${lines[@]}"; do
    echo "Connecting to $ip"
    # Download log file form node
    sftp -o StrictHostKeyChecking=no "$ip" << EOF
    get $logpath $temp_log
EOF
    # Append data log to file
    echo "$log_data" >> "$temp_log"
    # Upload log file to node
    sftp -o StrictHostKeyChecking=no "$ip" << EOF
    put $temp_log $logpath
EOF
    # Delete log file from remote node
    rm -rf $temp_log
done