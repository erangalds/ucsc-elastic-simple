#!/bin/bash

# Initializing the beats
echo "Initializing Auditbeat"
sudo bash initialize-beats-auditbeat.sh
echo "Initializing filebeat"
sudo bash initialize-beats-filebeat.sh
echo "Initializing metricbeat"
sudo bash initialize-beats-metricbeat.sh
echo "Initializing Packetbeat"
sudo bash initialize-beats-packetbeat.sh
# Reloading the config files
echo "Reloading the config files to systemd"
sudo systemctl daemon-reload

# Enabling Metricbeat
echo "Enabling and Starting metricbeat"
sudo systemctl enable metricbeat.service
sudo systemctl restart metricbeat.service
sudo systemctl status metricbeat.service

# Enabling Filebeat
echo "Enabling and Starting filebeat"
sudo systemctl enable filebeat.service
sudo systemctl restart filebeat.service
sudo systemctl status filebeat.service

# Enabling Packetbeat
echo "Enabling and Starting packetbeat"
sudo systemctl enable packetbeat.service
sudo systemctl restart packetbeat.service
sudo systemctl status packetbeat.service

# Enabling Auditbeat
echo "Enabling and Starting auditbeat"
sudo systemctl enable auditbeat.service
sudo systemctl restart auditbeat.service
sudo systemctl status auditbeat.service
