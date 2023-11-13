# Using Machine Learning on data with Elasticsearch

A lot of data sources often represent trends or insights that are hard to capture using a predifined rule or query. Look at the following example scenarios. 
* An environment has logs which gets streamed from about 5000 endpoints
* In an environment only a subset of endpoints starts to show intermittent failures in the application, but the machine is not down. 
* There is a overall drop in the log volume from an application but it is not drastic enough for a predefined rule to trigger an alert. 

Its is very difficult to detect this sort of issues with standard predifined rule based alerts. These are ideal candidates for anomaly detection. We can create baseline machine learning models using elasticsearch and then use those models to generate alerts if anomalous activity is detected. 


Let's try out Machine Learning features in elasticsearch. First we need to load some sample data into out elasticsearch cluster. 

```bash
pwd
cd /home/vagrant/webapp
# Setting up the index and the index pipeline
./setup-index-and-ingest-pipeline.sh
# loading the sample data
./ingest-webapp-data.sh

```

One loaded we can then verify that in elasticsearch

```python
GET webapp/_search

```
## Looking for Anomalies in Time Series Data

### Trying to find anomalous event rates in application logs

#### Preparing the Data for Analysis

* Setup 1 - Setting up a Data View using the Web App Index 

First we need to select the Statck Management App from the Kibana Main memu. 

![Setting up a Data View using the Web App Index](/machine-learning-using-elasticsearch/images/01-create-data-view-webapp-data.png)

Then we need to create a new Data View using the Webapp Index pattern. 

![Setting up a Data View using the Web App Index](/machine-learning-using-elasticsearch/images/02-create-data-view-webapp-data.png)

The created webapp data view. 

![Setting up a Data View using the Web App Index](/machine-learning-using-elasticsearch/images/03-create-data-view-webapp-data.png)

Let's go the Discover App and check for data. 

![Checking the data in Discover App](/machine-learning-using-elasticsearch/images/04-go-to-discover-app-to-view-data.png)

Then we need to select the WebApp index pattern 

![Select the Webapp index](/machine-learning-using-elasticsearch/images/05-select-webapp-index-pattern.png)

Since this is not a realtime data feed, but a historical data set. We need to adjust the time range. 

![Adjust the time range correctly to view the webapp data](/machine-learning-using-elasticsearch/images/06-adjust-the-time-range.png) 

We can now see the webapp data. 

![We can now see the web app data](/machine-learning-using-elasticsearch/images/07-we-can-see-webapp-data.png)

* Step 2 - Enabling a Trial 30 License to use Elasticsearch Machine Learning features

![Let's go to machine learing app in the kibana main menu](/machine-learning-using-elasticsearch/images/08-select-machine-learning-app-kibana-main-menu.png)

We can see that its' asking to enable a trial license, since we don't have a proper valid license which has machine learning capabilities. Therefore, select the Start Trial option. 

![Enable Trial License](/machine-learning-using-elasticsearch/images/09-we-have-to-enable-trial.png)

![Start Trial](/machine-learning-using-elasticsearch/images/10-start-trial.png)

Now we should see that the Trial Key is activated. 

![Trial Key Activiated](/machine-learning-using-elasticsearch/images/11-trial-activated.png)

Now let us go back to machine learning app. 

![Let's go back to machine learning app](/machine-learning-using-elasticsearch/images/12-select-machine-learning-app-again.png) 


#### Starting with Anomaly Detection

