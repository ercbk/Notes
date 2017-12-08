# Choosing bt ARIMA, ETS, or STLf part deux

## From fpp ebook Ch 8 exercises
## Data: Monthly sales of new one-family houses sold in the USA since 1973.
## "#" means Hyndman's comments. "###" is mine.

library(fpp); library(ggplot2)

# Questions 1&2. hsales


autoplot(hsales) # No transformation needed.
BoxCox.lambda(hsales) ### This recommends a lambda=0.1454608. May be important later.
adf.test(hsales, alternative = "stationary") ### trying some of the
### stationary tests
kpss.test(hsales)
### hmmph both tests claim ts is stationary. Wonder if this is why
### auto.arima keeps refusing to take differences.
ggtsdisplay(diff(hsales,12)) # seas. diff - Still looks non-stationary
ggtsdisplay(diff(diff(hsales,12))) # seas.diff, 1st diff - Looks stationary


fit1 <- auto.arima(hsales) # No differences! That looks odd.
fit2 <- auto.arima(hsales, D=1, d=1) # Use first and seasonal differences
fit1 ### ARIMA(1,0,0)(2,0,0)[12]
fit2 ### ARIMA(1,1,1)(2,1,0)[12]

checkresiduals(fit1) ### 1 spike at lag 20, passes LB test, hist looks fine
checkresiduals(fit2) ### spikes at lag 20, 36. test passed, hist normal
# Aussie says, Both models have residuals that look ok.
### 36 is a seasonal lag pt but it seems like as long as there aren't more
### than a couple spikes and LB test passed then it's all good.
autoplot(forecast(fit1))
autoplot(forecast(fit2))
# Hard to pick between these.
# I don't believe the data are stationary, so I'll go with model 2
### he's eyeballing this stuff to choose models. Really need train/test sets
### to have some objective evidence.


### looking at the similarities between forecasts
fcast1 <- forecast(fit1)
fcast2 <- forecast(fit2)
fcastEts <- forecast(ets(hsales))
df <- cbind(Arima=fcast1$mean, diffArima=fcast2$mean, ETS=fcastEts$mean)
autoplot(df)
# Almost no difference between the ARIMA(0,1,0)(0,1,2)[12] and ets models.
### I got a different model with auto.arima but same conclusion
# However, the ets model has poor residuals:
### I had 1 spike and a failed test. So hmm, he's either prioritizng test or
### the difference in our models is producing a different result in analyzing the acf.
### Both spikes not being at seasonal lags might be key and not that there are
### two significant spikes. Be interesting to see what he'd say with 3 spikes
### and a passed LB test.
checkresiduals(ets(hsales))
# So I would use the ARIMA model as the prediction intervals will be more reliable.



fit3 <- stlf(hsales, method="arima")
df2 <- cbind(df, stlf=fit3$mean)
autoplot(df2)
# Very close to the ARIMA forecasts
### From most to least conservative forecasts: 1. arima, 2. stl, 3. ets, 4 diff arima
checkresiduals(fit3)
# Strong seasonal correlations remaining.
### Oh yeah, strong patterns here. Residual plot doesn't look stationary. Spikes
### at seasonal lags of 12 and 24. Crashed and burned on the LB test.
# So I'd go with the ARIMA forecasts here.
### Yep I agree but I'm not totally sold on the need for differencing. So
### without a train/test comparison I'm ambivalent about both arima models





