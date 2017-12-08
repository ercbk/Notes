#Hierarchical clustering

## Sections 1, 2, and 3 can be skipped. They're just showing
## different steps of how points get clustered. Also merging
## points sections: complete and average. They show how the 
## different linkages (metrics that determine cluster location)
## are calculated.

## Example

### generic fake data set
set.seed(1234); par(mar=c(0,0,0,0))
x <- rnorm(12,mean=rep(1:3,each=4),sd=0.2)
y <- rnorm(12,mean=rep(c(1,2,1),each=4),sd=0.2)
### plotting the dots
plot(x,y,col="blue",pch=19,cex=2)
### labeling the 12 dots
text(x+0.05,y+0.05,labels=as.character(1:12))


## dist

### Important parameters: x,method
### Calculating pair-wise distance
dataFrame <- data.frame(x=x,y=y)
dist(dataFrame)


## 1

###
suppressMessages(library(fields))
dataFrame <- data.frame(x=x,y=y)
rdistxy <- rdist(dataFrame)
diag(rdistxy) <- diag(rdistxy) + 1e5

# Find the index of the points with minimum distance
ind <- which(rdistxy == min(rdistxy),arr.ind=TRUE)
par(mfrow=c(1,2),mar=rep(0.2,4))
# Plot the points with the minimum overlayed
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05,y+0.05,labels=as.character(1:12))
points(x[ind[1,]],y[ind[1,]],col="orange",pch=19,cex=2)

# Make a cluster and cut it at the right height
distxy <- dist(dataFrame)
hcluster <- hclust(distxy)
dendro <- as.dendrogram(hcluster)
cutDendro <- cut(dendro,h=(hcluster$height[1]+0.00001) )
plot(cutDendro$lower[[11]],yaxt="n")


## 2

###
library(fields)
dataFrame <- data.frame(x=x,y=y)
rdistxy <- rdist(dataFrame)
diag(rdistxy) <- diag(rdistxy) + 1e5

# Find the index of the points with minimum distance
ind <- which(rdistxy == min(rdistxy),arr.ind=TRUE)
par(mar=rep(0.2,4))
# Plot the points with the minimum overlayed
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05,y+0.05,labels=as.character(1:12))
points(x[ind[1,]],y[ind[1,]],col="orange",pch=19,cex=2)
points(mean(x[ind[1,]]),mean(y[ind[1,]]),col="black",cex=3,lwd=3,pch=3)
points(mean(x[ind[1,]]),mean(y[ind[1,]]),col="orange",cex=5,lwd=3,pch=1)


## 3

###
library(fields)
dataFrame <- data.frame(x=x,y=y)
rdistxy <- rdist(dataFrame)
diag(rdistxy) <- diag(rdistxy) + 1e5

# Find the index of the points with minimum distance
ind <- which(rdistxy == rdistxy[order(rdistxy)][3],arr.ind=TRUE)
par(mfrow=c(1,3),mar=rep(0.2,4))
# Plot the points with the minimum overlayed
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05,y+0.05,labels=as.character(1:12))
points(x[c(5,6)],y[c(5,6)],col="orange",pch=19,cex=2)
points(x[ind[1,]],y[ind[1,]],col="red",pch=19,cex=2)

# Make dendogram plots
distxy <- dist(dataFrame)
hcluster <- hclust(distxy)
dendro <- as.dendrogram(hcluster)
cutDendro <- cut(dendro,h=(hcluster$height[2]) )
plot(cutDendro$lower[[10]],yaxt="n")
plot(cutDendro$lower[[5]],yaxt="n")


## hclust

###
dataFrame <- data.frame(x=x,y=y)
distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
plot(hClustering)


## Prettier Dendrograms (hierarchical tree)

###
myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
  ## modifiction of plclust for plotting hclust objects *in colour*!
  ## Copyright Eva KF Chan 2009
  ## Arguments:
  ##    hclust:    hclust object
  ##    lab:        a character vector of labels of the leaves of the tree
  ##    lab.col:    colour for the labels; NA=default device foreground colour
  ##    hang:     as in hclust & plclust
  ## Side effect:
  ##    A display of hierarchical cluster with coloured leaf labels.
  y <- rep(hclust$height,2); x <- as.numeric(hclust$merge)
  y <- y[which(x<0)]; x <- x[which(x<0)]; x <- abs(x)
  y <- y[order(x)]; x <- x[order(x)]
  plot( hclust, labels=FALSE, hang=hang, ... )
  text( x=x, y=y[hclust$order]-(max(hclust$height)*hang),
        labels=lab[hclust$order], col=lab.col[hclust$order], 
        srt=90, adj=c(1,0.5), xpd=NA, ... )
}


## Pretty dendrograms

###
dataFrame <- data.frame(x=x,y=y)
distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
myplclust(hClustering,lab=rep(1:3,each=4),lab.col=rep(1:3,each=4))


## Merging points - complete

###
dataFrame <- data.frame(x=x,y=y)
par(mar=rep(0.1,4))
plot(x,y,col="blue",pch=19,cex=2)
points(x[8],y[8],col="orange",pch=3,lwd=3,cex=3)
points(x[1],y[1],col="orange",pch=3,lwd=3,cex=3)
segments(x[8],y[8],x[1],y[1],lwd=3,col="orange")


## Merging points - average

###
dataFrame <- data.frame(x=x,y=y)
par(mar=rep(0.1,4))
plot(x,y,col="blue",pch=19,cex=2)
points(mean(x[1:4]),mean(y[1:4]),col="orange",pch=3,lwd=3,cex=3)
points(mean(x[5:8]),mean(y[5:8]),col="orange",pch=3,lwd=3,cex=3)
segments(mean(x[1:4]),mean(y[1:4]),mean(x[5:8]),mean(y[5:8]),lwd=3,col="orange")


## heatmap()

### Useful for mult-dim data frames/matrices with data that have
### similar scaling. Reorganizes row,cols according to clustering
### algorithm. Helps visualize large data sets. May be useful to
### reorganize columns according to the results.
dataFrame <- data.frame(x=x,y=y)
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
heatmap(dataMatrix)
