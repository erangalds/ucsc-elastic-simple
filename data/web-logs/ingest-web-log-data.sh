#!/bin/bash
echo 'This script will read the data from the sample web.log file and ingest it into elasticsearch'

sudo /usr/share/logstash/bin/logstash -f /home/vagrant/web-logs/web-logs-logstash.conf < web.log
