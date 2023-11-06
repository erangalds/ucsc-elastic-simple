#!/bin/bash

# Setting up Auditbeat
# Testing the Auditbeat config
sudo /usr/share/auditbeat/bin/auditbeat test config -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat
# Testing the Auditbeat connectivity to Elasticsearch 
sudo /usr/share/auditbeat/bin/auditbeat test output -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat
# Loading Auditbeat Sample Dashboards, creating auditbeat data stream and setting boostrapping index
sudo /usr/share/auditbeat/bin/auditbeat setup -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat

