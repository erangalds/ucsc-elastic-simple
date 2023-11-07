# Indexing and Searching in Elasticsearch

## What is an elasticsearch index and how does it work? 

An ***elasticsearch index*** is the place or the location to store and organize the data which we load to elasticsearch. The equivalent to an elasticsearch index in the relational database world is a database which contains multiple tables. There is a small difference in the two, where in a relational database, a single table is designed to store a single type of data. Where as an elasticsearch index can store data but all of them don't need to be the same, but they generally have to be related to one another (departments / employees). 

The data records which we load / store in an elasticsearch index is called a ***document***. Documents are the things we search for after indexing / loading. A document can be more than just text and it could be any structured JSON object. Each document which gets stored in elasticsearch index will have a unique ID, which is unique to the index which its being loaded into. Additionally each document will have a type as well. 

The indices in elasticsearch are actually ***inverted indices**. 

### What is an ***inverted index***

Let's take two documents (eg. example data records) which we want to store in an elasticsearch index to search for. 

![Inverted Index in Elasticsearch](/indexing-searching/images/inverted-index.png)

As we can see in the above diagram, the documents when they get indexed into the index, elasticsearch analyzes the document, and tokenizers the document then keeps the total count of the tokens (which is equal to a word in this example). 

An index is made up or one or more primary shards. Then for resiliency the primary shards are replicated to different elasticsearach hosts to make replica shards. Below we can see how the index is split into multiple primary shards. This is mainly done to improve the write performance into an elasticsearch shards. As a best practice the primary shards are spread across multiple elastcsearch hosts to improve the write performance.

![Index Splitted into multiple Primary Shards](/indexing-searching/images/index-splitted-into-primary-shards.png)

The below figure, shows how each primary shard is replicated into other elastisearch nodes to create replica shards. This is done mainly to improve the data resiliency in case of a elasticsearch node failure. Replica shards are mainly used for read requests (searching requests from users / apps).

![Primary Shards and Replica Shards](/indexing-searching/images/primary-shards-replica-shards.png)

The number of primary shards and replica shards can be configured. The primary shards count has to be defined at the time we create the index and not allowed to change one defined. The only way to change the number of primary shards is by reindexing the data into a new index. 

The number of replica shards can be changed dynamically to improve the read performance and hence it supports increasing and decreasing the replica shard count. But changing replica shards has a huge compute power and storage space impact, therefore careful thought needs to be given before doing that. 

```json
PUT /test-index
{
    "settings": {
        "number_of_shards": 3,
        "number_of_replicas": 1
    }
}
```

Elasticsearch in the backend tries to evenly distribute the data across the primary shards to keep the performance of each primary shard in optimum level. 

***Indexing*** is the action of writing documents into an elasticsearch index. We can create an index using the create index API. 

Let us get our hands dirty now. 

> ### Tips
> #### Using Kibana Dev Tools
> Eleasticsearch Kibana interface provides a very usefull tool for us to build and test queries. Rather than using any other tools like curl or Postman to invoke the elasticsearch apis. 
> 
> Using the main Kibana Menu we can select Dev Tools under Section - Management 
>
> ![Kibana Dev tools for Query building and testing](/indexing-searching/images/kibana-dev-tools-in-main-kibana-menu.png)
>
> Below is the actual Dev Tools interface
> 
> ![Kibana Dev Tools interface](/indexing-searching/images/kibana-dev-tools-interface.png) 
>

Let's log into the Kibana Dev Tools and check for the health of our elasticsearch cluster. 

```JSON
GET _cluster/health
```

The status - "yellow" is because we are running on a single node, and recommended minimum cluster size is 3 nodes. Don't worry about that for now. We can see that *number_of_nodes* is 1 and *number_of_data_nodes* is again 1. You can see the number of primary shards and many more parameters which indicates the overall health of the cluster. 

Let us now create an index and get its details. We can create an index with a PUT request. 

```json
# Creating the index
PUT my-index

# Getting the details of the index
GET my-index
```
We can see that the index named my-index was created, and the default was to have a single primary shard with 1 replica. The *mapping* section is empty. The *mapping* is the definition of the data structure or the schema (referring to the relational database terminology) of the documents which we store in the index. That's because we have not indexed any documents into the index yet. 

We can get a list of all the indices in the cluster as below. 

```json
GET _cat/indices
```

Let us know create an index with 3 primary shards and 1 replica shard. 

```json
PUT my-other-index
{
  "settings": {
    "index": {
      "number_of_shards": 3,
      "number_of_replicas": 1
    }
  }
}
```

> ### Tips
> The data in the shards should be evenly distributed for best performance. We have seen expert advice given to keep the shard size to 30GB - 50GB for high performing search use cases. 
>

## Inside of an Index
As mentioned earlier, a data record which we store in an index is called ***document*** and the equivalent of this from the relational database jargon is a record in a table. The content gets indexed in elasticsearch as a JSON object. 

JSON documents are complex data structures and contains ***key / value pairs***. They ***keys*** are generally strings, while ***values*** can be *nested objects, arrays, or data types such as datetime, geo_points, IP addresses* and more. 

### Index Settings
Index attributes and functional parameters can be defined using index settings. The settings can be *dynamic* as well as *static*. 

### Index Mappings
A filed in document is equivalent to a column in a relational database table. All fields in a document needs to be mapped to a data type. ***Index Mapping*** define the data types of each field. This is equivalent to a table schema definition in a relational database. The *mapping* of an *index* can be declared explicitly or generated dynamically by elasticsearch using the index data. 

#### Dynamic vs Explicit Mappings
Elasticsearch can auto generate the *mapping* for an *index* by looking at the data type of te ingested document fields. This is called a *dynamic mapping*. Once a field is mapped in a given index for a given data type that cannot be changed. Re-Indexing is the only option. 

Therefore, *index mapping* can't be changed onced defined. Only option is to re-create the index and re-index documents. 

> Tips
> Its always better to define *index mappings* explicitly. That helps to the for faster indexing of documents. 
> 

Let us now try to index some documents into our previously created my-index. 

Indexing with a explicit document ID. 

```python
# Index a document with _id 1
PUT my-index/_doc/1
{
  "name": "Kasun",
  "age": 40,
  "city":"Melbourne",
  "country":"Australia"  
}

## Index a document with _id 2
PUT my-index/_doc/2
{
  "name": "Amali",
  "age":  35,
  "city": "Sydney",
  "country": "Australia"
}

## Let's retrieve all the documents in the index
GET my-index/_search
```

