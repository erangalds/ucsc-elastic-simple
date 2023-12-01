#!/bin/bash
printf "\n**Load.sh loads an index template for webapp logs into Elasticsearch**\n\n"

url=https://elk-single-node:9200
username=elastic
password=Ucsc@1234
# load index template
if sudo curl -f -k -XPUT  "$url/_index_template/webapp-classification-enabled-template" -u $username:$password -H 'Content-Type: application/json' -d "@webapp-classification-enabled-template.json"
then echo " - Loaded index template for web app"
else echo " Could not load index template"
exit
fi

# load ingest pipeline
if sudo curl -f -k -XPUT  "$url/_ingest/pipeline/webapp-classification-enabled-pipeline" -u $username:$password -H 'Content-Type: application/json' -d "@webapp-classification-enabled-pipeline.json"
then echo " - Loaded ingest pipeline for web app"
else echo " Could not load ingest pipeline for web app"
exit
fi

printf "\n*Loaded components successfully\n"
