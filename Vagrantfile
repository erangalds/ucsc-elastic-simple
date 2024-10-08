# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/ubuntu-desktop-2404-lts"
  # Setting the Hostname
  config.vm.hostname = "elk-single-node"
  config.vm.network "private_network", ip: "192.168.56.3"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.boot_timeout = 600
  # Configure the VM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "16384"
    vb.cpus = 6
  end
  # Invoking the Elastic Install Script
  config.vm.provision "shell", path: "scripts/install-elk.sh"
  # Copying the Configuration Files
  config.vm.provision "file", source: "data", destination: "$HOME/data"
  config.vm.provision "file", source: "scripts", destination: "$HOME/scripts"
  
  # Invoking the Copy Files and File Permission Change Scripts
  config.vm.provision "shell", path: "scripts/copy-files.sh"
  config.vm.provision "shell", path: "scripts/change-file-ownership.sh"  
end

