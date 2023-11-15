# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "generic/ubuntu2304"
  #config.vm.provider = "hyperv"
  config.vm.hostname = "elk-single-node"
  # Hyper-V Users Plesae use the below network configuration statement
  config.vm.network "public_network", bridge: "Default Switch", ip: "172.31.52.67", netmask: "20"
  # VirtualBox Users Please use the below network configuration statement 
  #config.vm.network "private_network", ip: "172.31.52.67"
  # If you don't have enough RAM on your laptop / desktop you can set the VM RAM by below configuration setting
  # The default is 2GB for a VM. But you can change that as below
  #config.vm.memory = 1024

  # Invoking the Elastic Install Script
  config.vm.provision "shell", path: "scripts/install-elk.sh"
  # Copying the Configuration Files
  config.vm.provision "file", source: "data", destination: "$HOME/data"
  config.vm.provision "file", source: "scripts", destination: "$HOME/scripts"
  #config.vm.provision "file", source: "scripts/change-ip-to-static.sh", destination: "$HOME/scripts/change-ip-to-static.sh"
  #config.vm.provision "file", source: "scripts/start-services.sh", destination: "$HOME/scripts/start-services.sh"

  # Invoking the Copy Files and File Permission Change Scripts
  config.vm.provision "shell", path: "scripts/copy-files.sh"
  config.vm.provision "shell", path: "scripts/change-file-ownership.sh"
  

  # Below configuration is not needed for VirtualBoX Hypervisor. Its needed only if you are using Hyper-V as the Hypervisor
  # Changing the IP to a static IP
  # If Hyper-V Default Swtich type is used, then its better to run this command manually each time you start the VM
  # The Hyper-V Default Swtich is a NAT switch
  # The reason for that is in Hyper-V the network settings for IP ranges changes at each computer reboot. 
  # Therefore its a pain to maintain a lab like this on a Default Switch. 
  # Its better to create a new Hyper-V network switch and set it to bridge network mode
  # When we do that the Network Setting for IP ranges will default to the network segment of your home WiFi network segment
  # This will not change at each computer reboot. 
  #config.vm.provision "shell", path: "scripts/change-ip-to-static.sh"
end

