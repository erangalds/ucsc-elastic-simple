#!/bin/bash

# Copying Files  from Data Directory to Configuration Directories
# Copying Elastic Search Files
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/elasticsearch/certs/ca/
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.key /etc/elasticsearch/certs/ca/
sudo cp /home/vagrant/data/elasticsearch/certs/elastic/elastic.crt /etc/elasticsearch/certs/elastic/
sudo cp /home/vagrant/data/elasticsearch/certs/elastic/elastic.key /etc/elasticsearch/certs/elastic/
sudo cp /home/vagrant/data/elasticsearch/elasticsearch.yml /etc/elasticsearch/

# Copying the Kibana Files
sudo cp /home/vagrant/data/kibana/certs/ca.crt /etc/kibana/certs/
sudo cp /home/vagrant/data/kibana/certs/ca.key /etc/kibana/certs/
sudo cp /home/vagrant/data/kibana/certs/elastic.crt /etc/kibana/certs/
sudo cp /home/vagrant/data/kibana/certs/elastic.key /etc/kibana/certs/
sudo cp /home/vagrant/data/kibana/kibana.yml /etc/kibana/
sudo cp /home/vagrant/data/kibana/node.options /etc/kibana/