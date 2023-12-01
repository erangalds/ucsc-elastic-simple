#!/bin/bash
printf "\n**Load.sh loads an index for recipes into Elasticsearch**\n\n"

# load index template
url=https://elk-single-node:9200
username=elastic
password=Ucsc@1234

if curl -f -k -XPUT "$url/recipes" -u $username:$password -H 'Content-Type: application/json' -d "@recipe-index.json"
then echo " - Loaded index for recipes"
else echo " Could not load index"
exit
fi

printf "\n*Loaded components successfully\n"
