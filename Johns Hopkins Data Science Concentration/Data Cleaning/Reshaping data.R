# Reshaping data



## Start with reshaping

### mtcars is a standard data set
library(reshape2)
head(mtcars)


## Melting data frames

### melt leaves the id variables alone but takes the measure variables
### and merges them into one column. The mpg rows are first and the hp
### rows are last.
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt)
tail(carMelt)


## Casting data frames

### dcast focuses the dataset even more by creating a dataset with just
### cylinder and the measured variables in the columns. The dataset is 
### ordered ascending according to cylinder
cylData <- dcast(carMelt, cyl~variable)
cylData
### values for the measured variables are now mean values.
cylData <- dcast(carMelt, cyl~variable,mean)
cylData


## Averaging values

### Standard dataset. Sprays - A,...,F, Count - number of insects you
### see with each different spray
head(InsectSprays)
### tapply sums up the counts for each spray
tapply(InsectSprays$count,InsectSprays$spray,sum)


## Another way - split

### makes a list of count values for each spray. Counts being split up
### according to the spray factor
spIns = split(InsectSpray$count,InsectSpray$spray)
spIns
### lapply sums up the count values for each spray. Each spray with its
### count sum is its own list
sprCount = lapply(spIns,sum)


## Another way - combine

### unlist takes all this lists and combines into one list (might
### be a vector)
unlist(sprCount)
### sapply doing the same thing one step quicker
sapply(spIns,sum)


## Another way - plyr package

### Accomplishes everything the "split, apply, combine" way does but
### in one line.
### ddply sums all the counts for each spray
### ( dataset, factor, action, how the action is taken)
ddply(InsectSprays,.(spray),summarize,sum=sum(count))


## Creating a new variable

### This is difficult to explain with words. Might have to execute the
### function to just see what it looks like.
### Useful if you want to calc sum-actualcount for each
### spray observation. Think Excel when you subtract columns.
### This produces a dataset with the same number of observations (rows)
### as the original dataset but in the sum column, each value is the total
### sum for each spray.
sprySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
head(spraySums)