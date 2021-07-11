###Q6###

#6-(a)
exp(-6+0.05*40+1*3.5)/{1+exp(-6+0.05*40+1*3.5)}

#6-(b)
2.5/0.05

###Q10###

#10-(a)
library(ISLR)
summary(Weekly)
pairs(Weekly)
cor(Weekly[,-9])

#10-(b)
attach(Weekly)
glm.fit = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, 
              data = Weekly, family = binomial)
summary(glm.fit)

#10-(c)
glm.probs = predict(glm.fit, type = "response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction)

(54+557)/(54+557+48+430) #정분류율; 약 56.10%
(48+430)/(54+557+48+430) #오분류율; 약 43.89%
557/(48+557) #market이 up할 때 model이 맞을 확률; 약 92.07%
54/(54+430) #market이 down할 때 model이 맞을 확률; 약 11.16%


#10-(d)
train = (Year < 2009)
Weekly.20092010 = Weekly[!train, ]
Direction.20092010 = Direction[!train]
glm.fit2 = glm(Direction ~ Lag2, data = Weekly, family = binomial, subset = train)

glm.probs2 = predict(glm.fit2, Weekly.20092010, type = "response")
glm.pred2 = rep("Down", length(glm.probs2))
glm.pred2[glm.probs2 > 0.5] = "Up"
table(glm.pred2, Direction.20092010)

(9+56)/(9+5+34+56) #정분류율; 약 62.5%
(5+34)/(9+5+34+56) #오분류율; 약 37.5%
56/(56+5) #market이 up할 때 예측이 맞을 확률; 약 91.80%
9/(9+34) #market이 down할 때 예측이 맞을 확률; 약 20.93%


#10-(e)
library(MASS)
lda.fit = lda(Direction ~ Lag2, data = Weekly, subset = train)
lda.pred = predict(lda.fit, Weekly.0910)
table(lda.pred$class, Direction.0910)

(9+56)/(9+5+34+56) #정분류율; 약 62.5%
(5+34)/(9+5+34+56) #오분류율; 약 37.5%
56/(56+5) #market이 up할 때 예측이 맞을 확률; 약 91.80%
9/(9+34) #market이 down할 때 예측이 맞을 확률; 약 20.93%

#10-(f)
qda.fit = qda(Direction ~ Lag2, data = Weekly, subset = train)
qda.class = predict(qda.fit, Weekly.0910)$class
table(qda.class, Direction.0910)

(0+61)/(0+0+43+61) #정분류율; 약 58.65%
(43+0)/(0+0+43+61)#오분류율; 약 41.35%
61/(0+61) #market이 up할 때 예측이 맞을 확률; 1
0/(0+43) #market이 down할 때 예측이 맞을 확률; 0

#10-(g)
library(class)
train.X = as.matrix(Lag2[train])
test.X = as.matrix(Lag2[!train])
train.Direction = Direction[train]
set.seed(1)
knn.pred = knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.0910)

(21+31)/(21+30+22+31) #정분류율; 약 50%
(22+30)/(21+30+22+31)#오분류율; 약 50%
31/(30+31) #market이 up할 때 예측이 맞을 확률; 약 50.82%
21/(21+22) #market이 down할 때 예측이 맞을 확률; 약 48.84%



