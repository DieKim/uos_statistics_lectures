# Chapter 8 Lab: Decision Trees

#1. Fitting Classification Trees; 오류 뜸 

library(tree)
library(ISLR)
attach(Carseats)

High=ifelse(Sales<=8,"No","Yes") #반응변수 Sales의 값 기준 분류
Carseats=data.frame(Carseats,High) #Carseats 데이터에 High변수 추가

tree.Carseats=tree(High~.-Sales,Carseats) #Sales 대신 High로 tree
summary(tree.carseats) #의사결정나무 요약; 과대적합된 원래 tree의 결과

plot(tree.carseats) #fitting된 나무 모형
text(tree.carseats,pretty=0) #값까지 추가해서 나무모형을 보여줌; 굉장히 복잡 
tree.carseats #그림으로된 tree를 text로 보여줌 

set.seed(2)
train=sample(1:nrow(Carseats), 200) #데이터 분할; 전체 데이터 중 200개 train 데이터
Carseats.test=Carseats[-train,] #test 데이터
High.test=High[-train]
tree.carseats=tree(High~.-Sales,Carseats,subset=train) #훈련데이터를 이용해 fitting
tree.pred=predict(tree.carseats,Carseats.test,type="class") #시험데이터 예측
table(tree.pred,High.test) #confusion matrix
(86+57)/200 #정분류율

set.seed(3)
cv.carseats=cv.tree(tree.carseats,FUN=prune.misclass)  
names(cv.carseats)
cv.carseats

par(mfrow=c(1,2))
plot(cv.carseats$size,cv.carseats$dev,type="b") #tree size별로 dev값 보여줌
plot(cv.carseats$k,cv.carseats$dev,type="b") #tree k값 별로 dev값 보여줌

prune.carseats=prune.misclass(tree.carseats,best=9) #best = 9
plot(prune.carseats) #아까보다 단순한 모형
text(prune.carseats,pretty=0) 
tree.pred=predict(prune.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(94+60)/200 #정분류율 향상

prune.carseats=prune.misclass(tree.carseats,best=15) #best값을 바꿈; 아까보다 복잡
plot(prune.carseats)
text(prune.carseats,pretty=0)
tree.pred=predict(prune.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(86+62)/200 #정분류율 떨어짐 

#2. Fitting Regression Trees

library(MASS)
set.seed(1)

train = sample(1:nrow(Boston), nrow(Boston)/2)
tree.boston=tree(medv~.,Boston,subset=train)
summary(tree.boston) #비교적 단순한 모형인 듯

plot(tree.boston)
text(tree.boston,pretty=0)

cv.boston=cv.tree(tree.boston)
plot(cv.boston$size,cv.boston$dev,type='b') #3까지가 가장 크게 감소
prune.boston=prune.tree(tree.boston,best=5) #5개정도에서 pruning
plot(prune.boston)
text(prune.boston,pretty=0)

yhat=predict(tree.boston,newdata=Boston[-train,]) #예측
boston.test=Boston[-train,"medv"]
plot(yhat,boston.test) #점 찍기
abline(0,1) #추세선 
mean((yhat-boston.test)^2) #mse

#3. Bagging and Random Forests

library(randomForest)
set.seed(1)

bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13,importance=TRUE) #모든 설명변수 사용; 배깅
bag.boston 
summary(bag.boston)

yhat.bag = predict(bag.boston,newdata=Boston[-train,]) #예측
plot(yhat.bag, boston.test) #점 찍기
abline(0,1) #추세선
mean((yhat.bag-boston.test)^2) #mse; 거의 반 정도 줄었음

bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13,ntree=25) #randomforest; 아마 배깅보다 나은 결과일 것
yhat.bag = predict(bag.boston,newdata=Boston[-train,])
mean((yhat.bag-boston.test)^2) #mse by 13개 모두 이용

set.seed(1)
rf.boston=randomForest(medv~.,data=Boston,subset=train,mtry=6,importance=TRUE) #6개만 이용; 더 나은 결과
yhat.rf = predict(rf.boston,newdata=Boston[-train,])
mean((yhat.rf-boston.test)^2) #mse; 향상된 값
importance(rf.boston)
varImpPlot(rf.boston)
#가장 설명력있는 변수; rm, lstat

#4. Boosting

library(gbm)
set.seed(1)

boost.boston=gbm(medv~.,data=Boston[train,],distribution="gaussian",n.trees=5000,interaction.depth=4) #교호작용 허용
summary(boost.boston) #각 변수별 상대적 중요도; lstat, rm이 가장 중요함 

par(mfrow=c(1,2))
plot(boost.boston,i="rm") #정비례
plot(boost.boston,i="lstat") #반비례

yhat.boost=predict(boost.boston,newdata=Boston[-train,],n.trees=5000) #예측
mean((yhat.boost-boston.test)^2) #mse; 더 향상된 값

boost.boston=gbm(medv~.,data=Boston[train,],distribution="gaussian"
                 ,n.trees=5000,interaction.depth=4,shrinkage=0.2,verbose=F) #shrinkage; 디폴트 1
yhat.boost=predict(boost.boston,newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-boston.test)^2) #mse; 조금 더 작아짐 

