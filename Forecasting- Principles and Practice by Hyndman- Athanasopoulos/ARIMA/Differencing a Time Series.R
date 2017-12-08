# Differencing a Time Series

## from time series ebook

library(fma); library(fpp)
data(a10)
### log stabalizes the variance
plot(diff(log(a10),12), xlab="Year",
     ylab="Annual change in monthly log A10 sales")

### generic code for finding the required number of differences that need
### to be taken to obtain a stationary ts and then doing it.
### Output, xstar, is a stationary time series.
ns <- nsdiffs(x)
if(ns > 0) {
  xstar <- diff(x,lag=frequency(x),differences=ns)
} else {
  xstar <- x
}
nd <- ndiffs(xstar)
if(nd > 0) {
  xstar <- diff(xstar,differences=nd)
}
