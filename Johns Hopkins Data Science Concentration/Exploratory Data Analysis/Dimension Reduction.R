# Dimension Reduction



## Matrix data

### Random data
set.seed(12345); par(mar=rep(0.2,4))
dataMatrix <- matrix(rnorm(400),nrow=40)
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])


## Cluster the data

### Showing no pattern
par(mar=rep(0.2,4))
heatmap(dataMatrix)


## What if we add a pattern?

### +0 or 3 to entries of a random column
set.seed(678910)
for(i in 1:40){
  # flip a coin
  coinFlip <- rbinom(1,size=1,prob=0.5)
  # if coin is heads add a common pattern to that row
  if(coinFlip){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,3),each=5)
  }
}
par(mar=rep(0.2,4))
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])


## the clustered data

### Shows randomness in rows, pattern in columns
par(mar=rep(0.2,4))
heatmap(dataMatrix)

## Patterns in rows and columns

### remember hclust returns a list
hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]
par(mfrow=c(1,3))
### There's an odd transpose here. Entry [1,1] should
### stay the same but instead of the first entry of every column
### becoming the first entry of every row, it's the last entry
### of every column becoming the first entry of every row.
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
### Plots show pattern with both row means and column means
plot(rowMeans(dataMatrixOrdered),40:1,,xlab="Row Mean",ylab="Row",pch=19)
plot(colMeans(dataMatrixOrdered),xlab="Column",ylab="Column Mean",pch=19)


## Components of the SVD - $u$ and $v$

### see notebook
### Scale is subtracting each col entry by the col mean and 
### then dividing it by the col std dev
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
### At the very least, he's screwed up the naming of the axes.
### U's x and y axis labels need to be swapped.
### Otherwise, he's subsetted the 1st col from each matrix and
### labeled u's axis "row". In the SVD formula, V is transposed
### which he was messing with earlier in the code but there's
### a function that handles that, La.svd. So I don't know if
### he knows what he's doing here.
plot(svd1$u[,1],40:1,,xlab="Row",ylab="First left singular vector",pch=19)
plot(svd1$v[,1],xlab="Column",ylab="First right singular vector",pch=19)
### plots are useful for looking for patterns in the col (or
### row?) means.

## - Variance explained

### First plot shows raw values of D matrix. 
### Second plot divides each value by the total of all
### the values. This new value represents a percentage
### of the variance explained by that particular component(variable?)
par(mfrow=c(1,2))
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)


## Relationship to principal components

### Shows SVD and PCA analysis essentially the same thing
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered,scale=TRUE)
plot(pca1$rotation[,1],svd1$v[,1],pch=19,xlab="Principal Component 1",ylab="Right Singular Vector 1")
abline(c(0,1))


## Components of the SVD - variance explained

### Matrix of 0s and 1s. Nothing interesting
constantMatrix <- dataMatrixOrdered*0
for(i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <- rep(c(0,1),each=5)}
svd1 <- svd(constantMatrix)
par(mfrow=c(1,3))
image(t(constantMatrix)[,nrow(constantMatrix):1])
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)


## What if we add a second pattern?

### adds pattern to rows and cols
set.seed(678910)
for(i in 1:40){
  # flip a coin
  coinFlip1 <- rbinom(1,size=1,prob=0.5)
  coinFlip2 <- rbinom(1,size=1,prob=0.5)
  # if coin is heads add a common pattern to that row
  if(coinFlip1){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),each=5)
  }
  if(coinFlip2){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),5)
  }
}
hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]


## Singular value decomposition - true patterns

### Image is the data w/pattern
### (The Truth) plots made with patterns (shift, alternating)
### already known. This is just something to compare the SVD
### analysis in the next section to.
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rep(c(0,1),each=5),pch=19,xlab="Column",ylab="Pattern 1")
plot(rep(c(0,1),5),pch=19,xlab="Column",ylab="Pattern 2")


## $v$ and patterns of variance in rows

### SVD picks up the patterns but not very well
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd2$v[,1],pch=19,xlab="Column",ylab="First right singular vector")
plot(svd2$v[,2],pch=19,xlab="Column",ylab="Second right singular vector")


## $d$ and variance explained

### 2nd plot (varianced explained plot) shows over 50%
### of variance explained by the first component (shift).
### Alternating pattern not picked up. 
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,2))
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Percent of variance explained",pch=19)


## Missing values

### SVD doesn't run if there are NAs
dataMatrix2 <- dataMatrixOrdered
## Randomly insert some missing data
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
svd1 <- svd(scale(dataMatrix2))  ## Doesn't work!


## Imputing {impute}

### impute averages k nearest neighbors of the NA value and
### replaces that NA with the calc'd average value.
library(impute)  ## Available from http://bioconductor.org
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
dataMatrix2 <- impute.knn(dataMatrix2)$data
svd1 <- svd(scale(dataMatrixOrdered)); svd2 <- svd(scale(dataMatrix2))
par(mfrow=c(1,2)); plot(svd1$v[,1],pch=19); plot(svd2$v[,1],pch=19)


## Face example

### This example sorta shows how video compression works.
### Uses first few singular value vectors to approximate the
### original dataset. SVD used to choose these vectors (Dmatrix)
load("data/face.rda")
image(t(faceData)[,nrow(faceData):1])


## - variance explained

svd1 <- svd(scale(faceData))
plot(svd1$d^2/sum(svd1$d^2),pch=19,xlab="Singular vector",ylab="Variance explained")


## - create approximations

svd1 <- svd(scale(faceData))
### Note that %*% is matrix multiplication
### Here svd1$d[1] is a constant
approx1 <- svd1$u[,1] %*% t(svd1$v[,1]) * svd1$d[1]

### In these examples we need to make the diagonal matrix out of d
approx5 <- svd1$u[,1:5] %*% diag(svd1$d[1:5])%*% t(svd1$v[,1:5]) 
approx10 <- svd1$u[,1:10] %*% diag(svd1$d[1:10])%*% t(svd1$v[,1:10])


## - plot approximations

par(mfrow=c(1,4))
image(t(approx1)[,nrow(approx1):1], main = "(a)")
image(t(approx5)[,nrow(approx5):1], main = "(b)")
image(t(approx10)[,nrow(approx10):1], main = "(c)")
image(t(faceData)[,nrow(faceData):1], main = "(d)")  ## Original data
