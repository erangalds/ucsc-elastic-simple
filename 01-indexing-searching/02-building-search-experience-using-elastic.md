# Building Search Experience using Elasticsearch

*Elasticsearch* is a well known for its *searching* capabilities. *Elasticsearch* supports *full-text* search as a main core feature. The platform is widely used around the world by *E-commerse* web sites speacially to provide *product searching* for their customers. Also it can be used to *product recommendations* by showing similar products to the users. 

Let's setup the lab for the *full-text search*

```bash
cd /home/vagrant/full-text-search
ls -alrt
# Set the Execusion bit of the scripts
chmod u+x *.sh
# Let's setup the indexes
bash setup-index.sh
# Load the Data
bash ingest-recipes-data.sh
```

Let's verify for data loading
```python
# Let's do a basic full search of the entire index
GET recipes/_search
```



## An Introduction to Full-Text Searching
The simplest way to search something is by trying to match the search term or text with the data in our database. In *Elasticsearch* this type of searching is called *term searching* and *term-level queries* are used for that. *Term searching* is useful when we know exactly what we need to search and most of the time that is not the case. Most of the time, we don't know exactly what we want to search for but have some wage idea about what we want to search. 

For an example, if a user wanted to retrieve all recipes published by a his favorite or a well known author, then using *term-level* queries we can quickly search for that. Let's look at how. 

```python
# If you know the author if the recipes
GET recipes/_search
{
  "query": {
    "terms": {
      "author": [
        "Staff",
        "Jim Mar"
      ]
    }
  }
}

# If we want to pull only the title of the recipes
GET recipes/_search
{
  "_source": ["title"], 
  "query": {
    "terms": {
      "author": [
        "Staff",
        "Jim Mar"
      ]
    }
  }
}

```

We can see that we can easily get all the recipes published by the two authors. However, let's now consider a slightly different scenario, where a user doesn't know authors name exactly but wants to search for recipes such as chicken pie or tomato soup. This kind of requirement is a bit tough for *term-level queries*. 

Let's try this using terms searching. 

```python
# If you know the author if the recipes
GET recipes/_search
{
  "query": {
    "terms": {
      "title": [
        "chicken pie",
        "tomato soup"
      ]
    }
  }
}

GET recipes/_search
{
  "query": {
    "terms": {
      "description": [
        "chicken pie",
        "tomato soup"
      ]
    }
  }
}
```

This is a great case for *full-text search*. When in a scenario like above, if a user searches for tomato soup, you might want to return results for tomato stew, vegetable soup, or tomatillo soup as relevant hits. A full-text search also needs to account for linguistic characteristics in the text. For example, the search melted butter should return hits containing melting butter and melt butter.

Let's see this in action now. 

```python
# Query to return hits for chicken pie
GET recipes/_search
{
  "_source": ["title"], 
  "query": {
    "match": {
      "title": "chicken pie"
    }
  }
}
```
We can see that we got titles like "Chicket Pot Pie", "Chicken, Ham, and Tarragon Pie", "Chicken and Root Vegetable Pot Pie" as results. Which is what should happen. Elasticsearch will match the "title" field in the index for any references to chicken pie, and return a list of results, ranked by an automatically calculated score. 

### How Full-Text Search Works in the backend. 

#### Analyzing Text for a search
In *Elasticsearch* in order to support *full-text search* all the **"text"** fields are ***analyzed*** before getting them ingested to the *index*. This activity is a resource heavy process compared to other fields like *keywords and dates and numeric*. The main reason for *analyzing* the text before ingesion is to make it efficient for searching (retrieval). ***Text Analysis*** has two main parts to it, which are ***tokenization***, and ***normalization***. 

*Tokeninzation* divides text down into smaller chunks called *tokens*. In most cases a *token* woulb correspond to a single word, but this can depend on the language used and the use of case for the field. 

Thre are several types of *tokenizers* supported by elasticsearch. Let's look at the *standard tokenizer* in action now. 

```python
## Let's look at the standard Tokenizer
POST _analyze
{
 "tokenizer": "standard",
 "text": ["To start melting butter, add 10g of butter into a heat-proof bowl and MICROWAVE on medium for 10 seconds before transferring to the cake pan!"]
}
```
Now, we can see why The title "chicken pot pie" case as a matched result when we searched for "chicken pie". The *tokens* could have a mix of upper / lower case characters. Not only that sometimes, tokens such as *melting*, or *transferring* use a present continuous tense. We don't know whether the user is going to use the present tense or use imperative form such as melt and transfer. 

That's the place where *normalization* comes to play. *Normalization* can convert tokens to a more standardized form to improve the number of hits matched while returning relevant results. *Normalization* removes or filters our unnecessary characters as well as standardizing the *case* and *stem* words in the text. 

An ***analyzer*** in *elasticsearch* implements a combination of this *tokeninzation* and *normalization* using *character filters, tokenizers, and token filters*. There are various types of built-in *analyzers* in elasticsearch and we can chose which one to use based on the use case. 

Not only that we can create our own *custom analyzers* if the built-in *analyzers* are not useful. 

Now let's see a built-in *standard analyzer* in action. 

```python
POST _analyze
{
 "analyzer": "standard", 
 "text": ["To start melting butter, add 10g of butter into a heat-proof bowl and MICROWAVE on medium for 10 seconds before transferring to the cake pan!"]
}
```

We can see that, "To" was converted to "to" and "pan!" was converted to "pan", "MICROWAVE" was converted to "microwave". Basically, the *standard analyzer* converts all characters to lower case and remove non-alphanumeric characaters. There are language specific *analyzers". Let's look at one in action now. 

```python
POST _analyze
{
 "analyzer": "english", 
 "text": ["To start melting butter, add 10g of butter into a heat-proof bowl and MICROWAVE on medium for 10 seconds before transferring to the cake pan!"]
}
```
Notice that the english analyzer is a lot more aggressive in transforming the input. Stop words such as to, and, into, and for are removed from the text as they don't impact search relevance. Words such as melting and seconds are stemmed to melt and second to improve matching.

When searching in a text field, Elasticsearch applies the same tokenization and normalization process to the input text to find matches in the index.


### Running Searches

Let's start by searching for 'chicken pot pie'. 

```python
POST recipes/_search
{
 "_source": [ "title" ],
 "query": { "match": { "title": "chicken pot pie" } }
}
```

While the results look relatively good, note that some of the hits returned are for recipes with titles such as "Instant Pot Chicken Stock" and "One-Pot Chicken and Chorizo". These results are somewhat relevant to our search terms but are not pie recipes. These results are returned because the match query performs an OR operation by default on the terms matched. 

We can change the query a bit by adding the a parameter called *operator* to make the *match* query to treat terms as "AND". Let's see that now. 

```python
POST recipes/_search
{
  "_source": ["title"],
  "query": {
    "match": {
      "title": {
        "query": "chicken pot pie",
        "operator": "and"
      }
    }
  }
}
```

We can see, the results now have all three terms. 

The other challenge that we might face more often is that the searched terms entered by the users will tend to have typos. We can handle that using a parameter called *fuzziness* in the query. 

*Fuziness* controls the *maximum edit distance* for words for matches found. 

Example: "chikcen" has an edit distance of 1 to the desired input of "chicken". Let's see this in action now. 

```python
# Typos without fuziness
POST recipes/_search
{
  "_source": ["title"],
  "query": {
    "match": {
      "title": {
        "query": "chikcen pot pie",
         "operator": "and"
      }
    }
  }
}

# Typos with fuziness
POST recipes/_search
{
  "_source": ["title"],
  "query": {
    "match": {
      "title": {
        "query": "chikcen pot pie",
        "fuzziness": 1, 
        "operator": "and"
      }
    }
  }
}
```

Other most important feature is that we can allow *funizess* to be set automatically based on the term in question. 

Now the "AND" operator isn't always the most appropriate choise for returning results, because when you have more terms in the search text its very hard to  find something which has all the terms in the search text. Therefore, we can use another parameter called *minimum_should_match* setting to fine tune the number of matches without use the *operator* parameter. Let's see that now. 

```python

POST recipes/_search
{
  "_source": ["title"],
  "query": {
    "match": {
      "title": {
        "query": "cjicken pot pie salad",
        "fuzziness": 1, 
        "minimum_should_match": 3
      }
    }
  }
}
```

All these times, we searched our searched text against one filed in *elasticsearch*. If we want to search the same text in multiple *fileds in the index* we can do taht with the *multi_match* query. 

For example, searching for tea cakes may not yield the best results when matching only on the title field in the index, given it is not a very common dish. A multi-match allows us to add more search fields such as description to improve search this case. 

```python
POST recipes/_search
{
  "_source": ["title", "description"],
  "query": {
    "multi_match": {
      "query": "tea cakes",
      "fields": ["title","description"],
      "minimum_should_match": 2
    }
  }
}
```

When using the *multi_match* query, if we want to give more weight or importance to certain fields we can do that by using the ^ symbol. 

```python
POST recipes/_search
{
  "_source": ["title", "description"],
  "query": {
    "multi_match": {
      "query": "tea cakes",
      "fields": ["title^5","description"],
      "minimum_should_match": 2
    }
  }
}

```

We cab also search for phrases using the *match_phrase* query. Let's see how that works. 

```python
POST recipes/_search
{
  "_source": ["title", "description"],
  "query": {
    "match_phrase": {
      "title": {
        "query": "carrot cake"
      }
    }
  }
}
```

When we do that the terms "carrot" and "cake" will be searched for in the correct order as well. 

We can also order the search results. Below is a case where we order the results based on the rating value. 

```python
POST recipes/_search
{
  "_source": ["title","rating.ratingValue"],
  "sort": [
    {
      "rating.ratingValue": {
        "order": "desc"
      }
    }
  ], 
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "chicken"
          }
        }
      ]
    }
  }
}
```



