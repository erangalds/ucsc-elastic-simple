#!/bin/bash
# Reloading the config files
sudo systemctl daemon-reload
# Enabling Metricbeat Service for auto restart 
sudo systemctl enable metricbeat.service
# Starting Metricbeat Service
sudo systemctl start metricbeat.service
# Checking Metricbeat Service Status
sudo systemctl status metricbeat.service


# Enabling Filebeat Service for auto restart 
sudo systemctl enable filebeat.service
# Starting Filebeat Service
sudo systemctl start filebeat.service
# Checking Filebeat Service Status
sudo systemctl status filebeat.service