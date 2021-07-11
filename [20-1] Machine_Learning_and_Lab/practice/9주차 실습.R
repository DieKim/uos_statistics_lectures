### 9주차 실습 ###

### Chapter 6 Lab 1: Subset Selection Methods

#1. Best Subset Selection

library(ISLR)

?Hitters #Hitters data 확인
fix(Hitters) #Hitters data 표
names(Hitters) #Hitters data 변수

dim(Hitters) #Hitters data 관측, 변수 수
sum(is.na(Hitters$Salary)) #결측치 개수 확인

Hitters=na.omit(Hitters) #결측치 제거
dim(Hitters)
sum(is.na(Hitters))

#라이브러리 설치
install.packages("leaps")
library(leaps)

regfit.full=regsubsets(Salary~.,data=Hitters) #최적부분집합선택
summary(regfit.full)

regfit.full=regsubsets(Salary~.,data=Hitters,nvmax=19) #nvmax; 전체 변수 개수
reg.summary=summary(regfit.full) #중간에 짤리지 않고 full model의 결과

reg.summary
names(reg.summary) #summary의 변수
reg.summary$rsq #변수 rsq(r-square)값 

#2 by 2 그래프 만들기
par(mfrow=c(2,2)) 

#1
plot(reg.summary$rss,xlab="Number of Variables",ylab="RSS",type="l") #RSS; Residual Sum of Squares
#2
plot(reg.summary$adjr2,xlab="Number of Variables",ylab="Adjusted RSq",type="l") #Adjusted R^2
which.max(reg.summary$adjr2) #Adjr2의 최대값
points(11,reg.summary$adjr2[11], col="red",cex=2,pch=20) #최대값 빨간점으로 찍기
#3
plot(reg.summary$cp,xlab="Number of Variables",ylab="Cp",type='l') #C_p
which.min(reg.summary$cp) #C_p의 최소값
points(10,reg.summary$cp[10],col="red",cex=2,pch=20) #최소값 빨간점으로 찍기
#4
plot(reg.summary$bic,xlab="Number of Variables",ylab="BIC",type='l') #BIC
which.min(reg.summary$bic) #BIC의 최소값
points(6,reg.summary$bic[6],col="red",cex=2,pch=20) #최소값 빨간점으로 찍기

#그래프 확인 결과, BIC가 다른 방법들보다 적은 변수 개수를 선택

#fitting된 결과로 계수 plot을 그려봄
plot(regfit.full,scale="r2")
plot(regfit.full,scale="adjr2")
plot(regfit.full,scale="Cp")
plot(regfit.full,scale="bic")

coef(regfit.full,6) #변수가 6개일 때 최소인 bic가 선택한 변수 확인

#2. Forward and Backward Stepwise Selection

#method="forward"; 전진선택법
regfit.fwd=regsubsets(Salary~.,data=Hitters,nvmax=19,method="forward")
summary(regfit.fwd)
#method="backward"; 후진선택법
regfit.bwd=regsubsets(Salary~.,data=Hitters,nvmax=19,method="backward")
summary(regfit.bwd)

#각 방법의 변수와 계수 추정치
coef(regfit.full,7) #최적부분집합선택법
coef(regfit.fwd,7) #전진선택법
coef(regfit.bwd,7) #후진선택법

#3. Choosing Among Models

#train/test data로 나눠서 분석
set.seed(1)
train=sample(c(TRUE,FALSE), nrow(Hitters),rep=TRUE) #반반으로 나누기
test=(!train)

regfit.best=regsubsets(Salary~.,data=Hitters[train,],nvmax=19) #train에 대해서 best- 
test.mat=model.matrix(Salary~.,data=Hitters[test,]) #test에 대해서 x값들을 뽑아놓기
#나중에 추정계수랑 곱해서 예측값을 얻기 위해서(?)

val.errors=rep(NA,19) #model size=19
for(i in 1:19){ #결과에 대해서 예측값과 error 구하기
  coefi=coef(regfit.best,id=i)
  pred=test.mat[,names(coefi)]%*%coefi
  val.errors[i]=mean((Hitters$Salary[test]-pred)^2)
}
val.errors

which.min(val.errors) #최소가 되는 p=10
coef(regfit.best,10) #10개의 변수와 추정치 확인

predict.regsubsets=function(object,newdata,id,...){ #앞서 분석을 함수화
  form=as.formula(object$call[[2]])
  mat=model.matrix(form,newdata)
  coefi=coef(object,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}

#모델사이즈 10개가 최적으로 선택됨
#최종예측;train, test로 나눴던 데이터를 다시 하나로 합쳐서 분석

#최종예측에 사용할 모델
regfit.best=regsubsets(Salary~.,data=Hitters,nvmax=19)
coef(regfit.best,10)

k=10 #10-fold CV
set.seed(1)
folds=sample(1:k,nrow(Hitters),replace=TRUE) #fold값 생성

cv.errors=matrix(NA,k,19, dimnames=list(NULL, paste(1:19))) 
for(j in 1:k){ #cv error값 구하는 loop
  best.fit=regsubsets(Salary~.,data=Hitters[folds!=j,],nvmax=19)
  for(i in 1:19){
    pred=predict(best.fit,Hitters[folds==j,],id=i)
    cv.errors[j,i]=mean( (Hitters$Salary[folds==j]-pred)^2)
  }
}

mean.cv.errors=apply(cv.errors,2,mean) #10개의 평균
mean.cv.errors

par(mfrow=c(1,1)) #plot
plot(mean.cv.errors,type='b')

#최종모형의 계수 추정
reg.best=regsubsets(Salary~.,data=Hitters, nvmax=19)
coef(reg.best,11)


### Chapter 6 Lab 2: Ridge Regression and the Lasso
### 이부분 라이브러리 설치 안 돼서 못 함###

#축소추정법 by glmnet; glmnet을 사용하려면 input을 x, y로 가공해야 함
x=model.matrix(Salary~.,Hitters)[,-1]
y=Hitters$Salary

#1. Ridge Regression; 능형회귀

#라이브러리 설치; 안 됨... 지금 버전에서 안 되는 듯
install.packages("glmnet")
install.packages("glmnet",repos="http://cran.us.r-project.org")

library(glmnet)
grid=10^seq(10,-2,length=100) #gird값 잡기

ridge.mod=glmnet(x,y,alpha=0,lambda=grid) #alpha=0; Ridge
dim(coef(ridge.mod)) #20 100 

ridge.mod$lambda[50] #50번째 lamda
coef(ridge.mod)[,50] #그 lamda의 계수값
sqrt(sum(coef(ridge.mod)[-1,50]^2)) #엘투놈 값 계산?? L2 norm?? 

ridge.mod$lambda[60] #60번째 lambda로 반복
coef(ridge.mod)[,60]
sqrt(sum(coef(ridge.mod)[-1,60]^2))

predict(ridge.mod,s=50,type="coefficients")[1:20,] #특정 람다값에 대해서 계수값 추정

set.seed(1) 
train=sample(1:nrow(x), nrow(x)/2)
test=(-train)
y.test=y[test]

ridge.mod=glmnet(x[train,],y[train],alpha=0,lambda=grid, thresh=1e-12)

ridge.pred=predict(ridge.mod,s=4,newx=x[test,]) #test 데이터에 대해서 예측
mean((ridge.pred-y.test)^2) #test error
mean((mean(y[train])-y.test)^2) #변수를 사용하지 않았을 때(base line) mse

ridge.pred=predict(ridge.mod,s=1e10,newx=x[test,]) #lambda가 10^10
mean((ridge.pred-y.test)^2)

#error
ridge.pred=predict(ridge.mod,s=0,newx=x[test,],exact=T) #lambda=0; 최소제곱추정값
mean((ridge.pred-y.test)^2)

lm(y~x, subset=train) #선형회귀; lambda=0인 경우와 같은 결과
predict(ridge.mod,s=0,exact=T,type="coefficients")[1:20,] #교수님 영상에 없는데?

#최적의 lambda값 선택 by cv
set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=0)

plot(cv.out) #점선부분에서 optimal
bestlam=cv.out$lambda.min
bestlam #211.7416

ridge.pred=predict(ridge.mod,s=bestlam,newx=x[test,]) #최적값에서 predict
mean((ridge.pred-y.test)^2) #test mse

out=glmnet(x,y,alpha=0) #최종 예측 모혀
predict(out,type="coefficients",s=bestlam)[1:20,] #최종 계수추정값

#2. The Lasso

lasso.mod=glmnet(x[train,],y[train],alpha=1,lambda=grid) #alpha=1; Lasso
plot(lasso.mod) #계수에 대한 profile

#best lamda 구하기 by cv
set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=1) 
plot(cv.out)

bestlam=cv.out$lambda.min
lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred-y.test)^2) #test mse=100743.4

out=glmnet(x,y,alpha=1,lambda=grid) #모든 데이터에 대해서 최종 예측 모형
lasso.coef=predict(out,type="coefficients",s=bestlam)[1:20,]
lasso.coef #대부분 0
lasso.coef[lasso.coef!=0] #0이 아닌 것들만 확인; 7개의 변수만 유의


# Chapter 6 Lab 3: PCR and PLS Regression

#1. Principal Components Regression

#라이브러리 설치
install.packages("pls")

library(pls)
set.seed(2)

pcr.fit=pcr(Salary~., data=Hitters,scale=TRUE,validation="CV") #x data를 scaling, cv를 이용해서 validation
summary(pcr.fit) #19개; 분산에 대한 설명 비율도 확인
validationplot(pcr.fit,val.type="MSEP") #총 19개인데 16개 일 때 최소; 근데 2개일 때랑 비슷 

set.seed(1)
pcr.fit=pcr(Salary~., data=Hitters,subset=train,scale=TRUE, validation="CV") #cv로 최적의 M 구하기
validationplot(pcr.fit,val.type="MSEP") #한 7정도에서 최소값

pcr.pred=predict(pcr.fit,x[test,],ncomp=7) #그래서 7에서 test error 구하기
mean((pcr.pred-y.test)^2) #Ridge랑 비슷하지만 Lasso보단 조금 더 나은 값

pcr.fit=pcr(y~x,scale=TRUE,ncomp=7) #전체 데이터를 가지고 component=7
summary(pcr.fit) #분산 설명 정도 확인

#2. Partial Least Squares

set.seed(1)
pls.fit=plsr(Salary~., data=Hitters,subset=train,scale=TRUE, validation="CV")
summary(pls.fit)
validationplot(pls.fit,val.type="MSEP") #최적값 2

pls.pred=predict(pls.fit,x[test,],ncomp=2) #2를 가지고 예측
mean((pls.pred-y.test)^2) #test mse 확인

pls.fit=plsr(Salary~., data=Hitters,scale=TRUE,ncomp=2) #최종 예측 모형
summary(pls.fit)




