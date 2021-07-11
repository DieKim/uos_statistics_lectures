###Q9###
#dis; 직장 통근의 접근성을 보는 변수
#nox; 대기오염 물질 관련 지표

#문제 셋팅
library(MASS)
attach(Boston)
set.seed(1)

#9-(a)
fit = lm(nox~poly(dis, 3), data=Boston)
summary(fit)
#summary 결과 ~3차까지 모두 유의해 보인다 (by 유의확률)

dislim = range(dis)
dis.grid = seq(from = dislim[1], to = dislim[2], by = 0.1)
preds = predict(fit, newdata = list(dis = dis.grid), se = TRUE)
se.bands = cbind(preds$fit+2*preds$se.fit, preds$fit-2*preds$se.fit)

plot(nox ~ dis, data = Boston, col = "darkgrey")
lines(dis.grid, preds$fit, col = "blue", lwd = 2)
matlines(dis.grid, se.bands, lwd = 1, col = "blue" , lty = 3)
#plot 결과 smooth하게 잘 fitting 된 것 같다.

#따라서 모든 항이 유의하다. 

#9-(b)
polyfit = NULL
pred.nox = NULL
se.nox = NULL
rss = NULL
color = c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
dis.grid2 = seq(dislim[1], dislim[2], .1)
plot(dis, nox, ylim=c(.2,1), col="darkgrey")
legend("topright", c("1 Degree", "2 Degrees", "3 Degrees", "4 Degrees", 
                     "5 Degrees", "6 Degrees", "7 Degrees", "8 Degrees",
                     "9 Degrees", "10 Degrees"), fill = c(colors()[color[1:10]])
       , bty = "n", cex = .8)
for (i in 1:10){
  polyfit[[i]] = lm(nox ~ poly(dis, i), data=Boston)
  pred.nox[[i]] = predict(polyfit[[i]], newdata=list(dis=dis.grid2), se=TRUE)
  se.nox[[i]] = cbind(pred.nox[[i]]$fit + 2*pred.nox[[i]]$se - 2*pred.nox[[i]]$se)
  lines(dis.grid2, pred.nox[[i]]$fit, col=colors()[color[i]])
  rss[i] = sum(polyfit[[i]]$residuals^2)
}

plot(1:10, rss, xlab = "Degree", ylab = "RSS", type = "l")

#RSS는 1차에서 2차로 갈 때 크게 감소하고 차수가 커질 수록 감소폭이 작아진다

#9-(c)
library(boot)
deltas = rep(NA, 10)
for(i in 1:10){
  fit = glm(nox ~ poly(dis, i), data = Boston)
  deltas[i] = cv.glm(Boston, fit, K = 10)$delta[1]
}
plot(1:10, deltas, xlab = "Degree", ylab = "Test MSE"
     , type = "l", pch = 20, lwd = 2)
points(which.min(deltas), deltas[which.min(deltas)], col = 'red', pch = 19)
    

#by 10-fold CV, CV error는 차수가 1->3이 되면서 감소하고 
#4일때 최소이며 5->10이 되면서 크게 증가한다.
#따라서 best polynomial degree로 4를 고를 수 있다.

#9-(d); knot?? 
library(splines)
attr(bs(Boston$dis, df = 4), "knots")
fit = lm(nox ~ bs(dis, df = 4), knots = c(4, 7, 11), data = Boston)
summary(fit)
#summary 결과 모든 항이 유의하다  

preds = predict(fit, list(dis = dis.grid), se = TRUE)
se.bands = cbind(preds$fit + 2*preds$se.fit, preds$fit - 2*preds$se.fit)
plot(nox ~ dis, data = Boston, col = "darkgrey")
lines(dis.grid, preds$fit, col= "purple", lwd = 2)
matlines(dis.grid, se.bands, lwd = 1, col = "purple", lty = 3)
#plot 결과 smooth하게 잘 fitting 되었다.
#단, dis>10인 부분에서는 정확도가 떨어져 보인다; 데이터 부족 때문(?)

#9-(e)

#1. 회귀스플라인
x = seq(min(Boston$dis), max(Boston$dis), length.out=100)
cv = rep(NA, 15)
plot(nox~dis, data = Boston)
for(i in 3:15){
  fit = lm(nox~bs(dis, df=i), data = Boston)
  pred = predict(fit, data.frame(dis = x))
  lines(x, pred, col=color[i], lwd = 3)
  cv[i] = sum(fit$residuals^2)
}

#2. RSS
rss = rep(NA, 16)
for(i in 3:16){
  fit = lm(nox ~ bs(dis, df = i), data = Boston)
  rss[i] = sum(fit$residuals^2)
}
plot(3:16, rss[-c(1, 2)], xlab = "Degrees of freedom", ylab = "RSS", type = "l")

#RSS는 자유도가 14까지 감소하고 이후 살짝 증가한다

#9-(f)
cv = rep(NA, 16)
for(i in 3:16){
  fit = glm(nox ~ bs(dis, df = i), data = Boston)
  cv[i] = cv.glm(Boston, fit, K=10)$delta[1]
}
head(warnings())

plot(3:16, cv[-c(1, 2)], lwd = 2, type = "l", xlab = "Degrees of freedom", ylab = "CV error")

#by 10-fold CV, CV error는 매우 변동이 크지만 df=10에서 최소값을 가진다
#따라서 10을 the best degrees of freedom 으로 고를 수 있다.

###Q11###
#backfitting; 하나의 변수에 대해서 나머지 고정하고 fitting

#11-(a)
set.seed(0401)
X1 = rnorm(100)
X2 = rnorm(100)
eps = rnorm(100)
Y = -0.5 + 0.24*X1 + 1.2*X2 + eps

#11-(b)
beta1 = 0

#11-(c)
a = Y - beta1*X1
beta2 = lm(a~X2)$coef[2]
beta2

#11-(d)
a = Y - beta2*X2
beta1 = lm(a~X1)$coef[1]
beta1

#11-(e)
beta0 = rep(NA,1000)
beta1 = rep(NA,1000)
beta2 = rep(NA,1000)
beta1[1] = 0

for (i in 1:1000) {
  a = Y - beta1[i] * X1
  beta2[i] = lm(a ~ X2)$coef[2]
  a = Y - beta2[i] * X2
  lm.fit = lm(a ~ X1)
  if (i < 1000) {
    beta1[i + 1] = lm.fit$coef[2]
  }
  beta0[i] = lm.fit$coef[1]
}
plot(1:1000, beta0, type = "l", xlab = "iteration", ylab = "betas"
     , ylim = c(-2.2, 1.6), col = "purple")
lines(1:1000, beta1, col = "orange")
lines(1:1000, beta2, col = "blue")
legend("bottomright", c("beta0", "beta1", "beta2"), lty = 1, col = c("purple", "orange", 
                                                                "blue"))

#11-(f)
lm.fit = lm(Y ~ X1 + X2)
plot(1:1000, beta0, type = "l", xlab = "iteration", ylab = "betas"
     , ylim = c(-2.2, 1.6), col = "purple")
lines(1:1000, beta1, col = "orange")
lines(1:1000, beta2, col = "blue")
abline(h = lm.fit$coef[1], lty = "dashed", lwd = 3, col = rgb(0, 0, 0, alpha = 0.4))
abline(h = lm.fit$coef[2], lty = "dashed", lwd = 3, col = rgb(0, 0, 0, alpha = 0.4))
abline(h = lm.fit$coef[3], lty = "dashed", lwd = 3, col = rgb(0, 0, 0, alpha = 0.4))
legend("bottomright", c("beta0", "beta1", "beta2", "multiple regression")
       , lty = c(1, 1, 1, 2), col = c("purple", "orange", "blue", "black"))

#(e)에서의 그래프와 일치한다
#즉, backfitting 방법과 multiple regression의 추정된 계수값이 일치한다

#11-(g)
df = data.frame(Iteration=1000, beta0, beta1, beta2)
head(df, 10)

#X와 Y의 관계가 선형이면 한 번의 반복으로도 충분하다
#backfittng은 비선형인 경우에 의미있음 