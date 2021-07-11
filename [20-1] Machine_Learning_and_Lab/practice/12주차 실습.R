# Chapter 9 Lab: Support Vector Machines

#1. Support Vector Classifier

#데이터 발생
set.seed(1)
x=matrix(rnorm(20*2), ncol=2)
y=c(rep(-1,10), rep(1,10))
x[y==1,]=x[y==1,] + 1
plot(x, col=(3-y)) 
dat=data.frame(x=x, y=as.factor(y)) #y값을 factor변수로 지정해야 분류문제; 아니면 회귀로 인식

install.packages("e1071")
library(e1071)

svmfit=svm(y~., data=dat, kernel="linear", cost=10, scale=FALSE) 
#전체데이터에 대해서 fitting
#kernel은 선형, cost는 C값(마진하고 관계)
#scale 옵션 중요; 웬만해선 안 하는 게 좋음
#scale을 할꺼면 전체데이터 다 하던지(훈련데이터, 시험데이터)
plot(svmfit, dat)
#+; 갈색, -; 노란색
#X; 지지벡터

svmfit$index #지지벡터가 몇 번인지 알려줌; 20개 데이터 중 7개
summary(svmfit) #선형적으로 분류가 잘 되었음을 확인; y가 factor변수여야 분류로 제대로 인식

svmfit=svm(y~., data=dat, kernel="linear", cost=0.1,scale=FALSE) #C값을 0.1로 줄임
plot(svmfit, dat) #아까에 비해 마진이 넓어짐
svmfit$index #지지벡터의 개수가 늘어남 

set.seed(1)
tune.out=tune(svm,y~.,data=dat,kernel="linear",ranges=list(cost=c(0.001, 0.01, 0.1, 1,5,10,100))) #튜닝
summary(tune.out) #best 값 = 0.1

bestmod=tune.out$best.model #best 모델을 뽑아서
summary(bestmod) #summary 확인

#또 데이터 생성(test data)
xtest=matrix(rnorm(20*2), ncol=2)
ytest=sample(c(-1,1), 20, rep=TRUE)
xtest[ytest==1,]=xtest[ytest==1,] + 1
testdat=data.frame(x=xtest, y=as.factor(ytest))

ypred=predict(bestmod,testdat) #test data에 대해서 예측 by best model
table(predict=ypred, truth=testdat$y) #confusion matrix; 1개만 오분류 

svmfit=svm(y~., data=dat, kernel="linear", cost=.01,scale=FALSE) #best값이 아닐 때 예측
ypred=predict(svmfit,testdat)
table(predict=ypred, truth=testdat$y) #오분류 개수가 늘어남; 2개

x[y==1,]=x[y==1,]+0.5 #데이터 변형
plot(x, col=(y+5)/2, pch=19) #변형된 데이터 한번 plot해봄; 아까보다 seperable
dat=data.frame(x=x,y=as.factor(y))

svmfit=svm(y~., data=dat, kernel="linear", cost=1e5) #C값이 크다 = 마진폭이 좁다
summary(svmfit) #지지벡터가 3개밖에 안 됨
plot(svmfit, dat) 

svmfit=svm(y~., data=dat, kernel="linear", cost=1) #C값이 작다 = 마진폭이 넓다
summary(svmfit) #지지벡터가 아까보다 늘었음
plot(svmfit,dat)

#2. Support Vector Machine

#데이터 생성
set.seed(1)
x=matrix(rnorm(200*2), ncol=2)
x[1:100,]=x[1:100,]+2
x[101:150,]=x[101:150,]-2
y=c(rep(1,150),rep(2,50))
dat=data.frame(x=x,y=as.factor(y))
plot(x, col=y) #비선형 경계

train=sample(200,100) #200개 중 100개를 train data; 나머지 test data

svmfit=svm(y~., data=dat[train,], kernel="radial",  gamma=1, cost=1) #감마보다 C값 잡는게 중요
plot(svmfit, dat[train,]) 
summary(svmfit) #지지벡터 37개

svmfit=svm(y~., data=dat[train,], kernel="radial",gamma=1,cost=1e5)
plot(svmfit,dat[train,]) 
summary(svmfit) #지지벡터 26개; 너무 과한 적합(overfitting)

set.seed(1)
tune.out=tune(svm, y~., data=dat[train,], kernel="radial", ranges=list(cost=c(0.1,1,10,100,1000),gamma=c(0.5,1,2,3,4)))
summary(tune.out) #best model; 12번째 모델 
table(true=dat[-train,"y"], pred=predict(tune.out$best.model,newdata=dat[-train,])) #best model에서의 confusion matrix
#100개 중 10개 오분류

#3. ROC Curves

install.packages("ROCR")
library(ROCR)

rocplot=function(pred, truth, ...){ #쓰기 편하게 함수로 코딩
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)}

svmfit.opt=svm(y~., data=dat[train,], kernel="radial",gamma=2, cost=1,decision.values=T) #튜닝 안 함 
fitted=attributes(predict(svmfit.opt,dat[train,],decision.values=TRUE))$decision.values #최적 모델에 대해서

par(mfrow=c(1,2))
rocplot(fitted,dat[train,"y"],main="Training Data")

svmfit.flex=svm(y~., data=dat[train,], kernel="radial",gamma=50, cost=1, decision.values=T) #gamma=50 일 때 더 좋아보임
fitted=attributes(predict(svmfit.flex,dat[train,],decision.values=T))$decision.values
rocplot(fitted,dat[train,"y"],add=T,col="red")

fitted=attributes(predict(svmfit.opt,dat[-train,],decision.values=T))$decision.values
rocplot(fitted,dat[-train,"y"],main="Test Data")

fitted=attributes(predict(svmfit.flex,dat[-train,],decision.values=T))$decision.values
rocplot(fitted,dat[-train,"y"],add=T,col="red")
#test data에서는 gamma가 1인 경우가 더 나아보임(50은 과대적합)

#4. SVM with Multiple Classes

#데이터 생성
set.seed(1)
x=rbind(x, matrix(rnorm(50*2), ncol=2))
y=c(y, rep(0,50))
x[y==0,2]=x[y==0,2]+2
dat=data.frame(x=x, y=as.factor(y))
par(mfrow=c(1,1))
plot(x,col=(y+1))

svmfit=svm(y~., data=dat, kernel="radial", cost=10, gamma=1)
plot(svmfit, dat) #다범주 분류

#5. Application to Gene Expression Data

#다범주 분류 예제
#y값을 factor 변수로 꼭 바꿔줘야 함 

library(ISLR)
names(Khan)

dim(Khan$xtrain)
dim(Khan$xtest)

length(Khan$ytrain)
length(Khan$ytest)

table(Khan$ytrain)
table(Khan$ytest)

#train data
dat=data.frame(x=Khan$xtrain, y=as.factor(Khan$ytrain))
out=svm(y~., data=dat, kernel="linear",cost=10)
summary(out)
table(out$fitted, dat$y)

#test data
dat.te=data.frame(x=Khan$xtest, y=as.factor(Khan$ytest))
pred.te=predict(out, newdata=dat.te)
table(pred.te, dat.te$y)

