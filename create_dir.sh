#!/bin/bash

# Path constants
logfolderpath=/sftplogs
logpath=$logfolderpath/sftp.log
cronjob_file="/home/vagrant/crontab_job.sh"

# Log directory creation
sudo mkdir -p $logfolderpath

# Rights' change to prevent exceptions
sudo chown -R vagrant:root $logfolderpath
sudo chmod -R 770 $logfolderpath

# Log file creation
sudo touch $logpath

# Crontab creation
echo "Creation of cronjob on $cronjob_file"
echo "*/5 * * * * /bin/bash $cronjob_file" | crontab -