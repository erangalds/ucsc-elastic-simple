#!/bin/bash

bash /home/vagrant/scripts/manually-configure/setup-elastic-service-account-token.sh
bash /home/vagrant/scripts/manually-configure/start-elasticsearch-kibana-services.sh
bash /home/vagrant/scripts/manually-configure/change-elastic-user-password.sh