### 4주차 실습 ###

library(MASS)
library(ISLR)

#1. Simple Linear Regression; 단순선형회귀

fix(Boston) #boston 데이터 확인 가능
names(Boston) #boston 변수 확인 가능(설명변수)

lm.fit=lm(medv~lstat) #lm; 단순선형회귀분석
lm.fit=lm(medv~lstat,data=Boston) #data set 지정
attach(Boston) #data = Boston으로 고정
lm.fit=lm(medv~lstat) 

lm.fit #기본 정보
summary(lm.fit) #잔차, 계수, p-value 등 통계량 확인 가능 
names(lm.fit) #object 확인 가능 
coef(lm.fit) #계수 값만 확인
confint(lm.fit) #95% 신뢰구간 
predict(lm.fit,data.frame(lstat=(c(5,10,15))), interval="confidence") #특정값에서의 신뢰구간
predict(lm.fit,data.frame(lstat=(c(5,10,15))), interval="prediction") #특정값에서의 예측구간; 예측>신뢰

plot(lstat,medv) #반비례하는 경향; 선형은 아닌 듯 
abline(lm.fit) #최소제곱회귀선 표시
abline(lm.fit,lwd=3) #lwd; line의 굵기
abline(lm.fit,lwd=3,col="red") #선 색깔 지정

plot(lstat,medv,col="red")
plot(lstat,medv,pch=20) #pch; 동그라미 채워짐
plot(lstat,medv,pch="+") #pch='+'; 표시 모양이 '+'
plot(1:20,1:20,pch=1:20) #pch=1:20; 각각의 pch의 symbol에 따라서 plot

plot(lm.fit) #기본적으로 그래프 3개? 4개?가 나옴; 잔차에 대한 분석(Q-Q plot)
par(mfrow=c(2,2)) #2*2 그래프 배치
plot(predict(lm.fit), residuals(lm.fit)) 
plot(predict(lm.fit), rstudent(lm.fit)) 
plot(hatvalues(lm.fit)) 

which.max(hatvalues(lm.fit)) #375번째 값이 크다

#2. Multiple Linear Regression; 다중선형회귀

lm.fit=lm(medv~lstat+age,data=Boston) #설명변수 2개 이상; lstat, age 
summary(lm.fit)
lm.fit=lm(medv~.,data=Boston) #medv~.; medv를 제외한 모든 변수를 설명변수로 하고 회귀분석
summary(lm.fit) #indus, age 변수 제외 유의함을 확인할 수 있음 

install.packages("car") #지금 버전에서 설치 안 됨??
library(car)
vif(lm.fit) #각 변수 별로 vif값 확인

lm.fit1=lm(medv~.-age,data=Boston) #1; 유의하지 않은 변수를 빼고 fitting
summary(lm.fit1) #여전히 indus는 유의하지 않음 
lm.fit1=update(lm.fit, ~.-age) #2; 다시 유의하지 않은 변수 빼고 fitting

#3. Interaction Terms

summary(lm(medv~lstat*age,data=Boston)) #*; 교호작용

#4. Non-linear Transformations of the Predictors

lm.fit2=lm(medv~lstat+I(lstat^2)) #I(lstat^2); 2차 함수로 fitting
summary(lm.fit2) #2차 회귀 유의함을 확인
lm.fit=lm(medv~lstat) #1차 회귀
anova(lm.fit,lm.fit2) #두 모형 간의 분산 분석; 2차 회귀식이 1차 회귀식에 비해 유의하다

par(mfrow=c(2,2))
plot(lm.fit2) #약간의 비선형성이 남아있음 

lm.fit5=lm(medv~poly(lstat,5)) #poly(lstat,5); 1-5차 회귀모형
summary(lm.fit5)
summary(lm(medv~log(rm),data=Boston)) #rm에 대해서 로그 변환 

#5. Qualitative Predictors

fix(Carseats) #창 띄우기
?Carseats #데이터셋 확인 
names(Carseats) #변수명 확인
lm.fit=lm(Sales~.+Income:Advertising+Price:Age,data=Carseats) #income:advertising, price:age; 교호작용
summary(lm.fit) #교호작용 항의 유의성까지 확인 
attach(Carseats)
contrasts(ShelveLoc) #good, medium 변수 잡아주는거 확인(??); 기준 bad

#6. Writing Functions

LoadLibraries #아직 정의를 안해서 오류 
LoadLibraries() #함수를 나타냄; 역시 정의를 안해서 오류 
LoadLibraries=function(){ #함수 정의 
  library(ISLR)
  library(MASS)
  print("The libraries have been loaded.")
} 
LoadLibraries #함수 정의 출력 
LoadLibraries() #함수 실행

