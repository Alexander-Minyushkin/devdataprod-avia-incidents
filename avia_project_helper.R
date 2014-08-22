
library(XML)
library(ggplot2)
library(shinyapps)

Sys.setlocale("LC_TIME", "us")

options(stringsAsFactors = FALSE)

d <- xmlParse("AviationData.xml")

els <- getNodeSet(d, "//x:ROW", "x")
attrs <- sapply(els, function(x) xmlAttrs(x)) 

out <- data.frame(t(attrs))

converMixedDate <- function(x){
  y <- strptime(x, tz = "", "%m/%d/%Y" )
  
  y[is.na(y)] <- strptime(x[is.na(y)], tz = "", "%Y-%m-%d" )
    
  
  y
}

out$E_Date <- converMixedDate(out$EventDate)
out$P_Date <- converMixedDate(out$PublicationDate)

# Still have a mess in dates. Just clean them up for now
out <- out[ !is.na(out$P_Date) & !is.na(out$E_Date),]

out$investigationTimeDays <- as.numeric(out$P_Date - out$E_Date) / 24/3600

# cleanup some more inconsystencies
out <- out[out$investigationTimeDays>0,]

out$ReportStatus <- as.factor(out$ReportStatus)
out$TotalFatalInjuries <- as.numeric(out$TotalFatalInjuries)

hist(log10(out$investigationTimeDays))