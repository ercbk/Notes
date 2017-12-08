# Stochastic and Deterministic Trend models

## Data: total international visitors(millions) per year to Australia. 1980-2010. 


library(fma); library(fpp); library(forecast); library(ggplot2)
austa

### Deterministic Trend Model
### Model: Vistors = 0.42 + 0.17*time
### Interpretation: Estimate of growth of 0.17 million visitors per year.
fit <- auto.arima(austa,d=0,xreg=1:length(austa))
fit

### Stochaistic Trend Model (very similar to a random walk with drift except
### with ARMA errors instead of white noise)
### Interpretation: Estimate of growth of 0.15 million visitors per year.
### drift coef is what was interpreted
fit2 <- auto.arima(austa,d=1)
fit2

### Exact same model as fit2 which was chosen by auto.arima
fit3 <- Arima(austa, order=c(0,1,0), include.drift=TRUE)
fit3
### Exact same model as fit which was chosen by auto.arima
### Drift coef has same coeff as xreg in fit model
fit4 <- Arima(austa, order=c(2,0,0), include.drift=TRUE)
fit4

### PI in forecast for stochastic model(fit2,3) wider because error are nonstationary
par(mfrow=c(2,1))
plot(forecast(fit4), main="Forecasts from linear trend + AR(2) error",
     ylim=c(1,8))
plot(forecast(fit3), ylim=c(1,8))


