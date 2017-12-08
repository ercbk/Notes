# Plotting Predictors - wage data



## Investigating Wage data


library(ISLR); library(ggplot2); library(caret);
data(Wage)
### note in data: all male, all mid-Atlantic
summary(Wage)


inTrain <- createDataPartition(y=Wage$wage,
                               p=0.7, list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]
dim(training); dim(testing)


## Scouting for unusual relationship plot patterns

### snapshot of pairwise plots with 1 outcome var and  3 features vars
featurePlot(x=training[,c("age","education","jobclass")],
            y = training$wage,
            plot="pairs")

### scatterplot
### note big sliver of data above main group
qplot(age,wage,data=training)

## Examining this sliver of data further; trying to figure what features most
## capture it
### scatterplot- coloring according to jobclass(industrial, information)
### note most dots in sliver have information type job
qplot(age,wage,colour=jobclass,data=training)

### coloring according to education level
### note most of sliver is adv.degree or bachelors
qq <- qplot(age,wage,colour=education,data=training)
### adding linear regression lines for each education level
qq +  geom_smooth(method='lm',formula=y~x)


## Sometimes useful to cut up continuous vars into factor vars and 
## look at different relationships.
## Here it might be useful to group wage data into tax brackets

### Creating factor var, cutWage. (not tax brackets)
cutWage <- cut2(training$wage,g=3)
### showing number of obs. for each level
table(cutWage)

### 3 boxplots age vs each wage level
### easier to see upward trend than in scatterplot
p1 <- qplot(cutWage,age, data=training,fill=cutWage,
            geom=c("boxplot"))
p1


## sometimes box plots obscure number of points.
## if one or more of the plots have many fewer points then we'd
## be wary of validity of the observed trend

### overlaying the dots onto the boxplots
p2 <- qplot(cutWage,age, data=training,fill=cutWage,
            geom=c("boxplot","jitter"))
### presenting both type plots side by side
grid.arrange(p1,p2,ncol=2)

### seeing the number of information,industrial jobs at each wage level
t1 <- table(cutWage,training$jobclass)
t1
### gives proportion according to row (t1,2 would be column)
prop.table(t1,1)
### note majority of industrial jobs in lower group, info jobs in higher group

## density plots are best when you want to overlay different levels

### continuous var on xaxis, factor var is colored
### note bachelors, adv degrees bulk of high wage jobs
qplot(wage,colour=education,data=training,geom="density")


