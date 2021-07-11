### Q8 ###

#문제셋팅
library(ISLR)
library(tree)
library(randomForest)
set.seed(2020)

#8-(a); train, test data set으로 쪼개기
train = sample(dim(Carseats)[1], dim(Carseats)[1]/2)
car.train = Carseats[train, ]
car.test = Carseats[-train, ]

#8-(b)

#Fit a regression tree
tree.car = tree(Sales~., data = car.train)
summary(tree.car)

#Plot the tree
plot(tree.car)
text(tree.car, pretty=0)

#Interpret the results
#그림을 보아하니 ShelveLoc가 가장 중요한 변수
#또한 굉장히 복잡하므로 과대적합 예상

#test MSE
pred.car = predict(tree.car, car.test)
mean((car.test$Sales - pred.car)^2)

#8-(c)

#Use CV
cv.car = cv.tree(tree.car, FUN=prune.tree)
par(mfrow=c(1,2))
plot(cv.car$size, cv.car$dev, type="b")
plot(cv.car$k, cv.car$dev, type="b")
#best size는 6정도 되는 듯 하다.

#Pruning
pruned.car = prune.tree(tree.car, best = 6)
par(mfrow=c(1,1))
plot(pruned.car)
text(pruned.car, pretty=0)

#test MSE
pred.pruned = predict(pruned.car, car.test)
mean((car.test$Sales - pred.pruned)^2)
#시험 MSE값 상승. 즉, pruning이 test MSE를 향상시키지 못 했다.

#8-(d)

#Use the bagging 
bag.car = randomForest(Sales~., data=car.train, mtry=10, ntree=500,importance=T)
bag.car

#test MSE
pred.bag = predict(bag.car, car.test)
mean((car.test$Sales - pred.bag)^2)
#앞 두 결과의 거의 반 정도 되는 MSE
#가장 좋은 결과; low bias and reduced variance

#Which variables are most important
importance(bag.car)
varImpPlot(bag.car)
#Price와 ShelveLoc 변수가 가장 중요한 변수인 듯하다.

#8-(e)

#Use random forest
rf.car = randomForest(Sales~., data=car.train, mtry=6, ntree=500, importance = T)
rf.car

#test MSE
pred.rf = predict(rf.car, car.test)
mean((car.test$Sales - pred.rf)^2)

#Which variables are most important
importance(rf.car)
varImpPlot(rf.car)
#(d)에서와 마찬가지로 Price와 ShelveLoc 변수가 가장 중요한 변수이다.

#The effect of m
oob.err=double(10)
test.err=double(10)
for(mtry in 1:10){
  rf.car = randomForest(Sales ~ ., data = car.train
                             , mtry = mtry, ntree = 500, importance = T)
  oob.err[mtry]=rf.car$mse[500]
  pred.rf = predict(rf.car, car.test)
  test.err[mtry] = mean((car.test$Sales - pred.rf)^2)
  cat(mtry," ")
}
matplot(1:mtry, cbind(test.err,oob.err),pch=20
        , col=c("red","blue"), type="b", ylab="MSE")
test.err[which.min(test.err)]
importance(rf.car)

#test MSE는 mtry=6이될 때까지 감소
#변수 6개가 최적의 개수
#(d)에서와 마찬가지로 Price와 ShelveLoc 변수가 가장 중요한 변수


### Q11 ###

#11-(a)
train = 1:1000
Caravan$Purchase = ifelse(Caravan$Purchase =="Yes", 1, 0)
Caravan.train = Caravan[train, ]
Caravan.test = Caravan[-train, ]

#11-(b)
library(gbm)
boost.caravan = gbm(Purchase~., data=Caravan.train, distribution="gaussian", n.trees=1000, shrinkage=0.01)
summary(boost.caravan)
#PPERSAUT, MKOOPKLA가 가장 중요한 변수

#11-(c)
boost.prob = predict(boost.caravan, Caravan.test, n.trees = 1000, type = "response")
boost.pred = ifelse(boost.prob > 0.2, 1, 0)
table(Caravan.test$Purchase, boost.pred) #confusion matrix

12/(35+12) #정분류율

glm.caravan = glm(Purchase~., data=Caravan.train, family=binomial)
glm.prob = predict(glm.caravan, Caravan.test, type="response")
glm.pred = ifelse(glm.prob>0.2, 1, 0)
table(Caravan.test$Purchase, glm.pred)

58/(350+58) #정분류율; boosting 방법보다 작은 값 by logistic regression
