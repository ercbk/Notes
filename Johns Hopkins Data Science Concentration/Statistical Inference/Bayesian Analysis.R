# Bayesian Analysis



## Exploring the beta density
library(manipulate)
pvals <- seq(0.01, 0.99, length = 1000)
manipulate(
  plot(pvals, dbeta(pvals, alpha, beta), type = "l", lwd = 3, frame = FALSE),
  alpha = slider(0.01, 10, initial = 1, step = .5),
  beta = slider(0.01, 10, initial = 1, step = .5)
)



pvals <- seq(0.01, 0.99, length = 1000)
x <- 13; n <- 20
myPlot <- function(alpha, beta){
  plot(0 : 1, 0 : 1, type = "n", xlab = "p", ylab = "", frame = FALSE)
  lines(pvals, dbeta(pvals, alpha, beta) / max(dbeta(pvals, alpha, beta)), 
        lwd = 3, col = "darkred")
  lines(pvals, dbinom(x,n,pvals) / dbinom(x,n,x/n), lwd = 3, col = "darkblue")
  lines(pvals, dbeta(pvals, alpha+x, beta+(n-x)) / max(dbeta(pvals, alpha+x, beta+(n-x))),
        lwd = 3, col = "darkgreen")
  title("red=prior,green=posterior,blue=likelihood")
}
manipulate(
  myPlot(alpha, beta),
  alpha = slider(0.01, 100, initial = 1, step = .5),
  beta = slider(0.01, 100, initial = 1, step = .5)
)


## Question: Suppose that in a random sample of 
## an at-risk population 13 of 20 subjects had hypertension. 
## Estimate the prevalence of hypertension in this population.
## x = 13, n = 20

### two-sided confidence interval [lower, upper]
### default uses Jeffrey's prior (alpha=beta=0.5) and 
### 95% confidence level
library(binom)
binom.bayes(13, 20, type = "highest")
### mean (expected value) is 64%
bayes <- binom.bayes(13, 20, type = "highest")
binom.bayes.densityplot(bayes)


pvals <- seq(0.01, 0.99, length = 1000)
x <- 13; n <- 20
myPlot2 <- function(alpha, beta, cl){
  plot(pvals, dbeta(pvals, alpha+x, beta+(n-x)), type = "l", lwd = 3,
       xlab = "p", ylab = "", frame = FALSE)
  out <- binom.bayes(x, n, type = "highest", 
                     prior.shape1 = alpha, 
                     prior.shape2 = beta, 
                     conf.level = cl)
  p1 <- out$lower; p2 <- out$upper
  lines(c(p1, p1, p2, p2), c(0, dbeta(c(p1, p2), alpha+x, beta+(n-x)), 0), 
        type = "l", lwd = 3, col = "darkred")
}
manipulate(
  myPlot2(alpha, beta, cl),
  alpha = slider(0.01, 10, initial = 1, step = .5),
  beta = slider(0.01, 10, initial = 1, step = .5),
  cl = slider(0.01, 0.99, initial = 0.95, step = .01)
)