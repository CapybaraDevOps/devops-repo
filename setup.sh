#!/bin/bash

#################################### Rreconfig ####################################
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
# Create Group sftp and add user vagrant
sudo groupadd sftp
sudo usermod -aG sftp vagrant
# Restrict root login and add configuration for sftp group
cat <<EOF | sudo tee -a /etc/ssh/sshd_config > /dev/null
PermitRootLogin no
Match Group sftp
    PasswordAuthentication no
    #ChrootDirectory %h
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
EOF
sudo systemctl restart ssh
# Ensure if sftp is installed and started 
sudo apt update -y
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh

#################################### Rkhunter ####################################
# Ensure if rkhunter is installed
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y vsftpd rkhunter
#update configuration /etc/rkhunter.conf
sudo awk -i inplace 'BEGIN{FS=OFS="="} $1=="MIRRORS_MODE"{$2=0} $1=="UPDATE_MIRRORS"{$2=1} $1=="WEB_CMD"{$2=""} 1' /etc/rkhunter.conf 1>/dev/null

sudo rkhunter --update 1>/dev/null #update rootkit database
sudo rkhunter --propupd 1>/dev/null #apply configuration
# Run rkhunter once, in background, the output is in /var/log/rkhunter.log
sudo rkhunter -c --enable all --disable none --skip-keypress --rwo 1>/dev/null &
rm /tmp/vagrant-shell #self destruction of vagrant shell file since it considered as suspicious by rkhunter

#################################### Inventory ####################################
# Create invenroy file with IP of other VMs
NODE_INDEX=$1
NODE_COUNT=$2
IP_HOST=$3
VM_NAME=$4
for j in $(seq 1 $NODE_COUNT); do
	if [[ $j -ne $NODE_INDEX ]]; then
		node_ip="${IP_HOST}$((9 + j))"
		node_name="${VM_NAME}${j}"
		echo "$node_name $node_ip" | tee -a ~/inventory
        # add ip to known_host
        ssh-keyscan -H $node_ip >> ~/.ssh/known_hosts
	fi
done

#################################### Crontab ####################################
# Path constants
logpath=/var/log/sftp.log
cronjob_file="~/crontab_job.sh"
report_folder_path=~/reports
cronjob_python="~/reader.py"

# Log directory creation
mkdir -p $report_folder_path

# Log file creation
sudo touch $logpath

# Rights' change to prevent exceptions
sudo chown vagrant:root $logpath
sudo chmod 664 $logpath

# Crontab creation
(crontab -l ; echo "*/5 * * * * /bin/bash $cronjob_file") | crontab -
(crontab -l ; echo "*/6 * * * * /usr/bin/python3 $cronjob_python") | crontab -
