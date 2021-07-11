###Q5###
#seed값 고정
#(a); by glm
#(b); dataset을 train으로 나누고 아무튼 순서대로
#(c); seed값을 바꿔가면서 (b)을 반복. 결과가 다를거임
#(d); 설명변수에 더미변수를 추가해서 해봐라. 이때 에러가 어떻게 되냐

#5-(a)
library(ISLR)
attach(Default)
set.seed(1)

glm.fit = glm(default ~ income + balance, family = "binomial")
summary(glm.fit)

#5-(b)

#step1
#dim(Default)[1]; 행의 개수=관측치 개수
#즉, 전체 데이터 개수에서 1/2을 sampling해서 train data로
train = sample(dim(Default)[1], dim(Default)[1]/2)

#step2
glm.fit = glm(default ~ income + balance, family = "binomial", subset = train)
summary(glm.fit)

#step3
probs = predict(glm.fit, newdata = Default[-train, ], type = "response")
glm.pred = rep("No", length(probs))
glm.pred[probs>0.5] = "Yes"

#step4
mean(glm.pred != Default[-train, ]$default)
#We have a 2.86% test error rate with the vaildation set approach

#5-(c)
train = sample(dim(Default)[1], dim(Default)[1]/2)
glm.fit = glm(default ~ income + balance, family = "binomial", subset = train)
probs = predict(glm.fit, newdata = Default[-train, ], type = "response")
glm.pred = rep("No", length(probs))
glm.pred[probs > 0.5] = "Yes"
mean(glm.pred != Default[-train, ]$default)

train = sample(dim(Default)[1], dim(Default)[1]/2)
glm.fit = glm(default ~ income + balance, family = "binomial", subset = train)
probs = predict(glm.fit, newdata = Default[-train, ], type = "response")
glm.pred = rep("No", length(probs))
glm.pred[probs > 0.5] = "Yes"
mean(glm.pred != Default[-train, ]$default)

train = sample(dim(Default)[1], dim(Default)[1]/2)
glm.fit = glm(default ~ income + balance, family = "binomial", subset = train)
probs = predict(glm.fit, newdata = Default[-train, ], type = "response")
glm.pred = rep("No", length(probs))
glm.pred[probs > 0.5] = "Yes"
mean(glm.pred != Default[-train, ]$default)

#test error rate는 계속 달라짐
#training set과 validation set에 포함되는 데이터가 달라지기 때문

#5-(d)
train = sample(dim(Default)[1], dim(Default)[1]/2)
glm.fit = glm(default ~ income + balance + student, family = "binomial", subset = train)
probs = predict(glm.fit, newdata=Default[-train, ], type = "response")
glm.pred = rep("No", length(probs))
glm.pred[probs > 0.5] = "Yes"
mean(glm.pred != Default[-train, ]$default)

#student 더미변수가 test error rate의 감소를 가져오진 않는 듯 하다

###Q6###
#계수의 standard error
#1. bootstrap
#2. glm에서 자체적으로 제공하는 std.error

#6-(a)
set.seed(1)
glm.fit = glm(default ~ income + balance, family = "binomial")
summary(glm.fit)

#6-(b)
boot.fn = function(data, index){
  fit = glm(default ~ income + balance, data = data,
            family = "binomial", subset = index)
  return(coef(fit))
}

#6-(c)
library(boot)
boot(Default, boot.fn, 1000)

#6-(d)
#두 방법의 std.error가 거의 비슷하다

###Q8###
#simulation data
#오차항이 표준정규분포를 따름; 회귀모형 가정
#(b); scatter plot. X와 y의 관계가 있을거임
#(c); 1-4차 회귀
#(d); randomseed 바꿔가며 시행. 앞의 결과와 비교
#(e); loocv값이 가장 작아지는 모델. 아마 2차모델? 
#(f); (c)의 계수추정값에 대한 유의성 

#8-(a)
set.seed(1)
y=rnorm(100)
x=rnorm(100)
y=x-2*x^2+rnorm(100)

#n=100, p=2
#the model used is Y=X-2X^2+확률오차

#8-(b)
plot(x,y)
#이차함수 관계. a curved relationship

#8-(c); LOOCV 

library(boot)
Data = data.frame(x, y)
set.seed(1)

#1
glm.fit1 = glm(y ~ x)
cv.glm(Data, glm.fit1)$delta[1]

#2
glm.fit2 = glm(y ~ poly(x, 2))
cv.glm(Data, glm.fit2)$delta[1]

#3
glm.fit3 = glm(y ~ poly(x, 3))
cv.glm(Data, glm.fit3)$delta[1]

#4
glm.fit4 = glm(y ~ poly(x, 4))
cv.glm(Data, glm.fit4)$delta[1]

#8-(d)
set.seed(2)

#1
glm.fit1 = glm(y ~ x)
cv.glm(Data, glm.fit1)$delta[1]

#2
glm.fit2 = glm(y ~ poly(x, 2))
cv.glm(Data, glm.fit2)$delta[1]

#3
glm.fit3 = glm(y ~ poly(x, 3))
cv.glm(Data, glm.fit3)$delta[1]

#4
glm.fit4 = glm(y ~ poly(x, 4))
cv.glm(Data, glm.fit4)$delta[1]

#결과가 같음. LOOCV는 n-fold of a single observation이므로

#8-(e)
#glm.fit2; (b)에서 보듯이 x, y는 이차 관계이기 때문에

#8-(f)
summary(glm.fit4)

#p-values는 1, 2차에서 유의
#이는 cv의 결과와 동일