#!/bin/bash

sudo /usr/share/logstash/bin/logstash -f /home/vagrant/webapp/webapp-logstash.conf < webapp.csv
