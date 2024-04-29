# Project Setup Using Vagrant

This guide covers the setup of multiple virtual machines (VMs) using Vagrant, configured for an Ubuntu environment.

## Prerequisites

- Vagrant installed on your machine.
- VirtualBox installed as the provider for Vagrant.
- An SSH client installed on your machine.

## Configuring Line Endings in Text Editors

Properly setting the end-of-line sequence in your text editor ensures compatibility across different operating systems. Below are the steps for configuring Visual Studio Code and Notepad++ to use LF (Line Feed), which is commonly used in Unix-based systems like Linux and macOS.

### Visual Studio Code Configuration

1. **Open Visual Studio Code.**
2. **Access the Command Palette:**
   - Windows: Press `Ctrl+Shift+P`
   - macOS: Press `Cmd+Shift+P`
3. **Type `Change End of Line Sequence` and select the option from the list.**
4. **Choose `LF` from the list to set the line ending for the current file to Unix format.**

### Notepad++ Configuration

1. **Open Notepad++.**
2. **Navigate to the Settings:**
   - Go to the `Settings` menu and select `Preferences.`
3. **Adjust New Document Settings:**
   - In the Preferences window, select the `New Document` tab.
   - Under the `Format` section, choose `Unix (LF)` as the default format for new files.
4. **Click `Close` to apply the changes.**

# Startup Vagrant project

### SSH Key Setup

First, generate an SSH key pair in the `ssh_keys` folder if not already present:
```
mkdir -p ssh_keys
ssh-keygen -t rsa -b 4096 -f ssh_keys/vagrant_rsa -C "vagrant@local"
```
## Configuration

Edit the Vagrant configuration by modifying the `NODE_COUNT` variable in the Vagrantfile to change the number of VMs created:
```
NODE_COUNT = 2  # Default is 2 VMs
```
## Starting the VMs

To initiate and configure the VMs, use the following command:
```
vagrant up
```
## Managing VMs

Check the status of the VMs:
```
vagrant status
```
## Connecting to VMs

There are two ways to connect to the VMs:

1. **Vagrant SSH** - Connect using Vagrant's built-in SSH command:
```
vagrant ssh [name_of_vm]
```
2. **SSH with IP** - Directly connect using SSH:
```
ssh -i ./ssh_keys/vagrant_rsa vagrant@[IP]
```
## Troubleshooting SSH Issues

If you encounter an SSH warning related to host identification:
```
If you faced with some issue while connect via SSH like:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
``` 

use the following command to update your local SSH known hosts, or delete lines with IP manualy in file ~/.ssh/known_hosts
```
ssh-keygen -R [IP]
```
## SFTP Connection

For an SFTP connection, use:
```
sftp [IP]
```
## rkhunter execution

For a rkhunter execution:
```
sudo rkhunter -c --enable all --disable none --skip-keypress 1>/dev/null &
```
runs in background, output supressed
audit details logged in /var/log/rkhunter.log (readable by root only due to security purposes)

## Firewall configuration details
```
Allow SSH traffic on port 22.
Allow SFTP traffic from the subnet 192.168.100.1/24.
Deny all other incoming traffic.
Allow all outgoing traffic.

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22                         ALLOW       192.168.100.0/24
22/tcp (v6)                ALLOW       Anywhere (v6)
```

## Cleaning Up

To destroy all managed machines, run:
```
vagrant destroy -f
```
