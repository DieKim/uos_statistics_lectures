### 6주차 실습 ###

#1. The Stock Market Data

library(ISLR)
?Smarket #stock market data 확인 

names(Smarket) #변수명 확인
dim(Smarket)  #관측과 변수의 개수 확인; 1250 obs, 9 var 

summary(Smarket) #변수별 summary 확인; 대략적인 정보 
pairs(Smarket) #pairwise scatterplot 확인

cor(Smarket) #Error; 9번째 변수 Direction이 범주형 변수이기 때문에
cor(Smarket[,-9]) #9번째 변수 제외; 작은 cor로 관계 예측 어렵 

attach(Smarket)
plot(Volume) #정비례 

#2. Logistic Regression

#로지스틱 회귀; 회귀와 분류 모두 사용 가능
#분류; 반응변수가 범주형 변수
#Smarket의 Direction; Up/Down을 값으로 하는 범주형 변수

glm.fits=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, #glm(); 로지스틱 회귀 
             data=Smarket,family=binomial) #family=binomial; 범주형 변수를 이진변수(0,1)로 fitting
summary(glm.fits) #로지스틱 회귀분석 결과 확인; p-value를 보니 유의한 계수가 없음

coef(glm.fits) #coef; 계수값 확인
summary(glm.fits)$coef #summary한 결과 중 계수관련 값만 확인 
summary(glm.fits)$coef[,4] #p-value만 확인; summary의 coef 중 4번째 열 = p값

glm.probs=predict(glm.fits,type="response") #predict; 추정값 구하는 함수
glm.probs[1:10] #type='response'; 0과 1사이의 확률추정 값
#확률값을 보니 다 0.5 근처임; 값들이 분류 경계 근처에 위치. 어려운 예측 문제 

contrasts(Direction) #contrasts; contrasts 형식으로 나타냄
#Up=1, Down=0으로 코딩 됨

#For confusion matrix
glm.pred=rep("Down",1250) #predict값을 down으로 초기화
glm.pred[glm.probs>.5]="Up" #확률추정 값이 0.5보다 큰 경우 "Up"
table(glm.pred,Direction) #confusion matrix 확인

(507+145)/1250 #정분류율; 52.16%
mean(glm.pred == Direction) #예측과 Direction값이 일치하는 것의 평균; 위와 같은 결과

#Train data와 Test data 나눠서 예측
#confusion matrix by table(glm.pred, test data)
#모델이 맞을 확률 = 정분류율
#모델이 틀릴 확률 = 오분류유
#up일 때 up일 확률 = 민감도
#down일 때 down일 확률 = 특이도

train=(Year<2005) #2001-2004년 train data; 2005년 data만 따로 떼서 test data
Smarket.2005=Smarket[!train, ] #test data
dim(Smarket.2005) #test data의 dim; 252개
Direction.2005=Direction[!train] #해당되는 test data의 y값


glm.fits=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
             data=Smarket,family=binomial,subset=train) #subset=train; train data를 가지고 fitting
glm.probs=predict(glm.fits,Smarket.2005,type="response") #2005년 test data 예측; 확률추정 값

glm.pred=rep("Down",252) #일단 predict값을 모두 Down으로 초기화; test data 252개
glm.pred[glm.probs>.5]="Up" #확률값 가공; 확률이 0.5보다 크면 Up

table(glm.pred,Direction.2005) #confusion matrix 구하기 
mean(glm.pred==Direction.2005) #약 48%; 정분류율
mean(glm.pred!=Direction.2005) #약 52%; 오분류율이 더 높음 

#설명력이 없는 변수까지 모두 집어넣어 노이즈 발생
#p-value가 그나마 작은 변수들로 다시 fitting

glm.fits=glm(Direction~Lag1+Lag2,data=Smarket,family=binomial,subset=train) #Lag1, Lag2만 가지고 fitting
glm.probs=predict(glm.fits,Smarket.2005,type="response") #다시 test data에 대해서 예측; 확률추정 값 저장

glm.pred=rep("Down",252) #Down으로 초기화
glm.pred[glm.probs>.5]="Up" #0.5보다 크면 Up

table(glm.pred,Direction.2005) #confusion matrix
mean(glm.pred==Direction.2005) #정분류율 약 56%; 앞의 경우보다 향상
106/(106+76) #up으로 예상된 것 중 실제 up일 확률 = 민감도; 약 58% 

predict(glm.fits,newdata=data.frame(Lag1=c(1.2,1.5),Lag2=c(1.1,-0.8))
        ,type="response") #새로운 데이터에서 예측(test data를 새로 지정) 

#3. Linear Discriminant Analysis

library(MASS)

lda.fit=lda(Direction~Lag1+Lag2,data=Smarket,subset=train) #lda(); 선형판별분ㅅ  
lda.fit
plot(lda.fit) #각 class별로 데이터에 대해 히스토그램 

lda.pred=predict(lda.fit, Smarket.2005)
names(lda.pred) #변수명 확인 

lda.class=lda.pred$class #lda.pred에 있는 class만 뽑아서 table 할거임
table(lda.class,Direction.2005) #confusion matirx
mean(lda.class==Direction.2005) #약 56%의 정분류율

sum(lda.pred$posterior[,1]>=.5) #0.5보다 큰 개수
sum(lda.pred$posterior[,1]<.5) #0.5보다 작은 개수

lda.pred$posterior[1:20,1] #20개만 뽑아봄; 대부분이 0.5(분류경계) 근처인 것을 보아 분류 어렵
lda.class[1:20] #20개의 class(Up, Down) 확인
sum(lda.pred$posterior[,1]>.9) #90%를 넘은 값은 없음; 대부분이 분류경계 근처

#4. Quadratic Discriminant Analysis

qda.fit=qda(Direction~Lag1+Lag2,data=Smarket,subset=train) #qda(); 이차판별분석 
qda.fit

qda.class=predict(qda.fit,Smarket.2005)$class
table(qda.class,Direction.2005)
mean(qda.class==Direction.2005)

#5. K-Nearest Neighbors

library(class)


train.X=cbind(Lag1,Lag2)[train,] #데이터 셋팅 for KNN
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]
set.seed(1) #KNN에서 동점인 경우 랜덤이 발생하기 때문에 seed값 부여 

knn.pred=knn(train.X,test.X,train.Direction,k=1)
table(knn.pred,Direction.2005)
(83+43)/252 #정분류율

knn.pred=knn(train.X,test.X,train.Direction,k=3) #여러 개의 K값에 대해 시행해보고 최적의 K값 찾기 
table(knn.pred,Direction.2005)
mean(knn.pred==Direction.2005)

#6. An Application to Caravan Insurance Data

library(ISLR)
?Caravan #보험회사 데이터
dim(Caravan)

attach(Caravan)
summary(Purchase)
348/5822 #대략 6%정도 보험에 들었음

standardized.X=scale(Caravan[,-86]) #나머지 변수들 표준화
var(Caravan[,1]) #표준화 전 분산
var(Caravan[,2])
var(standardized.X[,1]) #표준화 후 분산
var(standardized.X[,2])

test=1:1000 
train.X=standardized.X[-test,]
test.X=standardized.X[test,]
train.Y=Purchase[-test]
test.Y=Purchase[test]
set.seed(1)

knn.pred=knn(train.X,test.X,train.Y,k=1) 
mean(test.Y!=knn.pred) #오분율 약 11%
mean(test.Y!="No") #무조건 가지고 있지 않다고 예측; 오히려 더 나은 결과
table(knn.pred,test.Y)
9/(68+9) #yes 중 실제 yes일 확률=민감도

knn.pred=knn(train.X,test.X,train.Y,k=3)
table(knn.pred,test.Y)
5/26 #정분류율 약 19% 

knn.pred=knn(train.X,test.X,train.Y,k=5)
table(knn.pred,test.Y)
4/15 #정분류율 약 26%

glm.fits=glm(Purchase~.,data=Caravan,family=binomial,subset=-test) #이번엔 로지스틱 회귀
glm.probs=predict(glm.fits,Caravan[test,],type="response") #test data에 대해 예측

glm.pred=rep("No",1000) #예측결과에 대해서 setting
glm.pred[glm.probs>.5]="Yes"
table(glm.pred,test.Y)

glm.pred=rep("No",1000) #새로 예측하기위해 다시 setting
glm.pred[glm.probs>.25]="Yes"
table(glm.pred,test.Y)
11/(22+11) 

