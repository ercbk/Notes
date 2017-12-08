# Dynamic Regression, aka regression with ARIMA errors

## Data:  Percentage changes in quarterly personal consumption 
## expenditure and personal disposable income for the US, 1970 to 2010.

## Forecast changes in expenditure based on changes in income.
## In other words, measure the instantaneous effect of the average change
## of income on the average change of consumption expenditure

library(fma); library(fpp); library(forecast); library(ggplot2)
data("usconsumption")

### Step 1. data look stationary which is usually the case when we're dealing
### with percentage changes and not raw data. No differencing needed.
plot(usconsumption, xlab="Year",
     main="Quarterly changes in US consumption and personal income")

### Step 2.  Model assuming Ar(2) errors
fit <- Arima(usconsumption[,1], xreg=usconsumption[,2],
             order=c(2,0,0))
### Make sure you use the type= arg in ggtsdisplay or you won't get
### the correct plots.
### Plots indicate a AR(2)MA(3) model
ggtsdisplay(residuals(fit, type = "regression"), main = "Arima errors")

### Step 3. Fit the model and check the residuals
fit2 <- Arima(usconsumption[,1], xreg=usconsumption[,2],
              order=c(2,0,3))
fit2
### Ljung passed, histo looks decent, 1 spike at lag 14 which isn't quarterly
### so all in all forgivable.
checkresiduals(fit2)

### Step 4. See what auto.arima spits out.
fit3 <- auto.arima(usconsumption[,1], xreg=usconsumption[,2])

### Chooses an AR(1)MA(2) Same differencing so we can compare AICc
### This one's lower.
### Model: Expenditure = 0.5750 + 0.2420*Income
### Interpretation: A 1% avg increase in Income will result in a 0.817% avg
### increase in Expenditure
fit3
### Ljung pval even better, histo alright, still that pesky spike at
### lag 14. I'm thinking outlier.
checkresiduals(fit3)

### Step 5. Model good, let's forecast. We don't have any new income
### data so we're using the mean and forecasting out 8 quarters.
fcast <- forecast(fit3,xreg=rep(mean(usconsumption[,2]),8), h=8)
### Narrower intervals than just forecasting off of past expenditure because
### Income is explaining some of the variation.
autoplot(fcast,
     main="Forecasts from regression with ARIMA(1,0,2) errors")




### Alright for giggles I'm going to see if I can snuff out an outlier or two
fitC <- Arima(tsclean(usconsumption[,1]), xreg=tsclean(usconsumption[,2]),
             order=c(2,0,0))
fitC
### Hmm, showing some seasonality. I'd guess a (3,0,3)(1,0,0) with m=4
### or a (2,0,3)(1,0,0)
ggtsdisplay(residuals(fitC, type = "regression"), main = "Arima errors")

### There was no obvious need for differencing so I'm just going to go with
### auto.arima model
autoFitC <- auto.arima(tsclean(usconsumption[,1]), xreg=tsclean(usconsumption[,2]))
### ARIMA(2,0,2)(0,0,1)[4], I was off.
autoFitC
### Ljung test good, ACF plot great, histo much better
checkresiduals(autoFitC)
### Very close to zero
mean(residuals(autoFitC))
fcastC <- forecast(autoFitC,xreg=rep(mean(tsclean(usconsumption[,2])),8), h=8)
### point forecasts didn't really change and the PI is slightly more compact.
autoplot(fcastC)
### Seasonality makes me a little uneasy in this context so gun to my head, I'd 
### probably just stick with the (1,0,2).

