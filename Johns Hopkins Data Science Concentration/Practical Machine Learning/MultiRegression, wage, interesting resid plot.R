# MultiRegression, wage

## predicting wage




library(ISLR); library(ggplot2); library(caret);
### log wage removed
data(Wage); Wage <- subset(Wage,select=-c(logwage))
summary(Wage)


inTrain <- createDataPartition(y=Wage$wage,
                               p=0.7, list=FALSE)
training <- Wage[inTrain,]; testing <- Wage[-inTrain,]
dim(training); dim(testing)


### pairwise plot
featurePlot(x=training[,c("age","education","jobclass")],
            y = training$wage,
            plot="pairs")

### note group of points about main group
qplot(age,wage,data=training)
### coloring dots with different factors might help reveal what's happening
qplot(age,wage,colour=jobclass,data=training)
qplot(age,wage,colour=education,data=training)

### fitting model with age, jobclass, ed as indicator variables
modFit<- train(wage ~ age + jobclass + education,
               method = "lm",data=training)
finMod <- modFit$finalModel
print(modFit)

### residual vs fitted plot - would like to see random around zero line
### shows a few outliers (with row#s I think) that may need
### further investigation
plot(finMod,1,pch=19,cex=0.5,col="#00000010")
### coloring to investigate outliers, race may be another predictor
qplot(finMod$fitted,finMod$residuals,colour=race,data=training)


## residuals vs order plot

### shows interesting pattern: group of outliers suggests a missing
### variable in our models; upward trend (I don't see one
### but I guess he does) suggests that variable or another
### is time-based or some other continuous variable.
plot(finMod$residuals,pch=19)

## predicted vs observed 

### analyzing this plot is only to used as a sort of postmordum.
### Can't be used to go back retrain model on the same data.
### Ideally data pts would line up on the y=x line
pred <- predict(modFit, testing)
qplot(wage,pred,colour=year,data=testing)

### showing same type of plot but using all predictors in the model
modFitAll<- train(wage ~ .,data=training,method="lm")
pred <- predict(modFitAll, testing)
qplot(wage,pred,data=testing)

