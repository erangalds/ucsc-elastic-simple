#!/bin/bash
# Below command will script will setup the elastic service account token for kibana
bash /home/vagrant/scripts/manually-configure/setup-elastic-service-account-token.sh
# Below script will start the elasticsearch and kibana service
bash /home/vagrant/scripts/manually-configure/start-elasticsearch-kibana-services.sh
# Below script will change the elastic built in user password to a predefined password
bash /home/vagrant/scripts/manually-configure/change-elastic-user-password.sh

# Restarting the Elastic Search Cluster and Kibana Service
bash /home/vagrant/scripts/manually-configure/restart-elastic-kibana-services.sh

# Waiting for 60 seconds
sleep 60
# Starting the Beats
bash /home/vagrant/scripts/manually-configure/start-beats.sh
