#!/bin/bash
sudo systemctl daemon-reload
# Enabling Elasticsearch Service for auto restart 
sudo systemctl enable elasticsearch.service
# Starting Elasticsearch Service
sudo systemctl start elasticsearch.service
# Checking elasticsearch Service Status
sudo systemctl status elasticsearch.service

# Enabling Kibana Service for auto restart
sudo systemctl enable kibana.service
# Starting Kibana Service
sudo systemctl start kibana.service
# Checking Kibana Service Status
sudo systemctl status kibana.service

