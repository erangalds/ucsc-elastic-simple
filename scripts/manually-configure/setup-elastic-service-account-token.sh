#!/bin/bash

# Remove the current service token if a token exits
echo "Removing the elastic service token if such a token exists"
sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens delete elastic/kibana kibana_token
echo "Finished removing the elastic service token for kibana"
# Run the below command and copy the service token value text file
echo "Generating a new elasic service token for kibana and saving it to a file under /home/vagrant/elastic-service-token"
sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana kibana_token > /home/vagrant/elastic-service-token
echo "Finished generating a new service token"

# We need to change the file permission of the service tokens as below. 
echo "Changing the elastic service token file permissions"
sudo chown root:elasticsearch /etc/elasticsearch/service_tokens
sudo chmod 660 /etc/elasticsearch/service_tokens 

sudo chown vagrant:vagrant /home/vagrant/elastic-service-token
echo "Finished changing the service token file permissions"

# Now we need to read the service token from the file and add that back to Kibana Key Store
echo "Reading the Service Token from the file"
file_content=$(cat /home/vagrant/elastic-service-token)
token=$(echo $file_content | awk '{print $4}')

echo "Service Token : $token"

# We need to remove previous service tokens if such exists
echo "Removing previous elastic service account tokens if such exists"
sudo /usr/share/kibana/bin/kibana-keystore remove elasticsearch.serviceAccountToken
echo "Adding the new service token"
echo -e $token | sudo /usr/share/kibana/bin/kibana-keystore add elasticsearch.serviceAccountToken
echo 
echo "Finished adding the new service token to kibana keystore"
