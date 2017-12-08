# Detect, replace outliers then forecast




library(tsoutliers); library(fpp); library(ggplot2)
### There is a peculier dip in the ts. Let's
### see if a couple functions detect it.
 
## Using tsoutliers pkg
outlier.milk <- tso(condmilk, types = c("AO","LS","TC"),maxit.iloop = 10)
outlier.milk
plot(outlier.milk)


## Using forecast pkg to est missing values; replace outliers

### Test for outliers
tsoutliers(condmilk)
## tsclean detects and replaces outliers with adjusted values
Ofit1 <- auto.arima(tsclean(condmilk))
Ofit2 <- auto.arima(tsclean(condmilk), D=1, d=1)
Ofit3 <- auto.arima(tsclean(condmilk), stepwise=F, approximation=F)
Ofit6 <- auto.arima(tsclean(condmilk), D=1, d=1, max.order=8, stepwise=F, approximation=F)
checkresiduals(Ofit6)
Ofcast6 <- forecast(Ofit6)
autoplot(Ofcast6)