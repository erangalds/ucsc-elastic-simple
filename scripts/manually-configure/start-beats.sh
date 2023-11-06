#!/bin/bash
# Reloading the config files
sudo systemctl daemon-reload

# Enabling Metricbeat
sudo systemctl enable metricbeat.service
sudo systemctl start metricbeat.service
sudo systemctl status metricbeat.service

# Enabling Filebeat
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
sudo systemctl status filebeat.service

# Enabling Packetbeat
sudo systemctl enable packetbeat.service
sudo systemctl start packetbeat.service
sudo systemctl status packetbeat.service

# Enabling Auditbeat
sudo systemctl enable auditbeat.service
sudo systemctl start auditbeat.service
sudo systemctl status auditbeat.service
