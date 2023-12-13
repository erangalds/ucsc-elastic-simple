import json
from pprint import pprint
import os

from dotenv import load_dotenv
from elasticsearch import Elasticsearch
from sentence_transformers import SentenceTransformer

load_dotenv()


class Search:
    def __init__(self):
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.es = Elasticsearch( "https://elk-single-node:9200", ca_certs="/home/vagrant/data/elasticsearch/certs/ca/ca.crt", basic_auth=('elastic','Ucsc@1234'))
        client_info = self.es.info()
        print('Connected to Elasticsearch!')
        pprint(client_info.body)

    def create_index(self):
        self.es.indices.delete(index='my_documents-v2', ignore_unavailable=True)
        self.es.indices.create(index='my_documents-v2', mappings={
            'properties': {
                'embedding': {
                    'type': 'dense_vector',
                }
            }
        })

    def get_embedding(self, text):
        return self.model.encode(text)

    def insert_document(self, document):
        return self.es.index(index='my_documents-v2', document={
            **document,
            'embedding': self.get_embedding(document['summary']),
        })

    def insert_documents(self, documents):
        operations = []
        for document in documents:
            operations.append({'index': {'_index': 'my_documents-v2'}})
            operations.append({
                **document,
                'embedding': self.get_embedding(document['summary']),
            })
        return self.es.bulk(operations=operations)

    def reindex(self):
        self.create_index()
        with open('data.json', 'rt') as f:
            documents = json.loads(f.read())
        return self.insert_documents(documents)

    def search(self, **query_args):
        return self.es.search(index='my_documents-v2', **query_args)

    def retrieve_document(self, id):
        return self.es.get(index='my_documents-v2', id=id)
