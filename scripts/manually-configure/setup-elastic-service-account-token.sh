#!/bin/bash

# Remove the current service token if a token exits
sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens delete elastic/kibana kibana_token
# Run the below command and copy the service token value text file
sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana kibana_token > /home/vagrant/elastic-service-token

sudo chown root:elasticsearch /etc/elasticsearch/service_tokens
sudo chmod 660 /etc/elasticsearch/service_tokens 

sudo chown vagrant:vagrant /home/vagrant/elastic-service-token

file_content=$(cat /home/vagrant/elastic-service-token)
token=$(echo file_content | awk '{print $4}')

sudo /usr/share/kibana/bin/kibana-keystore remove elasticsearch.serviceAccountToken
echo -e $token | sudo /usr/share/kibana/bin/kibana-keystore add elasticsearch.serviceAccountToken
