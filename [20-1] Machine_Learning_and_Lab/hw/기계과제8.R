### Q2 ###

#2-(a)
r = 2
plot(NA,NA,type="n",xlim=c(-4,2),ylim=c(-1,5),
     asp=1, xlab="X1", ylab="X2")
symbols(c(-1),c(2),circles=c(r),add=TRUE,inches=FALSE)

#2-(b)
text(c(-1),c(2),"< 4")
text(c(-4),c(2),"> 4")

#2-(c)
plot(c(0,-1,2,3),c(0,1,2,8),col=c("blue","red","blue","blue"), 
     type="p",asp=1,xlab="X1",ylab="X2")
symbols(c(-1),c(2),circles=c(r),add=TRUE,inches=FALSE)

#2-(d)
#by 수식 

### Q5 ###

#5-(a)
set.seed(2020)
x1 = runif(500)-0.5
x2 = runif(500)-0.5
y = 1*(x1^2-x2^2>0)

#5-(b)
plot(x1[y==0], x2[y==0], col="red", xlab="X1", ylab="X2", pch=1)
points(x1[y==1], x2[y==1], col="blue", pch=2)
# 비선형 분류 경계임을 확인할 수 있음

#5-(c)
lm.fit = glm(y ~ x1 + x2, family="binomial")
summary(lm.fit)

#5-(d)
data = data.frame(x1=x1, x2=x2, y=y)
lm.prob = predict(lm.fit, data, type = "response")
lm.pred = ifelse(lm.prob > 0.5, 1, 0)
data.pos = data[lm.pred == 1, ]
data.neg = data[lm.pred == 0, ]
plot(data.pos$x1, data.pos$x2, col = "blue", xlab = "X1", ylab = "X2", pch = 1)
points(data.neg$x1, data.neg$x2, col = "red", pch = 2)
# 분류 경계가 선형임을 확인할 수 있음

#5-(e)
lm.fit2 = glm(y ~ poly(x1, 2) + poly(x2, 2) + I(x1 * x2), data, family = binomial)
summary(lm.fit2)

#5-(f) 
lm.prob = predict(lm.fit2, data, type = "response")
lm.pred = ifelse(lm.prob > 0.5, 1, 0)
data.pos = data[lm.pred == 1, ]
data.neg = data[lm.pred == 0, ]
plot(data.pos$x1, data.pos$x2, col = "blue", xlab = "X1", ylab = "X2", pch = 1)
points(data.neg$x1, data.neg$x2, col = "red", pch = 2)
# 비선형 분류 경계; 이는 실제 의사결정 경계와 매우 유사

#5-(g)
library(e1071)
svm.lin = svm(as.factor(y) ~ x1 + x2, data, kernel = "linear", cost = 0.01)
svm.pred = predict(svm.lin, data)
data.pos = data[svm.pred == 1, ]
data.neg = data[svm.pred == 0, ]
plot(data.pos$x1, data.pos$x2, col = "blue", xlab = "X1", ylab = "X2", pch = 1)
points(data.neg$x1, data.neg$x2, col = "red", pch = 2)
# 지지벡터 분류 방법으로는 모든 점을 같은 class로 분류(c값이 0.01일 때)

#5-(h)
svm.nl = svm(as.factor(y) ~ x1 + x2, data, kernel = "radial", gamma = 1)
svm.pred = predict(svm.nl, data)
data.pos = data[svm.pred == 1, ]
data.neg = data[svm.pred == 0, ]
plot(data.pos$x1, data.pos$x2, col = "blue", xlab = "X1", ylab = "X2", pch = 1)
points(data.neg$x1, data.neg$x2, col = "red", pch = 2)
# SVM 역시 실제 의사결정 경계와 매우 유사

#5-(i)
#비선형 커널을 가진 SVM이 비선형 경계를 찾는데 매우 강력
#로지스틱 회귀와 선형 커널을 갖는 SVM은 의사결정 경계를 찾지 못 함
#로지스틱 회귀에 교호작용 항을 추가하는 것은 방사형 베이스 커널과 같은 효과
#그러나 바른 상호작용을 선택하기에는 몇 가지 조정이 필요함; 까다로움  
#반면 방사상 기반커널은 감마만 조정하면 됨

### Q8 ###

#8-(a)
library(ISLR)
set.seed(1)
train = sample(dim(OJ)[1], 800)
OJ.train = OJ[train, ]
OJ.test = OJ[-train, ]

#8-(b)
library(e1071)
svm.lin = svm(Purchase ~ ., kernel = "linear", data = OJ.train, cost = 0.01)
summary(svm.lin)
# 800개의 training points 중 439개의 지지벡터
# 그 중 221개는 CH, 218개는 MM에 해당 

#8-(c)
train.pred = predict(svm.lin, OJ.train)
table(OJ.train$Purchase, train.pred)
(55+78)/(439+55+78+228) #training error rate

test.pred = predict(svm.lin, OJ.test)
table(OJ.test$Purchase, test.pred)
(18+31)/(141+18+31+80) #test error rate

#8-(d)
set.seed(10)
tune.out = tune(svm, Purchase ~ ., data = OJ.train, kernel = "linear", 
                ranges = list(cost = 10^seq(-2, 1, by = 0.25)))
summary(tune.out)
# best parameters: cost = 1
# best performance: 0.16625

#8-(e)
svm.lin2 = svm(Purchase ~ ., kernel = "linear", data = OJ.train, 
                 cost = tune.out$best.parameters$cost)
train.pred = predict(svm.lin2, OJ.train)
table(OJ.train$Purchase, train.pred)
(56+72)/(438+56+72+234) # training error 

test.pred = predict(svm.lin2, OJ.test)
table(OJ.test$Purchase, test.pred) 
(19+30)/(140+19+30+81) # test error

#8-(f)
set.seed(222)
svm.rad = svm(Purchase ~ ., data = OJ.train, kernel = "radial")
summary(svm.rad)

train.pred = predict(svm.rad, OJ.train)
table(OJ.train$Purchase, train.pred)
(45+73)/(446+45+73+236)

test.pred = predict(svm.rad, OJ.test)
table(OJ.test$Purchase, test.pred)
(19+27)/(143+19+27+81)

###

set.seed(444)
tune.out = tune(svm, Purchase ~ ., data = OJ.train, kernel = "radial", 
                ranges = list(cost = 10^seq(-2, 1, by = 0.25)))
summary(tune.out)

svm.rad2 = svm(Purchase ~ ., data = OJ.train, kernel = "radial", 
                 cost = tune.out$best.parameters$cost)
train.pred = predict(svm.rad2, OJ.train)
table(OJ.train$Purchase, train.pred)
(42+75)/(449+42+75+234)

test.pred = predict(svm.rad2, OJ.test)
table(OJ.test$Purchase, test.pred)
(19+27)/(143+19+27+81)

#8-(g)
set.seed(58)
svm.pol = svm(Purchase ~ ., data = OJ.train, kernel = "poly", degree = 2)
summary(svm.pol)

train.pred = predict(svm.pol, OJ.train)
table(OJ.train$Purchase, train.pred)
(33+105)/(461+33+105+201)

test.pred = predict(svm.pol, OJ.test)
table(OJ.test$Purchase, test.pred) 
(10+41)/(149+10+41+70)

###

set.seed(234)
tune.out = tune(svm, Purchase ~ ., data = OJ.train, kernel = "poly", degree = 2, 
                ranges = list(cost = 10^seq(-2, 1, by = 0.25)))
summary(tune.out)

svm.pol2 = svm(Purchase ~ ., data = OJ.train, kernel = "poly", degree = 2,
               cost = tune.out$best.parameters$cost)
train.pred = predict(svm.pol2, OJ.train)
table(OJ.train$Purchase, train.pred)
(40+78)/(454+40+78+228)

test.pred = predict(svm.pol2, OJ.test)
table(OJ.test$Purchase, test.pred)
(17+33)/(142+17+33+78)

#8-(h)
# radial basis kernel이 train, test data 모두에서 최소 오분류율
