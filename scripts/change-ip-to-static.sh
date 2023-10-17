#!/bin/bash

# The network interface that you want to set a static IP for
INTERFACE="eth0"

# The static IP that you want to set
IPADDR="172.31.26.52"

# The network mask
NETMASK="20"

# The gateway IP
GATEWAY="172.31.16.1"

# The DNS server IP
DNS="8.8.8.8"

# Copy the current config to vagrant home
sudo cp /etc/netplan/01-netcfg.yaml /home/vagrant/01-netcfg.yaml
# Write the configuration to the Netplan configuration file
sudo echo "network:" > /etc/netplan/01-netcfg.yaml
sudo echo "  version: 2" >> /etc/netplan/01-netcfg.yaml
sudo echo "  renderer: networkd" >> /etc/netplan/01-netcfg.yaml
sudo echo "  ethernets:" >> /etc/netplan/01-netcfg.yaml
sudo echo "    $INTERFACE:" >> /etc/netplan/01-netcfg.yaml
sudo echo "      dhcp4: no" >> /etc/netplan/01-netcfg.yaml
sudo echo "      addresses: [$IPADDR/$NETMASK]" >> /etc/netplan/01-netcfg.yaml
sudo echo "      gateway4: $GATEWAY" >> /etc/netplan/01-netcfg.yaml
sudo echo "      nameservers:" >> /etc/netplan/01-netcfg.yaml
sudo echo "        addresses: [$DNS]" >> /etc/netplan/01-netcfg.yaml

# Apply the changes
sudo netplan apply
