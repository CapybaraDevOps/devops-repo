#!/bin/bash

# Path constants
logfolderpath=/sftplogs
reportfolderpath=/home/vagrant/reports
logpath=$logfolderpath/sftp.log
cronjob_file="/home/vagrant/crontab_job.sh"
extlogpath=/sftplogs/sftp_ext.log
cronjob_python="/home/vagrant/reader.py"

# Log directory creation
sudo mkdir -p $logfolderpath
sudo mkdir -p $reportfolderpath

# Rights' change to prevent exceptions
sudo chown -R vagrant:root $logfolderpath
sudo chmod -R 770 $logfolderpath

sudo chown -R vagrant:root $reportfolderpath
sudo chmod -R 770 $reportfolderpath

# Log file creation
sudo touch $logpath

# Crontab creation
echo "Creation of cronjob on $cronjob_file"
(crontab -l ; echo "*/5 * * * * /bin/bash $cronjob_file") | crontab -
(crontab -l ; echo "*/6 * * * * /usr/bin/python3 $cronjob_python") | crontab -



