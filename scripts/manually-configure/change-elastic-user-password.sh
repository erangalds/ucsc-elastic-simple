#!/bin/bash

elastic_user_password=Ucsc@1234
echo $elastic_user_password
echo -e "y\n$elastic_user_password\n$elastic_user_password" | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -i -u elastic --url https://elk-single-node:9200
echo "Password $elastic_user_password was updated"