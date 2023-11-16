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

# Copying the Sample Data and Loading Scripts
cp -r /home/vagrant/data/webapp /home/vagrant/
cp -r /home/vagrant/data/web-logs /home/vagrant/
# Setting the execution permission in the shell scripts
chmod u+x /home/vagrant/webapp/*.sh
chmod u+x /home/vagrant/web-logs/*.sh

chmod u+x /home/vagrant/scripts/manually-configure/*.sh

