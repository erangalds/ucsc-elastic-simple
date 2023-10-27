#!/bin/bash

## Setting up Beats

## Setting up Metricbeat
## Testing the Metricbeat config
sudo /usr/share/metricbeat/bin/metricbeat test config -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat
## Testing the connectivity to Elasticsearch
sudo /usr/share/metricbeat/bin/metricbeat test output -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat
## Loading the sample dashboard, creating metricbeat data stream and setting boostraping index
sudo /usr/share/metricbeat/bin/metricbeat setup -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat
# Enabling Metricbeat Modules
sudo metricbeat modules enable system
sudo metricbeat modules enable linux
sudo metricbeat modules enabale elasticsearch
sudo metricbeat modules enable kibana

# Copy Module Config Files
sudo cp /home/vagrant/data/filebeat/module-configs/elasticsearch.yml /etc/filebeat/modules.d/
sudo cp /home/vagrant/data/filebeat/module-configs/kibana.yml /etc/filebeat/modules.d/

## Setting up Packetbeat
## Testing the Packetbeat config
sudo /usr/share/packetbeat/bin/packetbeat test config -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat
## Testing the connectivity to Elasticsearch
sudo /usr/share/packetbeat/bin/packetbeat test output -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat
## Loading the sample dashboard, creating metricbeat data stream and setting boostraping index
sudo /usr/share/packetbeat/bin/packetbeat setup -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat

## Setting up Filebeat
## Testing the Filebeat config
sudo /usr/share/filebeat/bin/filebeat test config -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat
## Testing the connectivity to Elasticsearch
sudo /usr/share/filebeat/bin/filebeat test output -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat
## Loading the sample dashboard, creating metricbeat data stream and setting boostraping index
sudo /usr/share/filebeat/bin/filebeat setup -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

# Enabling Filebeat Modules
sudo filebeat modules enabale elasticsearch
sudo filebeat modules enable kibana

# Copy Module Config Files
sudo cp /home/vagrant/data/filebeat/module-configs/elasticsearch.yml /etc/filebeat/modules.d/
sudo cp /home/vagrant/data/filebeat/module-configs/kibana.yml /etc/filebeat/modules.d/
