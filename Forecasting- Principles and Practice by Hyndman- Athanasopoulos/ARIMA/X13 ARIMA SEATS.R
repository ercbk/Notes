# X13 ARIMA SEATS

## pdf about seasonal pkg in Time Series folder
## pkg allows access to X13 through rstudio instead of through
## Census bureau's interface or command line



library(seasonal)
m <- seas(AirPassengers)
final(m)
plot(m)
summary(m)
