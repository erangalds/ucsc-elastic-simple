#!/bin/bash

elastic_user_password=Ucsc@1234
echo -e $elastic_user_password | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -i -u elastic --url https://elk-single-node:9200
