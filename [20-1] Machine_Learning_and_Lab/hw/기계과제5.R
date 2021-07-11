###Q9###

#기본 셋팅
library(ISLR) #For load College data 
attach(College) #College 디폴트로 부착
set.seed(11) #seed number 부여
sum(is.na(College)) #결측치 확인

#9-(a); 데이터 split
train = sample(1:dim(College)[1], dim(College)[1]/2)
test = -train
College.train = College[train, ] 
College.test = College[test, ]

#9-(b); Linear 

#fitting by linear model
lm.fit = lm(Apps~., data=College.train)

#test error
lm.pred = predict(lm.fit, College.test)
mean((lm.pred-College.test$Apps)^2) 

#9-(c); Ridge

#fitting by ridge regression model
library(glmnet)

train.X = model.matrix(Apps~., data=College.train)
test.X = model.matrix(Apps~., data=College.test)

grid = 10^seq(4,-2,length=100)
ridge.fit = glmnet(train.X, College.train$Apps, alpha=0, lambda=grid, thresh=1e-12)
ridge.cv = cv.glmnet(train.X, College.train$Apps, alpha=0, lambda=grid, thresh=1e-12)

bestlambda.R = ridge.cv$lambda.min
bestlambda.R

#test error
ridge.pred = predict(ridge.fit, s=bestlambda.R, newx=test.X)
mean((ridge.pred - College.test$Apps)^2)

#9-(d); Lasso

#fitting by lasso model
lasso.fit = glmnet(train.X, College.train$Apps, alpha=1, lambda=grid, thresh=1e-12)
lasso.cv = cv.glmnet(train.X, College.train$Apps, alpha=1, lambda=grid, thresh=1e-12)

bestlambda.L = lasso.cv$lambda.min
bestlambda.L

#test error
lasso.pred = predict(lasso.fit, s=bestlambda.L, newx=test.X)
mean((lasso.pred - College.test$Apps)^2)

#non-zero coefficient estimates
predict(lasso.fit, s=bestlambda.L, type="coefficients")

#9-(e); PCR

#fitting by PCR model
library(pls)
pcr.fit = pcr(Apps~., data=College.train, scale=TRUE, validation="CV")
validationplot(pcr.fit, val.type="MSEP")

#test error
pcr.pred = predict(pcr.fit, College.test, ncomp = 10)
mean((pcr.pred - College.test$Apps)^2)

#9-(f); PLS

#fitting by PLS model
pls.fit = plsr(Apps~., data=College.train, scale=TRUE, validation="CV")
validationplot(pls.fit, val.type="MSEP")

#test error
pls.pred = predict(pls.fit, College.test, ncomp = 10)
mean((pls.pred - College.test$Apps)^2)

#9-(g); Comment

#R^2값 비교
test.avg = mean(College.test$Apps)
lm.r2 = 1-mean((lm.pred - College.test$Apps)^2)/mean((test.avg - College.test$Apps)^2)
ridge.r2 = 1-mean((ridge.pred - College.test$Apps)^2) / mean((test.avg - College.test$Apps)^2)
lasso.r2 = 1-mean((lasso.pred - College.test$Apps)^2) / mean((test.avg - College.test$Apps)^2)
pcr.r2 = 1-mean((pcr.pred - College.test$Apps)^2) / mean((test.avg - College.test$Apps)^2)
pls.r2 = 1-mean((pls.pred - College.test$Apps)^2) / mean((test.avg - College.test$Apps)^2)

all.r2 = c(lm.r2, ridge.r2, lasso.r2, pcr.r2, pls.r2)
all.r2


