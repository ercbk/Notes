# Vector autoregressions



library(vars)
VARselect(usconsumption, lag.max=8, type="const")$selection
var <- VAR(usconsumption, p=3, type="const")
serial.test(var, lags.pt=10, type="PT.asymptotic")
summary(var)

fcst <- forecast(var)
plot(fcst, xlab="Year")
