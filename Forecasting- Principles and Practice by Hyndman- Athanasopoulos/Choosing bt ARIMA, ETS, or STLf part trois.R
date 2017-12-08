# Choosing bt ARIMA, ETS, or STLf part trois

## From fpp ebook Ch 8 exercises
## Data: Monthly total generation of electricity by the U.S. electric industry (Jan 1985 - Oct 1996.
## "#" means Hyndman's comments. "###" is mine.


library(fpp); library(ggplot2)

# Questions 1&2. uselec

autoplot(uselec) # No transformation needed.
BoxCox.lambda(uselec) ### negative value, agree
ggtsdisplay(diff(uselec,12)) # Looks roughly stationary
### Yeah roughly is right. Think there's a taboo against a 2 seasonal
### difference but I might try one and/or 1st difference just to see.


fit1 <- auto.arima(uselec) # One seasonal difference chosen. Looks ok
fit2 <- auto.arima(uselec, approximation=FALSE, stepwise=FALSE) 
fit1 ### ARIMA(2,0,1)(0,1,1)[12] with drift
fit2 ### ARIMA(1,0,2)(0,1,1)[12] with drift - better AICc
checkresiduals(fit1) ### gd ACF, LB. histogram okay
checkresiduals(fit2) ### ditto
# Both models have residuals that look ok.
# But AIC much better for model 2.
autoplot(forecast(fit1))
autoplot(forecast(fit2))
# Hard to pick between these.
# But I'll go with model 2 on the basis of the AIC value
### Agree


ETSfcast <- forecast(ets(uselec))
fcast <- forecast(fit1)
fcast2 <- forecast(fit2)
df <- cbind(arima=fcast$mean, seas.arima=fcast2$mean, ets= ETSfcast$mean)
autoplot(df)
# Little difference between the ARIMA(1,0,2)(0,1,1)[12] and ets models.
### Yeah and both arimas are virtually on top of each other

checkresiduals(ets(uselec))
# Ugly. Go with the ARIMA model here.
### Ugly is a little harsh, but the LB score is very bad. 1 spike on ACF.


fit3 <- stlf(uselec, method="arima")
df2 <- cbind(df, stlf=fit3$mean)
autoplot(df2)
# Close to the ARIMA forecasts
### A little more ambitious than the arima forecasts
checkresiduals(fit3)
# Strong seasonal correlations remaining.
# So I'd go with the either the ARIMA forecasts here.
### Agree, spikes at lags 12,24

