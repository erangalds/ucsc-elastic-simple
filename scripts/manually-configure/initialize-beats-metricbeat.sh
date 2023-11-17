#!/bin/bash

# Setting up Metricbeat
# Testing the Metricbeat config
sudo /usr/share/metricbeat/bin/metricbeat test config -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat
# Testing the Metricbeat connectivity to Elasticsearch 
sudo /usr/share/metricbeat/bin/metricbeat test output -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat
# Loading Metricbeat Sample Dashboards, creating metricbeat data stream and setting boostrapping index
sudo /usr/share/metricbeat/bin/metricbeat setup -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat

## Enablinb Metricbeat Modules
sudo metricbeat modules enable system
sudo metricbeat modules enable linux
sudo metricbeat modules enable elasticsearch
sudo metricbeat modules enable kibana

# Copy Module Config Files
sudo cp /home/vagrant/data/metricbeat/module-configs/elasticsearch.yml /etc/metricbeat/modules.d/
sudo cp /home/vagrant/data/metricbeat/module-configs/kibana.yml /etc/metricbeat/modules.d/
