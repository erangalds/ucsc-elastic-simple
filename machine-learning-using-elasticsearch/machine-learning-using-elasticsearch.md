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
GET webapp-tagged/_search

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

* Create a Machine Learning Job

![Let's create a machine learning job](/machine-learning-using-elasticsearch/images/13-create-anomaly-detection-job.png)

We need to select a data view to specify which data set is to be used by the machine learning job

![Select a data view](/machine-learning-using-elasticsearch/images/14-select-a-data-view.png)

Let us start with a single metric anomaly detection job. 

![Select Single Metric Job option](/machine-learning-using-elasticsearch/images/15-select-single-metric-anomaly-option.png)

We then need to select the time range to specify which data set is to be used in the model training. Here we are going to select the full data set option. 

![Select Time range of the data set](/machine-learning-using-elasticsearch/images/16-select-time-range-full-data-set.png)

* Configuring the Machine Learning Job

Once the data view is created with the right index and data set is selected with the correct time range, the next step is to configure the machine learning job. 

Let's select COUN(Event_Rate), where we are asking to count the number of events in the time series data set to find anomalies. 

![Select COUNT(Event Rate)](/machine-learning-using-elasticsearch/images/17-choose-event-rate-count-as-the-field.png)

Next, we need to configure the buckt size. Elasticsearch will break the data set into multiple segments based on the bucket size to determine the anomaly. The bucket size can be allowed to be auto detected by elasticsearch. But for this scenario, let us select 1 minute (1m) as the bucket size. 

![Select 1m as bucket size](/machine-learning-using-elasticsearch/images/18-choose-1m-as-bucket-span.png)

Then we need to give a name to the machine learning job. 

![Give a name to the machine learning job](/machine-learning-using-elasticsearch/images/19-give-a-name-for-the-ml-job.png)

Validating the job configuration. 

![Validating the ML Job Configuration](/machine-learning-using-elasticsearch/images/20-validate-job-settings.png)

Now, we can create the job. 

![Create the Job](/machine-learning-using-elasticsearch/images/21-select-create-job.png)

After few seconds or minutes (depending your elasticsearch node configuration) the job should finish. 

![finished ML job](/machine-learning-using-elasticsearch/images/22-we-can-see-the-model-training-is-completed-select-view-result.png)

Let us new view the results of the ML Job. Click on the view results button, and that will take you to the results page. We can see that some anomalies were detected. Let's move the time slider and focus on the time period where the anomalies were detected. 

![View Results of the ML Job](/machine-learning-using-elasticsearch/images/23-adjust-time-slider-to-focus-on-anomalous-transactions.png)

We can see that in days between 6thh to 9th there were some anomalous activity in the event count. This means that we now need to dig deeper into this scenario for to furhter discover new insights. 

Additionally we can forecast the behanior for any number of days using the forecast option. But The data set we have is not enough for accurate forecasting. 

![Forecasting Event Rate behavior for the next 7 days](/machine-learning-using-elasticsearch/images/24-forecasting-7days.png)

Forecast results

![forecast results](/machine-learning-using-elasticsearch/images/25-forecast.png)

* Digging Deeper into the Analysis with Multi Metric ML Jobs

Let us now dig a little deeper into the issue which we identified earlier. Now let's try to create a multi metric machine learning job to further analyse the problem. 

![Create another machine learning job](/machine-learning-using-elasticsearch/images/26-create-another-anomalous-job-for-data-transwer-volumes.png)

This time let us try to analyze the data transfer volumes. *http.response.bytes* and *http.request.bytes* to find out whether some anomalous behavior can be detected on that metric. 

![Select the Webapp Data View](/machine-learning-using-elasticsearch/images/27-select-webapp-data-view.png)

Select Multi Metric option

![Select Multi Metric Option](/machine-learning-using-elasticsearch/images/28-select-multi-metric.png)

As done previously, let's select the time range. 

![Select Time Range](/machine-learning-using-elasticsearch/images/29-use-full-data-set.png)

* Configuring the Multi Metric ML Job

Let's select the *MEAN(http.response.bytes)* as the metric

![Choose MEAN(http.response.bytes)](/machine-learning-using-elasticsearch/images/30-choose-mean-response-bytes.png)

Further configure the job

![More configurationgs](/machine-learning-using-elasticsearch/images/31-configure-analysis.png)

Give a name to the ML job

![Give a name to the ML Job](/machine-learning-using-elasticsearch/images/32-give-a-name-to-the-ml-job.png)

Validate the ML job

![Validate the Job](/machine-learning-using-elasticsearch/images/33-validate-job.png)

Create the ML Job

![Create the ML Job](/machine-learning-using-elasticsearch/images/34-create-job.png)

After few seconds, the Job should finishe successfully. 

![Job Finished, Select View Results](/machine-learning-using-elasticsearch/images/35-select-view-results.png)

We can clearly see some anomalies in the MEAN of *http.response.bytes*

![Amonalies found](/machine-learning-using-elasticsearch/images/36-anomalies-detected.png)

Details of the anomalous events

![Details of the anomalous events](/machine-learning-using-elasticsearch/images/37-digging-into-details.png)


* Population Analysis ML Jobs 

We were able to find an suspicious IP address from the Multi Metric Anomaloy Detection job. Let us now see whether we can confirm the same with further analysis using a ***Population Analysis***. 

![Population Analysis](/machine-learning-using-elasticsearch/images/38-population-analysis.png)

As previous, selecting the time rage of the data set. 

![Selecting the time range of the data set](/machine-learning-using-elasticsearch/images/39-select-full-data-set.png)

Configuring the ML Job

![Configuring the ML Job](/machine-learning-using-elasticsearch/images/40-configure-ml-job.png)

Give a name to the ML Job

![Give a name to the ML Job](/machine-learning-using-elasticsearch/images/41-give-a-name-to-ml-job.png)

Create the JOB

![Create the ML Job](/machine-learning-using-elasticsearch/images/42-create-ml-job.png)

Let us now view the results. 

![View Results](/machine-learning-using-elasticsearch/images/43-view-results.png)

Summarizing the Results for the Source IP addresses

![Summary of Results for the Source IP addresses](/machine-learning-using-elasticsearch/images/44-results-summary-for-source-ip.png)

Further details about the anomalous Source IP address. 

![Further details about the Source IP](/machine-learning-using-elasticsearch/images/45-more-details-about-anomalous-source-ip.png)

* Let us now go the ***Elastic Discover App** to further dig into the actual event details. 

Let's go to the *Elastic Discover App*

![Elastic Discover App](/machine-learning-using-elasticsearch/images/46-discover-app-analysis.png)

We can configure what information we want to see from the actual Event details. 

![Customize the Actual Event Details screen](/machine-learning-using-elasticsearch/images/47-custom-detail-view-of-the-hack.png)



## Classification Analysis with Elasticsearch. 

Let us now look at a ***Classification*** type of ML Analsys using Elasticsearch

* Create another Data View 

*Classification* Type of ML Analysis needs a *Labeled Data Set*. When we were preparing the elasticsearch lab earlier the tagged data set was alreay automatically indexed into a new *index* called *webapp-tagged*. We can verify that. 

```python
GET webapp-tagged/_search
```


![Create another ML Job](/machine-learning-using-elasticsearch/images/48-create-another-new-data-view-webapp-tagged-data.png)

Data view created

![Data View created](/machine-learning-using-elasticsearch/images/49-new-data-view-webapp-tagged.png)

* Select Data Frame Analysis from Elasticsearch Machine Learning App

The *Classification, regression* type of analysis is given under the *Data Frame Analysis* section in Elasticsearch 

![Select Data Frame Analysis](/machine-learning-using-elasticsearch/images/50-select-data-frame-analysis-create-job.png)

Let us create another machine learning job. This time we will create a classification job.

Select the webapp-tagged as the Data View. 

![Select Data View](/machine-learning-using-elasticsearch/images/51-select-webapp-tagged-data-view.png)

Select *Classification*

![Select Classification](/machine-learning-using-elasticsearch/images/52-select-classification.png)

* Let us now configure the *Classification ML Job*

![Configure Classification ML Job](/machine-learning-using-elasticsearch/images/53-configure-classification-ml-job.png)



![Configure Classification ML Job](/machine-learning-using-elasticsearch/images/54-configure-classification-ml-job.png)

No additional parameters for this use case

![No Additional Parameters](/machine-learning-using-elasticsearch/images/55-no-additional-parameters.png)

Give a name to the classification ML Job

![Give a name to the classification ML job](/machine-learning-using-elasticsearch/images/56-give-a-name-classification-ml-job.png)

Validate the Job

![Validate the Job](/machine-learning-using-elasticsearch/images/57-validation.png)

Create *Classification ML Job*

![Create classification ML Job](/machine-learning-using-elasticsearch/images/58-create-classification-ml-job.png)

Let's now go back to the data frame analsys to view the results. 

![Go back to data frame analysis](/machine-learning-using-elasticsearch/images/59-go-back-to-data-frame-analytics.png)

Classification Job finished execution

![finished execution](/machine-learning-using-elasticsearch/images/60-classification-job-finished.png)

Let's look at the results 

![Let's look at the results](/machine-learning-using-elasticsearch/images/61-results-explorer.png)

The trained models section. 

![Trained Model Section](/machine-learning-using-elasticsearch/images/62-trained-models.png)

