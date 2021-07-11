### 8주차 실습 ###

#1. The Validation Set Approach; 검증오차법

library(ISLR)
set.seed(1)

train=sample(392,196) #반은 훈련데이터
attach(Auto)

lm.fit=lm(mpg~horsepower,data=Auto,subset=train) #선형회귀
mean((mpg-predict(lm.fit,Auto))[-train]^2) #테스트 데이터에 대해서 테스트 에러

lm.fit2=lm(mpg~poly(horsepower,2),data=Auto,subset=train) #이차회귀
mean((mpg-predict(lm.fit2,Auto))[-train]^2)

lm.fit3=lm(mpg~poly(horsepower,3),data=Auto,subset=train) #삼차회귀
mean((mpg-predict(lm.fit3,Auto))[-train]^2)

#1->2차로 가면서 많이 줄고 2->3차는 거의 차이 없음

set.seed(2)
train=sample(392,196)

lm.fit=lm(mpg~horsepower,subset=train)
mean((mpg-predict(lm.fit,Auto))[-train]^2)

lm.fit2=lm(mpg~poly(horsepower,2),data=Auto,subset=train)
mean((mpg-predict(lm.fit2,Auto))[-train]^2)

lm.fit3=lm(mpg~poly(horsepower,3),data=Auto,subset=train)
mean((mpg-predict(lm.fit3,Auto))[-train]^2)

#seed값을 바꾸면 또 다른 결과

#2. Leave-One-Out Cross-Validation; LOOCV

glm.fit=glm(mpg~horsepower,data=Auto) #glm; family 지정 안 하면 회귀분석이 디폴트
coef(glm.fit) #계수추정값

lm.fit=lm(mpg~horsepower,data=Auto) #lm 쓰고 CV를 따로 구해도 됨
coef(lm.fit)

library(boot)
glm.fit=glm(mpg~horsepower,data=Auto)
cv.err=cv.glm(Auto,glm.fit) #CV값을 구해줌
cv.err$delta #값이 두 개 나옴; 앞은 CV, 뒤는 bias가 수정된 값(MSE?)

?cv.glm #help로 확인

cv.error=rep(0,5) #1차부터 5차까지 LOOCV 계산
for (i in 1:5){
  glm.fit=glm(mpg~poly(horsepower,i),data=Auto)
  cv.error[i]=cv.glm(Auto,glm.fit)$delta[1]
}
cv.error

#3. k-Fold Cross-Validation; k-fold CV

set.seed(17)
cv.error.10=rep(0,10) #경험상 k=5 또는 10이 최적
for (i in 1:10){
  glm.fit=glm(mpg~poly(horsepower,i),data=Auto)
  cv.error.10[i]=cv.glm(Auto,glm.fit,K=10)$delta[1]
}
cv.error.10

#다 비슷하게 1->2차로 넘어갈 때 많이 떨어지고 유지하는 형태

#4. The Bootstrap

alpha.fn=function(data,index){
  X=data$X[index]
  Y=data$Y[index]
  return((var(Y)-cov(X,Y))/(var(X)+var(Y)-2*cov(X,Y)))
}
alpha.fn(Portfolio,1:100) #portfolio; dataset name

set.seed(1)
alpha.fn(Portfolio,sample(100,100,replace=T)) #복원추출한 것에 대해서 bootstraping 한 번 시행
boot(Portfolio,alpha.fn,R=1000) #1000번 시행

#표준오차를 가지고 여러가지 추론 

#5. Estimating the Accuracy of a Linear Regression Model

boot.fn=function(data,index) #함수 생성; 계수를 뽑는 함수
  return(coef(lm(mpg~horsepower,data=data,subset=index)))
boot.fn(Auto,1:392) #원 데이터에 대한 계수값

set.seed(1)
boot.fn(Auto,sample(392,392,replace=T)) #392개 중 392개 샘플 하나 뽑아서 bootstraping
boot.fn(Auto,sample(392,392,replace=T)) #한 번 더 복원추출

boot(Auto,boot.fn,1000) #boot; 1000번 반복-1
summary(lm(mpg~horsepower,data=Auto))$coef #실제 선형회귀 값-2

#1과 2의 표준오차값 비교
#2는 선형이 맞다는 가정에 기반해 구한 값이지만 실제 데이터는 선형이 아니므로 적합하지 않음

boot.fn=function(data,index) #선형대신 이차회귀
  coefficients(lm(mpg~horsepower+I(horsepower^2),data=data,subset=index))

set.seed(1)
boot(Auto,boot.fn,1000) #bootstraping-1
summary(lm(mpg~horsepower+I(horsepower^2),data=Auto))$coef #실제 선형회귀 값-2

#이차회귀가 선형회귀보다 bootstraping으로 구한 표준오차값과 잘 맞음
