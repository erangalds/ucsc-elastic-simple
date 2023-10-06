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
  config.vm.network "public_network", bridge: "Default Switch", ip: "172.31.52.67", netmask: "20"
  #config.vm.memory = 1024

  # Invoking the Elastic Install Script
  config.vm.provision "shell", path: "scripts/install-elk.sh"
  # Copying the Configuration Files
  config.vm.provision "file", source: "data", destination: "$HOME/data"

  # Invoking the Copy Files and File Permission Change Scripts
  config.vm.provision "shell", path: "scripts/copy-files.sh"
  config.vm.provision "shell", path: "scripts/change-file-ownership.sh"
  
end
