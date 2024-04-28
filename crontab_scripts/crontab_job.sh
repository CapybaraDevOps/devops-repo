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

# Define time of pause and sleep
time_pause=$(hostname | grep -o '[0-9]\+')
sleep "$time_pause"
# SFTP file transfering
for ip in "${lines[@]}"; do
    echo "Connecting to $ip"
    ############ Donwload ############
    retries=3
    while [ $retries -gt 0 ]; do
        # Attempt to download log file form node
        sftp -o StrictHostKeyChecking=no "$ip" << EOF
        get $logpath $temp_log
EOF
        # Check if the SFTP command was successful
        if [ $? -eq 0 ]; then
            echo "Download successful"
            break
        else
            echo "Download failed, attempting retry..."
            ((retries--))
        fi
    done

    if [ $retries -eq 0 ]; then
        echo "Failed to download file after several attempts."
        continue  # Skip to next IP
    fi
    # Append data log to file
    echo "$log_data" >> "$temp_log"
    # Upload log file to node
    sftp -o StrictHostKeyChecking=no "$ip" << EOF
    put $temp_log $logpath
EOF
    # Delete log file from remote node
    rm -rf $temp_log
done