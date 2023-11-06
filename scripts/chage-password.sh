#!/bin/bash

## This command will use used to reset the password of the elastic user
sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -i -u elastic --url https://elk-single-node:9200