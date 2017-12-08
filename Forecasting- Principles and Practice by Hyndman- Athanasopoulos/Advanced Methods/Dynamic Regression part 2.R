# Dynamic Regression part 3

## Data: Monthly quotations and monthly television advertising 
## expenditure for a US insurance company. January 2002 to April 2005.

## '#' Hyndman, '###' me

library(fma); library(fpp); library(forecast); library(ggplot2)
insurance
plot(insurance, main="Insurance advertising and quotations", xlab="Year")

# Lagged predictors. Test 0, 1, 2 or 3 monthly lags.

str(insurance) ### 40 total obs
class(insurance) ### "mts" "ts"
Advert <- cbind(insurance[,2],
                c(NA,insurance[1:39,2]),
                c(NA,NA,insurance[1:38,2]),
                c(NA,NA,NA,insurance[1:37,2]))
colnames(Advert) <- paste("AdLag",0:3,sep="")
Advert
class(Advert) ### "mts"    "ts"     "matrix"

# Choose optimal lag length for advertising based on AIC
# Restrict data so models use same fitting period

### In other words, 4:40 is so every model is using same data set
### Would've thought each model would use a different col as a predictor
### but this process progressively adds cols/predictors.
### No nonseasonal differencing specified which looks reasonable
### after looking at the individual ts plots.

### xreg = lag0
fit1 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1], d=0)
### xreg = lag0 + lag1
fit2 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:2], d=0)
### xreg = lag0 + lag1 + lag2
fit3 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:3], d=0)
### xreg = lag0 + lag1 + lag2 + lag3
fit4 <- auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:4], d=0)
fit1; fit2; fit3; fit4
### fit2 is the best model (based on AICc)

### Fitting best model to all the quote data 
fit5 <- auto.arima(insurance[,1], xreg=Advert[,1:2], d=0)
### We aren't given the units for Advertising but lets assume is $1000.
### So interpretation: You can expect on average an increase of 1.2564 quotes
### for each $1000 spent in Advertising after the effects of advertising
### the previous month are accounted for. An average increase of .1625 quotes
### per $1000 of advertising spent the previous month after accounting for
### this months advertising expenditure.
fit5

### Forecasting quotes 20 months ahead with new advertising data.
### AdLag0 = 8 (so $8000 if we use our prev. assumption) repeated 20 times
### AdLag1 = first value = last value of the AdLag0 data (since it wasn't
###          included in the original AdLag1 column) and then 8 repeated
###          19 times.
fc8 <- forecast(fit5, xreg=cbind(rep(8,20),c(Advert[40,1],rep(8,19))), h=20)
plot(fc8, main="Forecast quotes with advertising set to 8", ylab="Quotes")

