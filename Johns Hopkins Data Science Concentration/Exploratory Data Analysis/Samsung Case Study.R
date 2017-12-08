# Samsung Case Study



## data uci machine learnig archive
## data from samsung phones' accelerometer, gyroscope.

## Getting a sense of the data

load("samsungData.rda")
### First 12 features (aka variables aka columns)
names(samsungData)[1:12]
class(samsungData$activity)
### lists the different kinds of entries for activity character
### variable and the counts for each.
table(samsungData$activity)


## Do some plots

### transforming character variable into a factor
samsungData <- transform(samsungData, activity = factor(activity))
### subject is a variable and each subject has over 300
### observations (rows). So subsetting just subject 1's data.
sub1 <- subset(samsungData, subject == 1)
### setting plotting parameters
par(mfrow = c(1,2), mar = c(5,4,0.5,1))
### plotting 1st col,"tBodyAcc-mean()-X" (mean body acceleration in
### the x direction)
### coloring by activity, y label is variable name
plot(sub1[, 1], col = sub1$activity, ylab = names(sub1)[1])
### plotting same thing but in y direction
plot(sub1[, 2], col = sub1$activity, ylab = names(sub1)[2])
legend("bottomright", legend = unique(sub1$activity), col = unique(sub1$activity), pch=1)
### shows only variability happening with the walking up,
### walking down, walking means. Rest are pretty stable


## Clustering Data by mean acceleration

### Sourcing custom clustering function
source("myplclust.R")
### calc'ing euclidean dist. between cols 1-3
distanceMatrix <- dist(sub1[, 1:3])
### hclust clusters and returns a list of lists
### "complete" linkage used for clustering
hclustering <- hclust(distanceMatrix)
### custom function makes everything pretty
### color tagged by activity
### Also note that (a copy of) activity gets unclassed
myplclust(hclustering, lab.col = unclass(sub1$activity))
### Dendrogram shows colors muddled so NO clear clustering.


## On to different variables...

### Now looking at max acceleration in the x and y directions,
### ("tBodyAcc-max()-X" and "tBodyAcc-max()-Y")
par(mfrow = c(1,2))
plot(sub1[, 10], pch = 19, col = sub1$activity, ylab = names(sub1)[10])
plot(sub1[, 11], pch = 19, col = sub1$activity, ylab = names(sub1)[11])
### again showing only variability happening with the walking up,
### walking down, walking means. Rest are pretty stable


## Clustering by max acceleration

source("myplclust.R")
distanceMatrix <- dist(sub1[, 10:12])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
### two pretty distinct clusters: moving activities vs non-moving
### activities. Individual activities still jumbled.


## SVD analysis

### running svd on every col except Subject, activity which are
### factors.
svd1 = svd(scale(sub1[, -c(562, 563)]))
par(mfrow = c(1,2))
## looking at the first and second left singular vectors
plot(svd1$u[, 1], col = sub1$activity, pch = 19)
plot(svd1$u[, 2], col = sub1$activity, pch = 19)
### 1st vector separates moving/nonmoving
### 2nd vector singles out magenta (walking up or 
### walking down?) for some reason


## Find maximum contributer (then cluster again)
## Which feature is contributing most to the variablity

### plotting 2nd right singular vector
plot(svd1$v[, 2], pch = 19)
### nothing really to take away from this

### which.max finds the index of the max value in
### the 2nd right singular vector which corresponds to
### variable 296, "fBodyAcc-meanFreq()-Z". This is part of
### what was produced from a Fast Fourier Transform applied
### to the data.
maxContrib <- which.max(svd1$v[, 2])
### dist calc'd according max accel and this new feature
distanceMatrix <- dist(sub1[, c(10:12, maxContrib)])
### hclust clusters using these features
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
### all the moving activities have clustered really nicely
### although the nonmoving are still jumbled.



## Kmeans


### six intial centroids
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6)
### shows the different activities that make-up each cluster
table(kClust$cluster, sub1$activity)
### Looking at clusters 3,6 shows kmeans also has problems
### separating out the different nonmoving activities.
### Random process so cluster numbers will change but the
### problem will remain

kClust <- kmeans(sub1[, -c(562, 563)], centers = 6, nstart = 100)
table(kClust$cluster, sub1$activity)
### adding nstart = 100 helps produce a more optimal result


## Looking at the center of the clusters
## Find which features drive the process of that center
## being chosen. This will give us an idea of the feature
## most important in classifying each pt to each cluster

### Taking a look at the cluster 1 center and features 1-10.
plot(kClus$center[1, 1:10], pch = 19, ylab = "Cluster Center", xlab = "")
### *sigh* he never explains how to analyze these. There
### are positive values and negative values.

### Overall we see moving activities can be described with
### just a few variables. Nonmoving will take further investigation.

