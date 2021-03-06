---
title       : Avia incidents investigation time
subtitle    : Slides for Coursera "Developing Data Products" peer review
author      : Alexander Minyushkin
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction

After crash of Malaysia Airlines Flight MH17 on 2014 July 17, there were many complaints that investiagtion takes too long time.

So I decide to take a look at statistics and get some understanding of reasonable time for aviation incidents investigations.

--- .class #id 

## Data 

Using Google search I found some relevant open data here http://catalog.data.gov/dataset/ntsb-aviation-accident-database-extract-of-aviation-accident-records-since-1982--ntsb-1962

XML file is pretty big, so here you can see how it looks like in general:

```r
skipout<-lapply(readLines("AviationData_sample.xml"), function(x) cat(paste0(x, "\n")))
```

```
## <DATA xmlns="http://www.ntsb.gov">
## <ROWS>
## <ROW EventId="20140816X62709" EventDate="08/16/2014" Location="Opheim, MT" Country="United States" Latitude="" Longitude="" AirportCode="" AirportName="" InjurySeverity="" AircraftDamage="" AircraftCategory="" RegistrationNumber="N4709Z" Make="PIPER" Model="PA 22-108" AmateurBuilt="" NumberOfEngines="" EngineType="" FARDescription="" Schedule="" PurposeOfFlight="" AirCarrier="" TotalFatalInjuries="" TotalSeriousInjuries="" TotalMinorInjuries="" TotalUninjured="" WeatherCondition="" BroadPhaseOfFlight="" ReportStatus="Preliminary" PublicationDate="" />
## <ROW EventId="20140813X65210" EventDate="2014-08-13" Location="Salmon, ID" Country="United States" Latitude="45.120834" Longitude="-113.875278" AirportCode="KSMN" AirportName="Lemhi County Airport" InjurySeverity="Non-Fatal" AircraftDamage="Substantial" AircraftCategory="Airplane" RegistrationNumber="N2190H" Make="PIPER" Model="PA 28-236" AmateurBuilt="No" NumberOfEngines="1" EngineType="Reciprocating" FARDescription="Part 91: General Aviation" Schedule="" PurposeOfFlight="Personal" AirCarrier="" TotalFatalInjuries="" TotalSeriousInjuries="" TotalMinorInjuries="1" TotalUninjured="1" WeatherCondition="VMC" BroadPhaseOfFlight="" ReportStatus="Preliminary" PublicationDate="2014-08-16" />
## </ROWS>
## </DATA>
```


--- .class #id 

## Parsing Data 

Reading data using XML package


```r
library(XML)
options(stringsAsFactors = FALSE)

d <- xmlParse("AviationData_sample.xml")

els <- getNodeSet(d, "//x:ROW", "x")
attrs <- sapply(els, function(x) xmlAttrs(x)) 

out <- data.frame(t(attrs))
```



--- .class #id 


## Parsing Data Continues

After brief review I found that dates in the file stored in different formats, so I make a function to correct this.


```r
converMixedDate <- function(x){
  y <- strptime(x, tz = "", "%m/%d/%Y" )  
  y[is.na(y)] <- strptime(x[is.na(y)], tz = "", "%Y-%m-%d" )      
  y
  
}

converMixedDate(out$EventDate)
```

```
## [1] "2014-08-16 MSK" "2014-08-13 MSK"
```

Ignore timezone for now, it is not used later

--- .class #id 

## Data Cleanup

When I found that there are still few dates was not processed properly I decided ti exclude them from data frame


```r
# Still have a mess in dates. Just clean them up for now
out <- out[ !is.na(out$P_Date) & !is.na(out$E_Date),]

out$investigationTimeDays <- as.numeric(out$P_Date - out$E_Date) / 24/3600

# cleanup some more inconsystencies
out <- out[out$investigationTimeDays>0,]
```

--- .class #id 

## Results

Now I can look at plots like this

http://alexander.shinyapps.io/avia_project


--- .class #id 
