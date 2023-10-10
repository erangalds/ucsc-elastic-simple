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


