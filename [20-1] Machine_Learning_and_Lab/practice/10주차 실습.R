###10주차 실습###

# Chapter 7 Lab: Non-linear Modeling

library(ISLR)
attach(Wage)

#1. Polynomial Regression and Step Functions

### 다항회귀 ###

fit=lm(wage~poly(age,4),data=Wage) #4차 다항회귀 
coef(summary(fit)) #회귀 계수; 1~4차항, 모두 유의 

fit2=lm(wage~poly(age,4,raw=T),data=Wage) #raw=T; 직교가 아님
coef(summary(fit2))

#같은 결과 다른 방법(1)
fit2a=lm(wage~age+I(age^2)+I(age^3)+I(age^4),data=Wage) #I; 각각이 항(변수)으로 들어감 없으면 단순선형회귀
coef(fit2a) 

#같은 결과 다른 방법(2)
fit2b=lm(wage~cbind(age,age^2,age^3,age^4),data=Wage) #cbind(, , ,); 역시 각각을 항으로 취급
coef(fit2b)

### 계단 함수 ###

agelims=range(age) #age의 범위
age.grid=seq(from=agelims[1],to=agelims[2]) #age의 최대최소값을 grid로 나눔
preds=predict(fit,newdata=list(age=age.grid),se=TRUE) #predict; 예측값 구하기, se=T; std 구하기
se.bands=cbind(preds$fit+2*preds$se.fit,preds$fit-2*preds$se.fit) #fitting값과 표준오차값을 이용해서 95% 신뢰구간

par(mfrow=c(1,2),mar=c(4.5,4.5,1,1),oma=c(0,0,4,0)) #그래프 2개 그릴 준비
plot(age,wage,xlim=agelims,cex=.5,col="darkgrey") #첫번째 그래프
title("Degree-4 Polynomial",outer=T) #그래프 제목 
lines(age.grid,preds$fit,lwd=2,col="blue") #grid 상의 prediction 값을 파란선으로 그림
matlines(age.grid,se.bands,lwd=1,col="blue",lty=3) #std.error도 파란 점선으로 그림; 신뢰구간?

preds2=predict(fit2,newdata=list(age=age.grid),se=TRUE) #2번째 fit2를 가지고 예측
max(abs(preds$fit-preds2$fit)) #오차가 아주 작음; fit1과 fit2의 차이가 거의 없음 

### 다항회귀 차수 결정 ###
fit.1=lm(wage~age,data=Wage) #1차
fit.2=lm(wage~poly(age,2),data=Wage) #2차
fit.3=lm(wage~poly(age,3),data=Wage) #3차
fit.4=lm(wage~poly(age,4),data=Wage) #4차
fit.5=lm(wage~poly(age,5),data=Wage) #5차

anova(fit.1,fit.2,fit.3,fit.4,fit.5) #분산분석으로 모형 비교; 5차로 넘어가면 유의하지 않음
coef(summary(fit.5)) #오차항의 유의확률이 크게 나옴
(-11.983)^2 #F통계량 = t통계량...?; t^2 = F? t와 F의 관계를 말하고 싶은 것 같은데 설명 이상하심 

fit.1=lm(wage~education+age,data=Wage) #age에 대해서 1차
fit.2=lm(wage~education+poly(age,2),data=Wage) #2차
fit.3=lm(wage~education+poly(age,3),data=Wage) #3차
fit.4=lm(wage~education+poly(age,4),data=Wage) #4차
anova(fit.1,fit.2,fit.3,fit.4) #1->2, 2->3 모두 유의, 3->4 유의 X


fit=glm(I(wage>250)~poly(age,4),data=Wage,family=binomial) #로지스틱 회귀; age 4차
preds=predict(fit,newdata=list(age=age.grid),se=T) #grid, se=T, predict 
pfit=exp(preds$fit)/(1+exp(preds$fit)) #확률추정값; 로지스틱 함수 적용

se.bands.logit = cbind(preds$fit+2*preds$se.fit, preds$fit-2*preds$se.fit) #밴드값 구하기
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit)) #로지스틱으로 변형 

#or; predict의 옵션을 이용하는 방법
preds=predict(fit,newdata=list(age=age.grid),type="response",se=T) #type="response"

plot(age,I(wage>250),xlim=agelims,type="n",ylim=c(0,.2)) #일단 그래프 위치만 잡음 
points(jitter(age), I((wage>250)/5),cex=.5,pch="|",col="darkgrey") #위아래로 0인 경우, 1인 경우에 대해서 jittering
lines(age.grid,pfit,lwd=2, col="blue") #fitting값을 찍어봄
matlines(age.grid,se.bands,lwd=1,col="blue",lty=3) #std.error값을 찍어봄; 신뢰구간 

table(cut(age,4)) #cut; 구간으로 나눔 by quantile 값
fit=lm(wage~cut(age,4),data=Wage) #4구간으로 나눈 것에 대해서 선형회귀 
coef(summary(fit)) #각 구간에서의 추정값

#2. Splines

library(splines)
fit=lm(wage~bs(age,knots=c(25,40,60)),data=Wage) #knots; 원하는 knot 포인트를 지정할 수 있음 
pred=predict(fit,newdata=list(age=age.grid),se=T) #gird 상에서 se값과 함께 예측

plot(age,wage,col="gray") #age, wage에 대해서 plot
lines(age.grid,pred$fit,lwd=2) #predict값; 검은 실선
lines(age.grid,pred$fit+2*pred$se,lty="dashed") #신뢰구간; 검은 점선 
lines(age.grid,pred$fit-2*pred$se,lty="dashed") #신뢰구간; +-2 ...?

dim(bs(age,knots=c(25,40,60))) #dimension; 3000*6
dim(bs(age,df=6)) #df=6; 같은 결과
attr(bs(age,df=6),"knots") #knots; 특정하게 구간을 정함. 보통은 quantile 값

fit2=lm(wage~ns(age,df=4),data=Wage) #자유도 4; 선형함수이므로 양쪽 값이 빠짐
pred2=predict(fit2,newdata=list(age=age.grid),se=T) #prediction
lines(age.grid, pred2$fit,col="red",lwd=2) #predict값; 빨간 실선

### smooting spline ###
plot(age,wage,xlim=agelims,cex=.5,col="darkgrey") #그래프 위치 잡기
title("Smoothing Spline") #그래프 제목

fit=smooth.spline(age,wage,df=16) #자유도 16으로 지정
fit2=smooth.spline(age,wage,cv=TRUE) # cv=TRUE; cv를 선택해서 자유도 결정
fit2$df #자유도 확인; 약 6.8

lines(fit,col="red",lwd=2) #빨간 실선; 울퉁불퉁 함. 즉 과대적합
lines(fit2,col="blue",lwd=2) #더 smooth 함 df 6.8가 더 적절해 보임
legend("topright",legend=c("16 DF","6.8 DF"),col=c("red","blue"),lty=1,lwd=2,cex=.8) #legend; 그래프 귀퉁이에 정보(?) 달기

plot(age,wage,xlim=agelims,cex=.5,col="darkgrey") #역시 plot 자리 잡기
title("Local Regression") #그래프 제목; Local Regression

fit=loess(wage~age,span=.2,data=Wage) #span=0.2
fit2=loess(wage~age,span=.5,data=Wage) #span=0.5

lines(age.grid,predict(fit,data.frame(age=age.grid)),col="red",lwd=2) #빨간 실선; 울퉁불퉁
lines(age.grid,predict(fit2,data.frame(age=age.grid)),col="blue",lwd=2) #파란 실선; 50%가 더 나아보임 
legend("topright",legend=c("Span=0.2","Span=0.5"),col=c("red","blue"),lty=1,lwd=2,cex=.8) #legend; topright에 해당 정보달기 

#3. GAMs

install.packages("gam")
library(gam)

gam1=lm(wage~ns(year,4)+ns(age,5)+education,data=Wage) #year에 대해서 4차, age에 대해서 5차
gam.m3=gam(wage~s(year,4)+s(age,5)+education,data=Wage) #s; spline by gam 이용 

par(mfrow=c(1,3))
plot(gam.m3, se=TRUE,col="blue") #gam.m3; spline으로 한 거
plot.gam(gam1, se=TRUE, col="red") #뭔가... 교수님 잘 모르시는 듯...?
#코드 수정
plot.Gam(gam1, se=TRUE, col="red", ask=T)

gam.m1=gam(wage~s(age,5)+education,data=Wage) #age 5차
gam.m2=gam(wage~year+s(age,5)+education,data=Wage) #year, age 5차
anova(gam.m1,gam.m2,gam.m3,test="F") #분산분석; 2번째 모델이 적합해 보임 
summary(gam.m3) #summary를 봐도 year은 유의하지 않아보임; 2번째 모델 선택 

preds=predict(gam.m2,newdata=Wage) #2번째 모델 예측
gam.lo=gam(wage~s(year,df=4)+lo(age,span=0.7)+education,data=Wage) #lo s(?) 이용
plot.Gam(gam.lo, se=TRUE, col="green", ask=T) #순차적으로 확인; 1~5, 0은 탈출

### 교호작용 ###

install.packages("akima")
library(akima)

gam.lo.i=gam(wage~lo(year,age,span=0.5)+education,data=Wage) #교호작용 고려
plot(gam.lo.i, ask=T) #year와 age의 교호작용이 있어보임

gam.lr=gam(I(wage>250)~year+s(age,df=5)+education,family=binomial,data=Wage) #로지스틱 회귀
par(mfrow=c(1,3))
plot(gam.lr,se=T,col="green") #고등학교 이하의 범주를 뺴야될 것 같음
table(education,I(wage>250)) #고등학교 이하 TRUE = 0

gam.lr.s=gam(I(wage>250)~year+s(age,df=5)+education,family=binomial
             ,data=Wage,subset=(education!="1. < HS Grad")) #subset; 고등학교 이하 빼기
plot(gam.lr.s,se=T,col="green")

