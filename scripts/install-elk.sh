#!/bin/bash
# Installing required common software
sudo apt update
sudo apt install wget vim
# Importing the PGP Key of the Elastic Binaries
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
# Install Required Pluggins
sudo apt-get install apt-transport-https
# Adding the repo to the ubuntu repository list
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic8.x.list

sudo apt update
sudo apt install elasticsearch
sudo apt install kibana
sudo apt install logstash
sudo apt install filebeat
sudo apt install metricbeat

# Deleting Folders if exists
[ -d /etc/elasticsearch/certs/ca ] && rm -rf /etc/elasticsearch/certs/ca
[ -d /etc/elasticsearch/certs/elastic ] && rm -rf /etc/elasticsearch/certs/elastic
[ -d /etc/kibana/certs ] && rm -rf /etc/kibana/certs

# Creating Required Folders
sudo mkdir /etc/elasticsearch/certs/ca
sudo mkdir /etc/elasticsearch/certs/elastic
sudo mkdir /etc/kibana/certs
