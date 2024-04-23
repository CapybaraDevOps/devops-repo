########################Variables########################
NODE_COUNT = 2							# Amount of VMs
BOX_IMAGE = "ubuntu/jammy64"			# Ubuntu 22.04
VM_NAME = "node"						# VM name
IP = "192.168.100."						# Private subnet
KEY_PATH = "./ssh_keys/vagrant_rsa"		# PATH to SSH key
KEY_PATH_DEST = "~/.ssh/vagrant_rsa"	# Destination to SSH PATH
RAM = "2048"							# RAM
CPUS = 1								# CPU
########################Variables########################

Vagrant.configure("2") do |config|
	# Templete for VMs, count configured in var NODE_COUNT
	(1..NODE_COUNT).each do |i|
		# Local vars
		hostname = "#{VM_NAME}#{i}"
		private_ip = "#{IP}#{9 + i}"
		
		config.vm.define hostname do |vb|
			
			# Pre configuration
			vb.vm.box 		= BOX_IMAGE
			vb.vm.hostname 	= hostname
			
			# Disable default folder syncing
  			vb.vm.synced_folder ".", "/vagrant", disabled: true
			
			# Network configuration
			vb.vm.network "private_network", ip: private_ip
			
			# VirtualBox provider configuration
			vb.vm.provider "virtualbox" do |virtualbox|
				virtualbox.name 	= hostname
				virtualbox.gui 		= false
				virtualbox.memory 	= RAM
				virtualbox.cpus 	= CPUS
			end
			
			# Copy ssh_keys
			vb.vm.provision "file", source: KEY_PATH, destination: KEY_PATH_DEST
			vb.vm.provision "file", source: "#{KEY_PATH}.pub", destination: "#{KEY_PATH_DEST}.pub"

			# run script
			vb.vm.provision "shell", path: "setup.sh", privileged: false
		end
	end
end