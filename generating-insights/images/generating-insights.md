# Generating Insights

## Aggregation Queries in Elasticsearch
Sometimes, looking for terms or phrases is not enough. We might have to count, find the min, max values or averages, medians of metrics or certain scenarios. That's where we need the aggregation functions of elasticsearch. 

Aggregations play a key role in many use case, such as Data visualization and dashboards, supervised and unsupervised machine learning jobs or even in very special cases like creating special indices with summarized data for long term retention for analytics. 

Let's look at an example. 

### Example 1: Search for all the logs that were created within the given period:

```python
# size=0 - we are asking elasticsearch not to return any individual documents, but only the count of documents which match the search criteria
GET web-logs/_search?size=0
{
 "query": {
    "range": {
     "@timestamp": {
        "gte": "2023-10-23T00:00:00.000Z",
        "lt": "2023-10-24T00:00:00.000Z"
     }
    }
 }
}
```
The total number of log entries for that date range is 4654

### Example 2: Calculate a metric representing the number of bytes that are served by the web servers in the given period. 

The search request includes a query and an aggregation component. The query component defines the subset of documents to be returned, while the aggregation component defines the aggregations to be performed on the result. 

```python
# query where we try to find documents between a data range using range option
# we are aggregating the total bytes in responses using sum

GET web-logs/_search?size=0
{
 
 "query": {
   "range": {
   "@timestamp": {
     "gte": "2023-10-23T00:00:00.000Z",
     "lt": "2023-10-24T00:00:00.000Z"
    }
   }
 },
 "aggs": {
 "bytes_served": {
   "sum": {
   "field": "http.response.body.bytes"
   }
  }
 }
}

```
We can see that the total *bytes_served* from the web server is 58785836 bytes. 

### Example 3 - Let's get the total response bytes data as hourly chunks for better granularity. 

Aggregations can be nested within a parent aggregation to achieve this outcome.

```python
# Here we are nesting an aggregation within an aggregation
# Within the outer aggregation we have included the definition for the buckets, here its hours

GET web-logs/_search?size=0
{
 "query": {
   "range": {
     "@timestamp": {
       "gte": "2023-10-23T00:00:00.000Z",
       "lt": "2023-10-24T00:00:00.000Z"
     }
   }
 },
 "aggs": {
   "hourly": {
     "date_histogram": {
       "field": "@timestamp",
       "fixed_interval": "1h"
     },
     "aggs": {
       "bytes_service": {
         "sum": {
           "field": "http.response.body.bytes"
         }
       }
     }
   }
 }
}
```

We can see that from mid night 12am to 1 am *bytes_served* 540768 bytes. Then from 1am to 2am its 436382 bytes etc. 

Some observations of the data. 
	a. The least amount of traffic was served at 12:00
		a. Is this reflected on other days as well?
		b. Is it possible that the time zone on the data needs adjusting? 
		
	b. Most traffic was served at 19:00 which was about 10x more than the least busy hour

Let's drill down even further. 

### Example 4 - Do we see the same pattern on all days

Increase the time period to 2 days to confirm patterns of seasonality in our data. Let's also return the number of Kilobytes (KB) to make the metric easier to understand. 

```python
GET web-logs/_search?size=0
{
 "query": {
   "range": {
     "@timestamp": {
       "gte": "2023-10-23T00:00:00.000Z",
       "lt": "2023-10-25T00:00:00.000Z"
     }
   }
 },
 "aggs": {
   "hourly": {
     "date_histogram": {
       "field": "@timestamp",
       "fixed_interval": "1h"
     },
     "aggs": {
       "bytes_service": {
         "sum": {
           "field": "http.response.body.bytes",
           "script": {
             "source": "_value/(1024)"
           }
         }
       }
     }
   }
 }
}

```

The following are some additional observations we can make: 
	• The traffic does seem to be cyclical every 24 hours as a similar sinusoidal pattern can be observed on both days. 
	• On both days, the average traffic during the low period was around 400-450 KB.

### Example 5 - Let's dig more deeply into the Type of Device for the requests

```python
GET web-logs/_search?size=0
{
 "query": {
     "range": {
     "@timestamp": {
         "gte": "2023-10-23T00:00:00.000Z",
         "lt": "2023-10-25T00:00:00.000Z"
       }
     }
 },
 "aggs": {
   "hourly": {
     "date_histogram": {
       "field": "@timestamp",
       "fixed_interval": "1h"
     },
     "aggs": {
       "user_agents" : {
         "terms": {
           "field": "user_agent.name",
           "size": 5
         },
         "aggs": {
           "bytes_served": {
             "sum": {
               "field": "http.response.body.bytes",
               "script": "_value/(1024)"
             }
           }
         }
       }
     }
   }
 }
}

```

Bucket aggregations can contain sub-aggregations (that can, in turn, be either metric or bucket aggregations) to further slice and dice the dataset you're analyzing. 

## Using Kibana Visualization to get the same insights

Kibana is the visualization solution in the elasticsearch solution stack. Kibana has very good data visualization capabilities. Let us now look at how we can use Kibana to visualize the data. 

### Step 1 - Setting up a Kibana Data View for the Web-logs index

Before we can create any visualizations first thing we need to do is to create a Kibana Data View. That we can do as below. 

* Select ***Stack Management*** option from the ***Main Kibana Menu*** 

![Select Stack Management from Main Kibana Menu](/generating-insights/images/creating-a-data-view-select-stack-management.png)

* Select ***Data View*** option from the ***Kibana Stack Management Menu***

![Select Data View from Kibana Stack Management Menu](/generating-insights/images/creating-a-data-view-select-data-view.png)

* Create a New Data View

![Create a New Data View with the Web-logs Index Data](/generating-insights/images/create-a-data-view-with-a-select-index-pattern.png)

* Data View created

![Data view gets created](/generating-insights/images/data-view-created-for-web-logs-data.png)

### Step 2 - Creating a Dashboard

Once the data view is created, then we can use that data view to create a dashboard. A single dashboard can have multiple visualizations. 

* Select ***Dashboard*** option from ***Kibana Main Menu***

Selec the Dashboard option from the main Kibana Menu and then select ***Create Visualization*** option. 

![Select Dashboard option from the main Kibana menu](/generating-insights/images/creating-a-dashboard-select-dashboard.png)

* Select web-logs index as the data view and last 3 months as the time frame

![Select web-logs index as the data view and last 3 months as the time frame](/generating-insights/images/select-web-logs-index-pattern-last-3-months.png)

* Creat the hourly breakdown of Sum of http.response.bytes Chart

![Create the hourly breakdown of Sum of http.response.bytes Chart](/generating-insights/images/23rd-response-body-bytes-sum-by-hour.png)

* Save the Dashboard with a name with the first visualization

![Save the Dashboard with a name with the first visualization](/generating-insights/images/save-dashboard-with-a-dashboard-name.png)

* Creat the hourly breakdown of the sum of http.response.bytes Chart with User_Agent Legend

![Creat the hourly breakdown of the sum of http.response.bytes Chart with User_Agent Legend](/generating-insights/images/response-body-bytes-sum-by-user-agent-23rd-26th-oct.png)

* You can add more visualizations following the same steps. 

![Final Dashboard](/generating-insights/images/Final%20Dashboard.png)


## Looking into Index Life Cycle Management

Most of the machine generated data captured by reading log files, doesn't change once indexed. Here a *machine* is referred to any *IT equipments like, servers, storage arrays, network devices like switches, routers, firewalls, databases, applications or even IoT devices like sensors, actuators, smart motors, smart home appliances etc*. When indexing the data captured from these all the documents have a timestamp to capture the event occurring time, data ingested time etc, therefore these type of data are ideal candidates for *Index Life Cycle Management* policies. 

Below figure explains the general usefulness of the data over time. 

![usefulness of data over time](/generating-insights/images/usefulness-of-data-over-time.png)

As the number of machines increase, the data volumes can quickly increase. Eventually it will be expensive to ingest and retain all of the data in the same high performing disks. Therefore as the data reaches a certain age, we can slowly move the data into more cheaper storage devices. 

Typically this is what we called as Data Nodes configured to run in Tiered Storage Architecture. 

* Hot
    - High performing SSD disks
    - Lower number of shards per GB heap
    - Sufficient CPU resources to support high throughput writes/reads
* Warm
    - Larger disks that allow for more storage for cost per unit cost
    - Shard density is higher than hot nodes
    - Sufficient  CPU resources to support a reasonable read / write throughput
* Cold
    - Much larger / cheaper disks (with potentially lower disk throughput)
    - Much higher shard density compared to hot nodes
    - Data is no londer replicated
    - Cheaper instance types with lower CPU resources
* Frozen
    - Data is no longer kept on data nodes. 
    - Cheap external storage such as object stores used to store data
    - Much slower search response
    - Can support cheap long term storage of data


### Index Lifecycle Management

Index Lifecycle Management (ILM) policies can be configured to define the various phases within the life cycle of an index (such as hot, warm, cold, delete, and so on) and the actions to be performed as data transitions through the phases.

Below are basic concepts of ILM:

* *Bootstrap Index* 
    - *bootstrap index* - is the initial index that needs to be created. This needs to be created manually. ***Data Stream*** based indices don't need a *bootstrap* index. 
    - *Write Alias* - ILM means that we will end up with many different indices with a similar naming pattern. But the actual agents who are sending the data doesn't know whats the latest active index is. That's where the *Write Alias* comes in. *Write Alias* will act as a transparent way to interact with the current active index. 
    - *Index Rollover* - *Index Rollover* is where we create a new index and change the *write alias* to the new index. So we stop writing new data to the previous index, and we make the previous index *read-only*. *Rollover* will happen when the defined *rollover conditions* are met. *Rollover conditions* are conditions like, *maximum index size, maximum number of documents, or maximum number of index age* etc. 

Below figure explains the ILM concepts. 

![ILM Concepts](/generating-insights/images/ilm-index-rollover.png)

Let's get our hands dirty again with ILM Policies

```python
## Creating an index lifecycle policy

PUT _ilm/policy/logs-policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "1d",
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_size": "50gb"
          }
        }
      },
      "warm": {
        "min_age": "1d",
        "actions": {
          
        }
      },
      "delete": {
        "min_age": "10d",
        "actions": {
          
        }
      }
    }
  }
}

## Define and Index template for the data source that references the ILM policy we created previously

PUT _index_template/web-logs
{
  "index_patterns": ["ilm-web-logs"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1,
      "index.lifecycle.name": "logs-policy",
      "index.lifecycle.rollover_alias" : "ilm-web-logs"
    }
  }
}

## Create a boostrap index for the data source and start writing data
PUT ilm-web-logs-000001
{
  "aliases": {
    "ilm-web-logs": {
      "is_write_index": true
    }
  }
}

## Indexing a document
POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T03:00:00.000Z",
 "log": "server is up"
}

POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T04:00:00.000Z",
 "log": "server is up"
}

POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T05:00:00.000Z",
 "log": "server is up"
}
## let's look at the index
GET ilm-web-logs/_search

```

An index can be rolled over manually if needed, even if the rollover conditions that have been defined in the ILM policy haven't been met. One instance when this can be useful is when the index template/mapping for a data source needs to be updated. Roll over the index as follows

```python
## Rolling Over an index manually
POST ilm-web-logs/_rollover

# Let's index more documents
POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T06:00:00.000Z",
 "log": "server is down"
}

POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T07:00:00.000Z",
 "log": "server is down"
}

POST ilm-web-logs/_doc
{
 "timestamp": "2023-10-24T08:00:00.000Z",
 "log": "server is up"
}

# View all the indices for ilm-web-logs by running the following command: 
# View all the indices for ilm-web-logs
GET _cat/indices/ilm-web-logs*?v

# All the indices can be searched as follows
GET ilm-web-logs/_search 
# You can use the * as a wildcard character as well. 
GET ilm-web-logs*/_search 


```

## Data Streams

Managing the time-series data is very easy with the ILM policies. But one drawback is having to create the *bootstrap index". Elasticsearch has come with a even better solution which they call as ***data streams***. *Data Streams* are built on top of ILM features. They automatically create the ILM related components. *Data Streams* also provides a single / uniform resource name to help write and consume data and hide the complexity of underlying elasticsearch indices from the consumer. 

We need two things to setup a *data stream*
- ILM Policy
- Index Template with Data Streams enabled. The *index pattern* in the template should match the name of the *data stream* to be created

Let's now see this in action

```python
## Creating a new Index Template with Data Streams enabled
PUT /_index_template/logs-datastream
{
  "priority": 200,
  "index_patterns": ["logs-datastream*"],
  "data_stream": {
    
  },
  "template": {
    "settings": {
      "index.lifecycle.name": "logs-policy"
    }
  }
}

## Creating the data stream
PUT /_data_stream/logs-datastream-web-server

## Looking at the backing indices
GET _data_stream/logs-datastream-web-server


## Indexing a document
POST logs-datastream-web-server/_doc
{
 "timestamp": "2023-10-24T03:00:00.000Z",
 "log": "server is up"
}

POST logs-datastream-web-server/_doc
{
 "timestamp": "2023-10-24T04:00:00.000Z",
 "log": "server is up"
}

POST logs-datastream-web-server/_doc
{
 "timestamp": "2023-10-24T05:00:00.000Z",
 "log": "server is up"
}

```

## Data Transformation using Ingest Pipelines

