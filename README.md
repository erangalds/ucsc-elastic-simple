# Setting up a Single Node Elasticsearrch Cluster

## Instructions to Setup a Virtualization Platform
The virtual elasticsearch platform can be installed on either Oracle VirtualBox virtualization platform or Microsoft Hyper-V platform

The installation and most of the configuration is fully automated except for setting up the Service Token using a infrastructure as a code platform called Vagrant. Vagrant is a software from HarshiCorp Software foundation. We have to download and install the latest Vagrant software into your desktop. Vagrant is supported on both Windows and Linux. 

Once Vagrant and the Virtualization Hypervisor Platform is ready, we have to just run the below command. 

Microsoft Hyper-V
Start the Windows Command Prompt or PowerShell Terminal or New Windows Terminal in Administrator mode (Elivated Mode)

windows command prompt > vagrant up --provider hyperv

Oracle VirtualBox
windows command prompt > vagrant up

Once the installation is done. We have to look at the installation log and get the auto generated password for the elastic user. Keep that copied safely. 

## Setting a Static IP in a Hyper-V Virtual Machine
As of the date, Vagrant is unable to setup a static IP address in the virtual machine. 
Below configuration statements doesn't work. 

config.vm.network "public_network", bridge "Default Switch", ip "192.168.1.10"
config.vm.network "private_network", ip "192.168.1.10" 

Therefore, we have to perform a workaround to get a static ip setup for the virtual machines. 

First we have to comment find the Network Settings for a given Hyper-V virtual switch. The only way to find the network details is by powering on a virtual machine on dhcp mode and then finding the details of the given IP from the network switch. 

Below command will give us the default network gateway 

linux command prompt> sudo ip route | grep default 

After that we need to find out the netmask and an example ip. The best way to get that details is by looking at the current DHCP IP settings as below. 

linux command prompt> sudo ip addr

Looking at them we can decide a suitable IP address, with netmask and the default gateway to be used in the change-ip-to-static.sh script. 

## Instructions to Configure the Service Tokens in Elasticsearch
We need to create a service token to allow kibana to connect to elasticsearch cluster securely. 

linux command prompt > cd /usr/share/elasticsearch/bin/
linux command prompt > sudo ./elasticsearch-service-tokens create elastic/kibana kibana_token

Save the token to a text file for future use. 

A new file should be created in /etc/elasticsearch directory called service_tokens. 
We need to change the file ownership and permissions for the file

linux command prompt > sudo chown root:elasticsearch /etc/elasticsearch/service_tokens
linux command prompt > sudo chmod 660 /etc/elasticsearch/service_tokens 

Now we need to add the generated service_token to Kibana KeyStore

linux command prompt > cd /usr/share/kibana/bin

linux command prompt > sudo ./kibana-keystore add elasticsearch.serviceAccountToken


Now we can start the services. 

linux command prompt > sudo systemctl daemon-reload
linux command prompt > sudo systemctl enable elasticsearch.service
linux command prompt > sudo systemctl enable kibana.service
linux command prompt > sudo systemctl start elasticsearch.service
linux command prompt > sudo systemctl start elasticsearch.service
linux command prompt > sudo systemctl status elasticsearch.service
linux command prompt > sudo systemctl status kibana.service

Both the services should be working properly. The log files for both the services are in the /var/log/elasticsearch/ and /var/log/kibana/ paths respectively. If you have any errors you can look at the error and try to fix the error. 

Get the ip address of the virtual machine with the below command. 

linux command prompt > ip addr

Then in your windows browser type the url as below. 

https://<ip address>:5601

We should get a warning from the browser, but we can click continue / proceed. That should lead us to the kibana page. The user name is elastic and the password is the auto generated password. 

NOTE: 
If the Kibana Service doesn't come up and no log is written to the /var/log/kibana/kibana.log file. Then we have to un-comment one option at the node.options file. 

The below line needs to be commented

--unhandled-rejections=warn 

After that we can start the services

### Setting up Metricbeat in Elasticsearch Server/
We need to make a directory under the /etc/metricbeat to hold the certificate of the certificate authority. 

linux command prompt> sudo mkdir -p /etc/metricbeat/certs/ca 

Then we need to copy the ca.crt certificate from the elasticsearch certs directory and place it here. 

linux command prompt> sudo cp /etc/elasticsearch/certs/ca/ca.crt /etc/metricbeat/certs/ca/ca.crt

Then we need to rename the ca.crt file to ca.pem file as the beats configuration needs the certificate in .pem format

linux command prompt> sudo mv /etc/metricbeat/certs/ca/ca.crt /etc/metricbeat/certs/ca/ca.pem

We need to edit the metricbeat.yml file sitting in /etc/metricbeat/ directory. 

section:
metricbeat.config.modules:
    reload.enabled: true

Dashboards
setup.dashboards.enabled: true

Kibana
setup.kibana:
    host: "https://elk-single-node:5601
    ssl.certificate_authorities: ["/etc/metricbeat/certs/ca/ca.pem"]

Elasticsearch
output.elasticsearch:
    hosts: ["elk-single-node:9200"]
    ssl.certificate_authorities: ["/etc/metricbeat/certs/ca/ca.pem"]
    protocol: "https"
    #api_key:"${ES_METRICBEAT_API_KEY}"
    username: "elastic"
    password: "changeme"

We can then test the config and connection to the elasticsearch cluster
linux command prompt> sudo /usr/share/metricbeat/bin/metricbeat test config -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat

linux command prompt> sudo /usr/share/metricbeat/bin/metricbeat test output -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat

linux command prompt> sudo /usr/share/metricbeat/bin/metricbeat setup -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat

This should setup the sample plug and play dashboards into kibana for metricbeat. 

Then we need to create a role with the required privileges and  create a new user and assign that role to the user. 

role: metricbeat-user-role --> 
Cluster Privileges: monitor, read_ilm
Index Privileges
    indices: metricbeat-*
    privileges: create_doc,create_index

User: metricbeat-user
privileges: roles
    metricbeat-user, editor

Generating an API KEY for the user
POST /_security/api_key/grant
{
    "grant_type": "password",
    "username": "metricbeat-user",
    "password": "UCSC@1234",
    "api_key": {
        "name":"metricbeat-user"
    }
}

Get the generated API Key Details Copied We need the ID:API_KEY

id:api_key

Creating a KEY int the KEYSTORE where the information will be auto loaded as an environment variable. 

linux command prompt> sudo /usr/share/metricbeat/bin/metricbeat keystore add ES_METRICBEAT_API_KEY -c /etc/metricbeat/metricbeat.yml --path.home /usr/share/metricbeat --path.data /var/lib/metricbeat


### Setting up Packetbeat in Elasticsearch Server/
We need to make a directory under the /etc/packetbeat to hold the certificate of the certificate authority. 

linux command prompt> sudo mkdir -p /etc/packetbeat/certs/ca 

Then we need to copy the ca.crt certificate from the elasticsearch certs directory and place it here. 

linux command prompt> sudo cp /etc/elasticsearch/certs/ca/ca.crt /etc/packetbeat/certs/ca/ca.crt

Then we need to rename the ca.crt file to ca.pem file as the beats configuration needs the certificate in .pem format

linux command prompt> sudo mv /etc/packetbeat/certs/ca/ca.crt /etc/packetbeat/certs/ca/ca.pem

We need to edit the packetbeat.yml file sitting in /etc/packetbeat/ directory. 

section:
packetbeat.config.modules:
    reload.enabled: true

Dashboards
setup.dashboards.enabled: true

Kibana
setup.kibana:
    host: "https://elk-single-node:5601
    ssl.certificate_authorities: ["/etc/packetbeat/certs/ca/ca.pem"]

Elasticsearch
output.elasticsearch:
    hosts: ["elk-single-node:9200"]
    ssl.certificate_authorities: ["/etc/packetbeat/certs/ca/ca.pem"]
    protocol: "https"
    #api_key:"${ES_PACKETBEAT_API_KEY}"
    username: "elastic"
    password: "changeme"

We can then test the config and connection to the elasticsearch cluster
linux command prompt> sudo /usr/share/packetbeat/bin/packetbeat test config -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat

linux command prompt> sudo /usr/share/packetbeat/bin/packetbeat test output -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat

linux command prompt> sudo /usr/share/packetbeat/bin/packetbeat setup -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat

This should setup the sample plug and play dashboards into kibana for packetbeat. 

Then we need to create a role with the required privileges and  create a new user and assign that role to the user. 

role: packetbeat-user-role --> 
Cluster Privileges: monitor, read_ilm
Index Privileges
    indices: packetbeat-*
    privileges: create_doc,create_index

User: packetbeat-user
privileges: roles
    packetbeat-user, editor

Generating an API KEY for the user
POST /_security/api_key/grant
{
    "grant_type": "password",
    "username": "packetbeat-user",
    "password": "UCSC@1234",
    "api_key": {
        "name":"packetbeat-user"
    }
}

Get the generated API Key Details Copied We need the ID:API_KEY

id:api_key

Creating a KEY int the KEYSTORE where the information will be auto loaded as an environment variable. 

linux command prompt> sudo /usr/share/packetbeat/bin/packetbeat keystore add ES_PACKETBEAT_API_KEY -c /etc/packetbeat/packetbeat.yml --path.home /usr/share/packetbeat --path.data /var/lib/packetbeat


### Setting up Filebeat in Elasticsearch Server/
We need to make a directory under the /etc/filebeat to hold the certificate of the certificate authority. 

linux command prompt> sudo mkdir -p /etc/filebeat/certs/ca 

Then we need to copy the ca.crt certificate from the elasticsearch certs directory and place it here. 

linux command prompt> sudo cp /etc/elasticsearch/certs/ca/ca.crt /etc/filebeat/certs/ca/ca.crt

Then we need to rename the ca.crt file to ca.pem file as the beats configuration needs the certificate in .pem format

linux command prompt> sudo mv /etc/filebeat/certs/ca/ca.crt /etc/filebeat/certs/ca/ca.pem

We need to edit the filebeat.yml file sitting in /etc/filebeat/ directory. 

section:
filebeat.config.modules:
    reload.enabled: true

Dashboards
setup.dashboards.enabled: true

Kibana
setup.kibana:
    host: "https://elk-single-node:5601
    ssl.certificate_authorities: ["/etc/filebeat/certs/ca/ca.pem"]

Elasticsearch
output.elasticsearch:
    hosts: ["elk-single-node:9200"]
    ssl.certificate_authorities: ["/etc/filecbeat/certs/ca/ca.pem"]
    protocol: "https"
    #api_key:"${ES_FILEBEAT_API_KEY}"
    username: "elastic"
    password: "changeme"

We can then test the config and connection to the elasticsearch cluster
linux command prompt> sudo /usr/share/filebeat/bin/filebeat test config -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

linux command prompt> sudo /usr/share/filebeat/bin/filebeat test output -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

linux command prompt> sudo /usr/share/filebeat/bin/filebeat setup -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

This should setup the sample plug and play dashboards into kibana for filebeat. 

Then we need to create a role with the required privileges and  create a new user and assign that role to the user. 

role: filebeat-user-role --> 
Cluster Privileges: monitor, read_ilm
Index Privileges
    indices: filebeat-*
    privileges: create_doc,create_index

User: filebeat-user
privileges: roles
    filebeat-user, editor

Generating an API KEY for the user
POST /_security/api_key/grant
{
    "grant_type": "password",
    "username": "filebeat-user",
    "password": "UCSC@1234",
    "api_key": {
        "name":"filebeat-user"
    }
}

Get the generated API Key Details Copied We need the ID:API_KEY

id:api_key

Creating a KEY int the KEYSTORE where the information will be auto loaded as an environment variable. 

linux command prompt> sudo /usr/share/filebeat/bin/filebeat keystore add ES_PACKETBEAT_API_KEY -c /etc/filebeat/filebeat.yml --path.home /usr/share/filebeat --path.data /var/lib/filebeat

### Setting up Auditbeat in Elasticsearch Server/
We need to make a directory under the /etc/auditbeat to hold the certificate of the certificate authority. 

linux command prompt> sudo mkdir -p /etc/auditbeat/certs/ca 

Then we need to copy the ca.crt certificate from the elasticsearch certs directory and place it here. 

linux command prompt> sudo cp /etc/elasticsearch/certs/ca/ca.crt /etc/auditbeat/certs/ca/ca.crt

Then we need to rename the ca.crt file to ca.pem file as the beats configuration needs the certificate in .pem format

linux command prompt> sudo mv /etc/auditbeat/certs/ca/ca.crt /etc/auditbeat/certs/ca/ca.pem

We need to edit the filebeat.yml file sitting in /etc/auditbeat/ directory. 

section:
auditbeat.config.modules:
    reload.enabled: true

Dashboards
setup.dashboards.enabled: true

Kibana
setup.kibana:
    host: "https://elk-single-node:5601
    ssl.certificate_authorities: ["/etc/auditbeat/certs/ca/ca.pem"]

Elasticsearch
output.elasticsearch:
    hosts: ["elk-single-node:9200"]
    ssl.certificate_authorities: ["/etc/auditbeat/certs/ca/ca.pem"]
    protocol: "https"
    #api_key:"${ES_AUDITBEAT_API_KEY}"
    username: "elastic"
    password: "changeme"

We can then test the config and connection to the elasticsearch cluster
linux command prompt> sudo /usr/share/auditbeat/bin/auditbeat test config -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat

linux command prompt> sudo /usr/share/auditbeat/bin/auditbeat test output -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat

linux command prompt> sudo /usr/share/auditbeat/bin/auditbeat setup -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat

This should setup the sample plug and play dashboards into kibana for auditbeat. 

Then we need to create a role with the required privileges and  create a new user and assign that role to the user. 

role: auditbeat-user-role --> 
Cluster Privileges: monitor, read_ilm
Index Privileges
    indices: auditbeat-*
    privileges: create_doc,create_index

User: auditbeat-user
privileges: roles
    auditbeat-user, editor

Generating an API KEY for the user
POST /_security/api_key/grant
{
    "grant_type": "password",
    "username": "auditbeat-user",
    "password": "UCSC@1234",
    "api_key": {
        "name":"auditbeat-user"
    }
}

Get the generated API Key Details Copied We need the ID:API_KEY

id:api_key

Creating a KEY int the KEYSTORE where the information will be auto loaded as an environment variable. 

linux command prompt> sudo /usr/share/auditbeat/bin/auditbeat keystore add ES_AUDITBEAT_API_KEY -c /etc/auditbeat/auditbeat.yml --path.home /usr/share/auditbeat --path.data /var/lib/auditbeat





