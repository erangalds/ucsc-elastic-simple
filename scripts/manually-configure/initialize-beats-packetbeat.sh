#!/bin/bash

# Setting up Packetbeat
# Testing the Packetbeat config
sudo /usr/share/packetbeat/bin/packetbeat test config -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat
# Testing the Packetbeat connectivity to Elasticsearch 
sudo /usr/share/packetbeat/bin/packetbeat test output -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat
# Loading Packetbeat Sample Dashboards, creating packetbeat data stream and setting boostrapping index
sudo /usr/share/packetbeat/bin/packetbeat setup -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat

