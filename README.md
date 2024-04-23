# Project Setup Using Vagrant

This guide covers the setup of multiple virtual machines (VMs) using Vagrant, configured for an Ubuntu environment.

## Prerequisites

- Vagrant installed on your machine.
- VirtualBox installed as the provider for Vagrant.
- An SSH client installed on your machine.

### SSH Key Setup

First, generate an SSH key pair in the `ssh_keys` folder if not already present:
```
mkdir -p ssh_keys
ssh-keygen -t rsa -b 4096 -f ssh_keys/vagrant_rsa -C "vagrant@local" -N '""'
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

use the following command to update your local SSH known hosts:
```
ssh-keyscan -H [IP] >> ~/.ssh/known_hosts
```
## SFTP Connection

For an SFTP connection, use:
```
sftp [IP]
```
## Cleaning Up

To destroy all managed machines, run:
```
vagrant destroy -f
```
