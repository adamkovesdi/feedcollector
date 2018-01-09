# Feed collector Ruby application

This application collects feed data from varius RSS sources for my Machine Learning experiment. This feed data can be used as initial brain training dataset for my [news-categorizer](https://github.com/adamkovesdi/news-categorizer)

Produces a plain text files [output.txt] in the following format (example entry):
```
Tue, 09 Jan 2018 02:30:16 +0000|Samsung forecasts record profits but misses expectations|The South Korean giant shakes off corruption scandal to predict 64% jump in quarterly earnings.
```
Format:
```
date|title|headline
```

## Configuration file YAML
```
---
outputdir: "data"
sleepinterval: 1800
feeds:
  - name: health
    url: "http://feeds.bbci.co.uk/news/health/rss.xml"
  - name: entertainment_arts
    url: "http://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml"
  - name: politics
    url: "http://feeds.bbci.co.uk/news/politics/rss.xml"
  - name: science_environment
    url: "http://feeds.bbci.co.uk/news/science_and_environment/rss.xml"
  - name: technology
    url: "http://feeds.bbci.co.uk/news/technology/rss.xml"
  - name: business
    url: "http://feeds.bbci.co.uk/news/business/rss.xml"
  - name: education
    url: "http://feeds.bbci.co.uk/news/education/rss.xml"
  - name: football
    url: "http://feeds.bbci.co.uk/sport/football/rss.xml?edition=int"
```

## Usage

Standalone
```
$ ruby feedcollector.rb -f config.yml
```
```
for help:
$ ruby feedcollector.rb -h
```

Dockerized
```
$ docker-compose up
$ docker-compose down

To inspect data volume:
$ docker run -it --rm --name fcinspect -v feedcollector_data:/data busybox
```

## Feeds

Sourced from a selection of feeds at BBC UK

## Links

- [BBC News UK](http://www.bbc.com/news/10628494)
