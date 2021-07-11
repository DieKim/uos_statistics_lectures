###Q10###
library(ISLR)
summary(Carseats)

#(a); Fit a multiple regression model
attach(Carseats)
lm.fit_a = lm(Sales~Price+Urban+US)
summary(lm.fit_a)

#(e); Fit a smaller model
lm.fit_e = lm(Sales~Price+US)
summary(lm.fit_e)

#(g); 95% CI
confint(lm.fit_e)

#(h); 이상점이나 영향 관측값 존재 확인
par(mfrow = c(2, 2))
plot(lm.fit_e) #이상점 확인; 4번째 plot  

lev=hat(model.matrix(lm.fit_e))
plot(lev)

4/nrow(Carseats) #(p+1)/n

plot(Sales, Price)
points(Carseats[lev>0.01,]$Sales,Carseats[lev>0.01,]$Price,col='red') #영향관측값 확인

###Q14###

#(a)
set.seed(1)
x1 = runif(100)
x2 =0.5*x1+rnorm(100)/10
y = 2+2*x1+0.3*x2+rnorm(100)

#(b)
cor(x1, x2)
plot(x1, x2)

#(c)
lm.fit_c = lm(y~x1+x2)
summary(lm.fit_c)

#(d)
lm.fit_d = lm(y~x1)
summary(lm.fit_d)

#(e)
lm.fit_e = lm(y~x2)
summary(lm.fit_e)
