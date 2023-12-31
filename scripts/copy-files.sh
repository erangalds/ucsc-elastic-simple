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

# Copying Certificate Authority Certificate to beats config folders
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/filebeat/certs/ca/ca.pem
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/metricbeat/certs/ca/ca.pem
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/auditbeat/certs/ca/ca.pem
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/packetbeat/certs/ca/ca.pem

# Copying Beats Config Files
sudo cp /home/vagrant/data/filebeat/filebeat.yml /etc/filebeat/
sudo cp /home/vagrant/data/metricbeat/metricbeat.yml /etc/metricbeat/
sudo cp /home/vagrant/data/auditbeat/auditbeat.yml /etc/auditbeat/
sudo cp /home/vagrant/data/packetbeat/packetbeat.yml /etc/packetbeat/

# Copying Certificate Authority Certificate to beats config folders
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /etc/logstash/certs/ca/ca.crt

# Copying Enterprise Search Files
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.crt /enterprise-search/certs/ca/
sudo cp /home/vagrant/data/elasticsearch/certs/ca/ca.key /enterprise-search/certs/ca/
sudo cp /home/vagrant/data/elasticsearch/certs/elastic/elastic.crt /enterprise-search/certs/elastic/
sudo cp /home/vagrant/data/elasticsearch/certs/elastic/elastic.key /enterprise-search/certs/elastic/
sudo cp /home/vagrant/data/enterprise-search/enterprise-search.yml /usr/share/enterprise-search/config/

sudo chown -R enterprise-search:enterprise-search /enterprise-search/
sudo chown -R enterprise-search:enterprise-search /usr/share/enterprise-search/

# Copying the Sample Data and Loading Scripts
cp -r /home/vagrant/data/webapp /home/vagrant/
cp -r /home/vagrant/data/web-logs /home/vagrant/
cp -r /home/vagrant/data/full-text-search /home/vagrant
cp -r /home/vagrant/data/elastic-search-lab /home/vagrant

sudo chown -R vagrant:vagrant .

# Setting the execution permission in the shell scripts
chmod u+x /home/vagrant/webapp/*.sh
chmod u+x /home/vagrant/web-logs/*.sh

chmod u+x /home/vagrant/scripts/manually-configure/*.sh

dos2unix /home/vagrant/scripts/*.sh
dos2unix /home/vagrant/scripts/manually-configure/*.sh
dos2unix /home/vagrant/webapp/*
dos2unix /home/vagrant/webapp/classification-model-test/*
dos2unix /home/vagrant/web-logs/*
dos2unix /home/vagrant/full-text-search/*
dos2unix /home/vagrant/elastic-search-lab/v1/search-tutorial/*
dos2unix /home/vagrant/elastic-search-lab/v2/search-tutorial/*
dos2unix /home/vagrant/elastic-search-lab/v3/search-tutorial/*
