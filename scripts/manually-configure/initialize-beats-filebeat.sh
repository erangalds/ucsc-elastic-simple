#!/bin/bash

# Setting up Filebeat
# Testing the Filebeat config
sudo /usr/share/filebeat/bin/filebeat test config -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat
# Testing the Filebeat connectivity to Elasticsearch 
sudo /usr/share/filebeat/bin/filebeat test output -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat
# Loading Filebeat Sample Dashboards, creating filebeat data stream and setting boostrapping index
sudo /usr/share/filebeat/bin/filebeat setup -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

## Enablinb Filebeat Modules
sudo filebeat modules enable system
sudo filebeat modules enable linux
sudo filebeat modules enable elasticsearch
sudo filebeat modules enable kibana

# Copy Modles Config Files
sudo cp /home/vagrant/data/filebeat/module-configs/elasticsearch.yml /etc/filebeat/modules.d/
sudo cp /home/vagrant/data/filebeat/module-configs/kibana.yml /etc/filebeat/modules.d/
