# Neural Net in Caret pkg


### ...something is terribly wrong. Getting 1's for all my preds and it's awful.

library(caret); library(fpp)
inTrain <- createDataPartition(y=credit$score,
                               p=0.9, list=FALSE)
training <- credit[inTrain,]; testing <- credit[-inTrain,]
n <- names(credit)
f <- as.formula(paste("score ~", paste(n[!n %in% c("score", "fte", "single")], collapse = " + ")))
controlObj <- trainControl(method="cv", number = 10)
modFit <- train(f, data=training, preProcess= c("center","scale"), method="nnet",
                trControl=controlObj)
print(modFit)
pred <- predict(modFit, newdata = testing)
qplot(score, pred, data=testing)
