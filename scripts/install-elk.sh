#!/bin/bash
# Installing required common software
sudo apt update
sudo apt install wget -y
sudo apt install vim -y
sudo apt install dos2unix -y
sudo apt install python3-pip -y
sudo apt install python3.12-venv -y
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
sudo apt install auditbeat
sudo apt install packetbeat
sudo apt install enterprise-search
sudo apt install openjdk-21-jre-headless
sudo apt install libjemalloc2
#sudo apt install heartbeat

# Deleting Folders if exists
[ -d /etc/elasticsearch/certs/ca ] && rm -rf /etc/elasticsearch/certs/ca
[ -d /etc/elasticsearch/certs/elastic ] && rm -rf /etc/elasticsearch/certs/elastic
[ -d /etc/kibana/certs ] && rm -rf /etc/kibana/certs
[ -d /etc/filebeat/certs/ca ] && rm -rf /etc/filebeat/certs/ca
[ -d /etc/metricbeat/certs/ca ] && rm -rf /etc/metricbeat/certs/ca
[ -d /etc/auditbeat/certs/ca ] && rm -rf /etc/auditbeat/certs/ca
[ -d /etc/packetbeat/certs/ca ] && rm -rf /etc/packetbeat/certs/ca
[ -d /enterprise-search ] && rm -rf /enterprise-search

# Creating Required Folders
sudo mkdir -p /etc/elasticsearch/certs/ca
sudo mkdir -p /etc/elasticsearch/certs/elastic
sudo mkdir -p /etc/kibana/certs
sudo mkdir -p /etc/filebeat/certs/ca
sudo mkdir -p /etc/metricbeat/certs/ca
sudo mkdir -p /etc/auditbeat/certs/ca
sudo mkdir -p /etc/packetbeat/certs/ca
sudo mkdir -p /etc/logstash/certs/ca
sudo mkdir -p /enterprise-search/certs/ca
sudo mkdir -p /enterprise-search/certs/elastic

