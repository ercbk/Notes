# Summarizing data




## Getting the data from the web

### Create a dir if one doesn't already exist
if(!file.exist("./data")){dir.creat("./data")}
### Create object for url
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
### d/l the .csv. (url, destination dir, curl need if https+using a MAC)
download.file(fileUrl, destifile="./data/restaurants.csv",method="curl")
### read the data from the file that in that directory
restData <- read.csv("./data/restaurants.csv")


## Look at a bit of the data

### look at the first 3 lines
head(restData,n=3)
### look at the last 3 lines
tail(restData,n=3)


## make summary

### summary: for text data - shows the count, for numeric - gives min,
### max, 1st,3rd quantile, median, mean
summary(reData)
### structure: tells you class of object (dataframe, matrix, etc),
### dimension of the dataframe, classes for each column (int, factor,etc)
str(restData)
### use quantile to look at the variablity of numeric data
### looking at councilDistrict variable. Quantiles are the data values
### located at each percentage cutoff. 0%=minValue, 100%=maxValue,
### 50%=median value
quantile(restData$councilDistrict, na.rm=TRUE)
### probs argument allows you to look at values at specific
### percentages(/probabilities)
quantile(restData$councilDistrict, probs=c(0.5,0.75,0.9),na.rm=TRUE)


## make table

### zipcode table will show the count for each zip code.
### *important* to include useNA="ifany" arg which creates 
### a NA column with count of NA values.
table(restData$zipCode, useNA="ifany")
### 2 dimensional table with district and zipcode.
table(restData$councilDistrict,restData$zipCode)


## check for missing values

### sum return 1 if NAs present, 0 if not
sum(is.na(restData$councilDistrict))
### any returns True if NAs present, False if not
any(is.na(restData$councilDistrict))
### all tests a condition on the data, Returns T or F
all(restData$zipCode>0)
###Row and column sums
### Counting NAs for each column
colSums(is.na(restData))
### applying all to colSums tests whether any col has a NA, returns T,F
all(colSums(is.na(restData))==0)


## Values with specific characteristics

### %in% creates a logical
### creates table with count of 21212(TRUE) compared to count of
### rest of zips(False)
table(restData$zipCode %in% c("21212"))
### shows sum of count 21212+21213 (TRUE) vs rest of zips in data (False)
table(restData$zipCode %in% c("21212","21213"))
### Subsets using this logical. Returns info in rows with only 21212, 21213
restData[restData$zipCode %in% c("21212","21213"),]


## cross tabs

###loads generic dataset
data(UCBAdmissions)
###as.data.frame coerces data set into a data.frame
DF = as.data.frame(UCBAdmissions)
summary(DF)
### Freq is the variable you want displayed.
### xt will show the frequency with which males/females were
### admitted/rejected
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt


## flat tables

### This is just adding entries for the example
### warpbreak is a standard dataset
warpbreak$replicate <- rep(1:9, len=54)
### "~." means it's crosstabbing breaks with the rest of the variables
xt = xtabs(break ~., data=warpbreaks)
### creates the flat table
ftable(xt)


## size of a data set

fakeData = rnorm(1e5)
### size in bytes
object.size(fakeData)
### size in Megabytes
print(object.size(fakeData), units="Mb")