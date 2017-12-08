# Forecasting, time series, google stock data, quantmod






library(quantmod); library(forecast)
from.dat <- as.Date("01/01/08", format="%m/%d/%y")
to.dat <- as.Date("12/31/13", format="%m/%d/%y")
getSymbols("GOOG", src="yahoo", from = from.dat, to = to.dat)
head(GOOG)

### For some reason when converting to monthly, GOOG data from src = 
### "google" gets the error message below but when src="yahoo" everything 
### is fine.

### "Error in `index<-.xts`(`*tmp*`, value = integer(0)) : 
### unsupported 'index' index type of class 'integer'
### In addition: Warning message:
###  In to.period(x, "months", indexAt = indexAt, name = name, ...) :
###  missing values removed from data"

### convert to monthly data
mGoog <- to.monthly(GOOG)
### subset the opening prices
googOpen <- Op(mGoog)
### Need to convert from xts to ts obj for decompose() to work
### Also window() needs to have a ts obj
ts1 <- ts(googOpen,frequency=12)

plot(ts1,xlab="Years+1", ylab="GOOG")
### plot(googOpen) works as well

### Observed = plot above(?), trend = shows smoothed data (possibly 12mo moving avg)
### seasonality = observed with trend removed, obs-trend; random = noise after
### trend+seasonality removed from observed, obs-(trend+seasonality). 
plot(decompose(ts1),xlab="Years+1")
### plot not really useful for forecasting. Just used to get a sense of the data.
### above is an additive decomposition. If multiplicative then seasonality= obs/trend
### (see notes on ARIMA or bookmarked ARIMA tutorial)

### Separating test and train data
### We have 6 yrs so 6 rows of data. For test, start= 1st elt, 1st row, end = 
### 1st elt, 5th row. For test, start= 1st elt, 5th row, end= last elt, 6th row
### He didn't need 7 - 0.01, could've just used 7.
### The way he separates here he has 1 elt common to both train and test.
### Maybe there's a reason for this but it goes against what's been prev. taught.
ts1Train <- window(ts1,start=1,end=5)
ts1Test <- window(ts1,start=5,end=(7-0.01))
ts1Train
### Below is an even split (66%/33%) train= 2008-2011, test= 2012-2013
### Start = first 4 rows, end = last two rows
### ts1Train4 <- window(ts1,start=1,end=(5-.01))
### ts1Test4 <- window(ts1,start=5,end=7)


plot(ts1Train)
lines(ma(ts1Train,order=3),col="red")


ets1 <- ets(ts1Train,model="MMM")
fcast <- forecast(ets1)
plot(fcast); lines(ts1Test,col="red")


accuracy(fcast,ts1Test)


