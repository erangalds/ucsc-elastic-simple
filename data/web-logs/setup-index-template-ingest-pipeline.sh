#!/bin/bash
printf "\n** We are going to load an index template and an ingest pipeline into Elasticsearch**\n\n"

url=https://elk-single-node:9200
username=elastic
password=Ucsc@1234
# load index template
if sudo curl -f -k -XPUT  "$url/_index_template/web-logs" -u $username:$password -H 'Content-Type: application/json' -d "@web-logs-template.json" 
then echo " - Loaded index template for web logs"
else echo " Could not load index template"
exit
fi

# load ingest pipeline
if sudo curl -f -k -XPUT "$url/_ingest/pipeline/web-logs" -u $username:$password -H 'Content-Type: application/json' -d "@web-logs-pipeline.json"
then echo " - Loaded ingest pipeline for Apache"
else echo " Could not load ingest pipeline for Apache"
exit
fi

printf "\n*Loaded components successfully\n"
