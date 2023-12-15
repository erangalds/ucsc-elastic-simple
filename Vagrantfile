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
  config.vm.network "public_network", bridge: "my-lab-external", ip: "192.168.1.51", netmask: "24"
  # VirtualBox Users Please use the below network configuration statement 
  #config.vm.network "private_network", ip: "172.31.52.67"
  #config.vm.network "public_network"
  # If you don't have enough RAM on your laptop / desktop you can set the VM RAM by below configuration setting
  # The default is 2GB for a VM. But you can change that as below
  config.vm.provider "hyperv" do |v|
    # Configuring the Memory to be 16GB 
    v.maxmemory = "16384"
    v.memory = "16384"
  end
  

  # Invoking the Elastic Install Script
  config.vm.provision "shell", path: "scripts/install-elk.sh"
  # Copying the Configuration Files
  config.vm.provision "file", source: "data", destination: "$HOME/data"
  config.vm.provision "file", source: "scripts", destination: "$HOME/scripts"
  
  # Invoking the Copy Files and File Permission Change Scripts
  config.vm.provision "shell", path: "scripts/copy-files.sh"
  config.vm.provision "shell", path: "scripts/change-file-ownership.sh"
  
  #config.vm.provision "shell", path: "scripts/change-ip-to-static.sh"
end

