# Exploratory Graphs


## Annual average PM2.5 averaged over the period 2008 through 2010 from EPA

### Zipped data in class folder
### pm25 - density averaged from 2008-10; fips - id for county; region
### longitude, latitude
pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric", "character", "factor", "numeric", "numeric"))
head(pollution)


## Five (actually six... mean included) Number Summary

### min, max, 1st,3rd quantiles, median, mean
summary(pollution$pm25)


## Boxplot

### shows summary data visually
boxplot(pollution$pm25, col = "blue")


## Histogram

### Information about the distribution
hist(pollution$pm25, col = "green")


## Histogram2

### Rug is under the histogram and it plots each data point for fine
### details about outliers and bulk of the data
hist(pollution$pm25, col = "green")
rug(pollution$pm25)


## Historgram3

### break changes the number of bars, helps determine shape. 
### Beware: larger number of bars, the more noise in the graph
hist(pollution$pm25, col = "green", breaks = 100)
rug(pollution$pm25)


## Overlaying Features

### abline adds horizontal line show the US std at 12 micro grams/m^3
### Shows over 75% of counties within allowable standard
boxplot(pollution$pm25, col = "blue")
abline(h = 12)


## Features2

### Doing same thing w/histogram but adding vertical line +line width
### and color. Second verticle showing median.
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "magenta", lwd = 4)


## Bar plot

### Summarizing categorical variable, region. Counts East vs West in data.
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")


## Multiple Boxplots

### y axis=pm25 with both East, West box plots
### shows median (or mean?) lower in the west but west with most
### extreme cases.
boxplot(pm25 ~ region, data = pollution, col = "red")


## Multiple Histograms

### 2 histograms, one east, one west. Conclusions same as above.
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")


## Scatterplot

### yaxis = pm25, xaxis = latitude. A north/south analysis
### horiz line represents US std. line width 2, lty=2 means dashed?
### no real trend here. Does seem concentrated around middle region
### Gives sense of how many counties in violation of US standard.
with(pollution, plot(latitude, pm25))
abline(h = 12, lwd = 2, lty = 2)


## Scatterplot with Color

### Color adds east, west 3rd dimension. Black = east, Red = West
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)


## Multiple Scatterplots

###
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
### latitude(x) vs pm25(y). data= west region
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
### latitude vs pm25, data = east region
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))
### again shows pollution concentrated in mid-latitudes.