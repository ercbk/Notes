# Creating New Variables



### Getting the data from the web
if(!file.exist("./data")){dir.creat("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destifile="./data/restaurants.csv",method="curl")
restData <- read.csv("./data/restaurants.csv")


## Creating sequences

### in notes
s1 <- seq(1,10,by=2); s1
s2 <- seq(1,10,length=3); s2
x <- c(1,3,8,25,100); seq(along=x)


## Subsetting variables

### Subsetting restaurants near where he lives
### nearMe variable is appended to the restaurant data set.
### restaurants in Roland Park and Homeland are subsetted from the
### dataset and a values of T or F assigned to nearMe
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
### %in% created a boolean. So the table is count of Trues and Falses
table(restData$nearMe)


## Creating binary variables

### zipWrong created. Conditional, ifelse, returns True or False
restData$zipWrong = ifelse(restData$zip<0, TRUE, FALSE)
### table shows kind of a cross tab. Negative zip code typo indicated.
table(restData$zipWrong, restData$zipCode<0)


## Creating categorical variables

### zipGroups created. cut breaks up the available zip codes into four
### groups using quantile (0%-25%, 25%-50%, 50%-75%, 75%-100%).
### zipGroups becomes a factor variable
restData$zipGroups = cut(restData$zipCode, breaks=quantile(restData$zipCode))
### shows restaurant counts for each quantile
table(restData$zipGroups)
### shows restaurant count breakdown: quantiles (rows) vs 
### each zip code (col)
table(restData$zipGroups,restData$zipCode)


## Easier cutting

### Alternate cut. Here you specify the number of groups you want.
### and the quantiles get automatically calc'ed. Equivalent to above.
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)


## Creating factor variables

### zipCode is an integer variable. zcf is the factor version.
restData$zcf <- factor(restData$zipCode)
### shows the first 10 zips and that overall zcf has 32 levels
restData$zcf[1:10]
### shows zcf is a factor
class(restData$zcf)


## levels of factor variables

### creating a dummy vector of yes,no's
yesno <- sample(c("yes","no"),size=10,replace=TRUE)
### making it into a factor with yes the lowest level
yesnofac = factor(yesno,levels=c("yes","no"))
### makes yes the reference value. Don't know why that's useful
relevel(yesnofac,ref="yes")
### coercing it into being numeric. Yes is lowest level, so it's a one 
### while no is a two
as.numeric(yesnofac)


## Using the mutate function

### new data.frame created. newDF = oldDF + 4 new variables
library(Hmisc); library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)