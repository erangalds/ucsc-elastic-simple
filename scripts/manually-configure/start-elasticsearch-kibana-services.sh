#!/bin/bash
# Starting the elasticsearch service
echo "Starting Elasticsearch Service"
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl restart elasticsearch.service
# waiting for 60 seconds for elasticsearch service to start properly
sleep 60

# Starting the kibana service
echo "Starting the Kibana Service"
sudo systemctl enable kibana.service
sudo systemctl restart kibana.service
# waiting for 30 seconds
sleep 30

# Getting the service status
elastic_service_status=$(sudo systemctl is-active elasticsearch.service)
echo "Elasticsearch Servic Status : $elastic_service_status"

kibana_service_status=$(sudo systemctl is-active kibana.service)
echo "Kibana Service Status : $kibana_service_status"

