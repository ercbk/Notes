# Choosing between ARIMA, ETS, or STLf models

## From fpp ebook Ch 8 exercises
## Data: Manufacturer's Stocks of evaporated and sweetened condensed milk
## "#" means Hyndman's comments. "###" is mine.


### I really went through a lot of the toolbox here.
### Easy to get lost in this script but ultimately I'd go with Ofit6 although
### I didn't attempt all the different hybrid combinations.

### Made comment under fit8 about PIs reaching into the negative region.

### Still haven't figured out why hybrids giving funky ACF plots



library(fpp); library(ggplot2); library(forecastHybrid)
data("condmilk")

autoplot(condmilk) # No transformation needed.
ggtsdisplay(diff(condmilk,12)) # seasonal diff; Still looks non-stationary
ggtsdisplay(diff(diff(condmilk,12))) # seasonal diff then 1st diff; Looks stationary
fit1 <- auto.arima(condmilk) # No differences! That looks odd.
fit2 <- auto.arima(condmilk, D=1, d=1) # Use first and seasonal differences
fit3 <- auto.arima(condmilk, stepwise=F, approximation=F) 
fit1 ### As the Aussie said no differencing. ARIMA(1,0,0)(2,0,0)[12]
fit2 ### Best AICc
fit3 ### # Produced a bloody ARIMA(2,0,2) (still no differencing!!). AICc lower but not best.

checkresiduals(fit1) ### 1 spike, passed LB test
checkresiduals(fit2) ### all clear, passed LB test
checkresiduals(fit3) ### couple spikes, failed LB test
# Both models have residuals that look ok. // histograms don't look
# the greatest to me.


## This is the old way. Don't know if its my small screen or what but
## this way always gives me errors. Have to repeatedly use dev.off()
## the par(mar=c(1,1,1,1)) and reexecute tsdisplay. Still gives me
## error but does plot allbeit without yaxis values. checkresiduals
## gives you everything you want except the PACF I guess.
# res1 <- residuals(fit1)
# res2 <- residuals(fit2)
# tsdisplay(res1)
# tsdisplay(res2)
# Box.test(res1, fitdf=5, lag=24, type="Lj")
# Box.test(res2, fitdf=6, lag=24, type="Lj")


fcast1 <- forecast(fit1)
fcast2 <- forecast(fit2)
fcast3 <- forecast(fit3)
autoplot(fcast1)
autoplot(fcast2)
autoplot(fcast3)
# Forecasts from model2 look like they have captured the seasonal fluctuations better
# as you would expect given model 1 has no seasonal differencing.


ets1 <- ets(condmilk)
ets1
checkresiduals(ets1) ### 3 spikes, failed LB test
fETS <- forecast(ets1)
autoplot(fETS)
# I think the ARIMA model looks more likely. Note the top of the peaks of
# the ets forecasts are lower than any historical peaks. 
### //I see similar peaks,but I do notice ARIMA PIs in the negative value
### range. Maybe it's just a no-no for the point forecasts but seems
### like that'd be a bit of red flag. ETS residuals not encouraging.
### He didn't look at the #TS resids originally. Why? Seems like ACF/LB test
### would still apply.


fit4 <- stlf(condmilk, method="arima")
fSTLf <- forecast(fit4)
autoplot(fSTLf)
# Not far off the ARIMA forecasts
checkresiduals(fit4)
# Strong seasonal correlations remaining. // Yep, agree.
# So I'd go with the ARIMA forecasts here.// Dunno, gun to head, ARIMA.


BoxCox.lambda(condmilk) ### Trying to eliminate those negative PIs
### negative lambda but going to see what happens anyways
fit5 <- auto.arima(condmilk, D=1, d=1, lambda = 0)
fit5
checkresiduals(fit5) ## clear and passes
fcast5 <- forecast(fit5)
autoplot(fcast5) ## kind of ugly, lopsided uncertainty above and 
## sort of truncated below. Don't know how to judge this model.

### Haven't really experimented with this package to know how it
### works.
tsoutliers(condmilk) ### There is a peculier dip in the ts. Let's
### see if a couple functions detect it.
library(tsoutliers)
outlier.milk <- tso(condmilk, types = c("AO","LS","TC"),maxit.iloop = 10)
outlier.milk
plot(outlier.milk)

## Using forecast pkg to est missing values; replace outliers
Ofit1 <- auto.arima(tsclean(condmilk))
Ofit2 <- auto.arima(tsclean(condmilk), D=1, d=1)
Ofit3 <- auto.arima(tsclean(condmilk), stepwise=F, approximation=F)
### Ofit6 is best in show vs fit2, Ofit2.
Ofit6 <- auto.arima(tsclean(condmilk), D=1, d=1, max.order=8, stepwise=F, approximation=F)
### Damn PIs are still in negative region though. I need to
### ask someone sometime. I'm done messing with it for now though.
Ofcast6 <- forecast(Ofit6)
autoplot(Ofcast6)

## Hybrid arima, ets model
library(forecastHybrid)
fit7 <- hybridModel(condmilk, models = "ae")
fit7
par(mar=c(1,1,1,1))
plot(fit7)
res1 <- residuals(fit7)
### Funky funky plot. Don't understand what's going on here
Acf(res1)


fit8 <- hybridModel(tsclean(condmilk), models = "ae", a.args = list(D=1, d=1, max.order=8, stepwise=F, approximation=F))
par(mar=c(1,1,1,1))
plot(fit8)
res2 <- residuals(fit8)
### Same funky plot
Acf(res2)
hyFcast <- forecast(fit8)
hyFcast
### Still have negative values in the PI zones. Thinking this isn't a problem since
### PIs get larger (when differencing in model) as the forecasting window gets larger. 
### Think this just speaks to the limits of forecasting over longer periods
autoplot(hyFcast)

### lambda = negative so still no transformation needed
BoxCox.lambda(tsclean(condmilk))
## Using cross valadation errors to weight more effective models more heavily
fit9cv <- hybridModel(tsclean(condmilk), models = "ae", a.args = list(D=1, d=1, max.order=8, stepwise=F, approximation=F),weights = "cv.errors")
fcast9cv <- forecast(fit9cv)
autoplot(fcast9cv$ets)
autoplot(fcast9cv$auto.arima)


## Visualizing the trend forecasted from different models vs data

train <- window(condmilk, end=c(1977,12))
test <- window(condmilk, start=c(1978,1))

h <- length(test) ### horizon
Ofcast6 <- forecast(auto.arima(tsclean(train), D=1, d=1, max.order=8, stepwise=F, approximation=F), h=h)
Hyfcast8 <- forecast(hybridModel(tsclean(train), models = "ae",
                                 a.args = list(D=1, d=1, max.order=8, stepwise=F, approximation=F)), h=h)
Hyfcast9cv <- forecast(hybridModel(tsclean(train), models = "ae",
                                  a.args = list(D=1, d=1, max.order=8, stepwise=F, approximation=F),
                                  weights = "cv.errors", windowSize= 50, cvHorizon = 16, verbose=T), h=h)
### Restriction for cv.errors: length(timeseries) > length(windowSize) + 2 * length(cvHorizon).
### So I wanted 60% train, 40% test, therefore 84 > 50 + 2 * 16. I don't
### know if this is the correct way but I finally got this to work. A question
### for another time.

X <- cbind(ARIMA=Ofcast6$mean, HybridAE=Hyfcast8$mean, hybridCV=Hyfcast9cv$mean)
df <- cbind(condmilk, X)
colnames(df) <- c("Data","ARIMA","ETS-ARIMA","hybrid-CV")
autoplot(df) + 
  xlab("Year") + ylab(expression("Manufacturer's Stocks of evaporated and sweetened condensed milk."))

### Interesting graph if I could maybe zoom in on parts. You can sort of eyeball
### that Arima matches the data slightly more.

accuracy(Ofcast6, test)
accuracy(Hyfcast8, test)
accuracy(Hyfcast9cv, test)

### Training set: RMSE: 1. Hyfcast9cv, 2. Hyfcast8, 3. Ofcast6
###               MASE: 1. Hyfcast8,   2. Ofcast6,  3. Hyfcast9cv
### Test set: MASE,RMSE: 1. Ofcast6, 2. Hyfcast8, 3. Hyfcast9cv

### Arima pwnd the hybrids pretty hard on the test sets which shouldn't be the case.
### Options that might produce a better outcome for hybrids: set a different
### benchmarking error when training the models; include more and/or different
### algorithms in the hybrids than the ones I used (ets,arima); use different weights.
### Also looking back, ets failing residuals test should've been a clue. Shouldn't have
### included in my hybrids but I've just been trying to see if I can get these functions
### to work.

