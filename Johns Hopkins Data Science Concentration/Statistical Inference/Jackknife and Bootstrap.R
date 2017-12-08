#Jackknife and Bootstrap

## Estimating the bias and Std Error of the median of sons' heights

### Data
library(UsingR)
data(father.son)
x <- father.son$sheight
n <- length(x)

## The hard way
### Showing guts of jackknife algorithm

theta <- median(x)
jk <- sapply(1 : n,
             function(i) median(x[-i])
)
thetaBar <- mean(jk)
biasEst <- (n - 1) * (thetaBar - theta) 
seEst <- sqrt((n - 1) * mean((jk - thetaBar)^2))
c(biasEst, seEst)


## The easy way 
library(bootstrap)
temp <- jackknife(x, median)
c(temp$jack.bias, temp$jack.se)


## Bootstrapping manually
B <- 1000
resamples <- matrix(sample(x,
                           n * B,
                           replace = TRUE),
                    B, n)
medians <- apply(resamples, 1, median)
sd(medians)
quantile(medians, c(.025, .975))

hist(medians)


## Bootstrap with bootstrap package

library(bootstrap)
### bootstrap requires a function to be passed to it representing the statistic
### to be calculated.
theta <- function(x) {median(x)}
results <- bootstrap(x, 1000, theta)
str(results)
sd(results$thetastar)
### Supposedly BCa CIs are better than these. Unfortuneately this pkg only has 
### a function that calcs limit pts for which I'm not sure how to convert 
### them into intervals.
quantile(results$thetastar, c(.025, .975))



## Bootstrap with the boot pkg

library(boot)
### Indexing vector. 1078 obs
d= c(1:1078)
### boot requires a function to be passed to it representing the statistic
### to be calculated. If its nonparametric, it needs two arguments. Hence
### the indexing vector.
sampleMedian <- function(x,d) {median(x[d])}
bootOut <- boot(x, sampleMedian, R=10000)
### bias and std error calc'd
bootOut
### t is the col vector with all the medians calc'ed for the simulated for 
### the datasets. 1st entry should be the original sample median.
head(bootOut$t)
sd(bootOut$t)
str(bootOut)
plot(bootOut)
### 1000 simulations wasn't enough for boot.ci to calc the CIs so bumped it up
### to R = 10000. With R = 10000, boot.ci took a few minutes to output using
### my tiny computer.
boot.ci(bootOut, conf = 0.95, type = "bca")
### Same CIs the quantile function spit out in the bootstrap pkg chunk. Maybe its
### better for other statistical uses. Saw a few in tutorials (bookmarked)
### and in the examples in the pkg documentation.

