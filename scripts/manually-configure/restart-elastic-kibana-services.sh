#!/bin/bash

# We need to restart the elasticsearch and kibana service. 
sudo systemctl restart elasticsearch.service
# Sleeping for 60 seconds to give time for elasticsearch to restart properly
sleep 120
# Checking service status
elastic_service_status=$(sudo systemctl is-active elasticsearch.service)
echo "Elasticsearch Service Status: $elastic_service_status"

sudo systemctl restart kibana.service
# Sleeping for 120 seconds to give time for kibana to restart properly
kibana_service_status=$(sudo systemctl is-active kibana.service)
echo "Kibana Service Status: $kibana_service_status"

echo 
echo "Both Elasticsearch and Kibana Restarted"
