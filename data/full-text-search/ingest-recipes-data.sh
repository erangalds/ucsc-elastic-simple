#!/bin/bash

sudo /usr/share/logstash/bin/logstash -f /home/vagrant/full-text-search/logstash-recipes.conf < recipes.json
