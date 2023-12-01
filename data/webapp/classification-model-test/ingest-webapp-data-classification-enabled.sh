#!/bin/bash

sudo /usr/share/logstash/bin/logstash -f /home/vagrant/webapp/webapp-logstash-classification-enabled.conf < webapp-new-data.csv
sudo /usr/share/logstash/bin/logstash -f /home/vagrant/webapp/webapp-logstash-classification-enabled.conf < webapp-password-spraying-attemps.csv
