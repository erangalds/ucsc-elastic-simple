#!/bin/bash
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

sudo systemctl enable kibana.service
sudo systemctl start kibana.service

