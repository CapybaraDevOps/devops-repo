
######################## Variables ########################
NODE_COUNT = 3							# Amount of VMs
BOX_IMAGE = "ubuntu/jammy64"			# Ubuntu 22.04
VM_NAME = "node"						# VM name
IP = "192.168.100."						# Private subnet
KEY_PATH = "./ssh_keys/vagrant_rsa"		# PATH to SSH key
KEY_PATH_DEST = "~/.ssh/vagrant_rsa"	# Destination to SSH PATH
RAM = "2048"							# RAM
CPUS = 1								# CPU
######################## Variables ########################

Vagrant.configure("2") do |config|
	# Templete for VMs, count configured in var NODE_COUNT
	(1..NODE_COUNT).each do |i|
		######## Local vars ########
		hostname = "#{VM_NAME}#{i}"
		private_ip = "#{IP}#{9 + i}"
		######## Local vars ########
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
			# Copy scrips for crontab
			vb.vm.provision "file", source: "crontab_job.sh", destination: "~/"
			# run script
			vb.vm.provision "shell", path: "setup.sh", privileged: false, args: [i, NODE_COUNT, IP, VM_NAME]
			vb.vm.provision "file", source: "reader.py", destination: "~/reader.py"
			vb.vm.provision "file", source: "crontab_job.sh", destination: "~/crontab_job.sh"
			vb.vm.provision "shell", path: "create_dirs.sh", privileged: false
		end
	end
end
