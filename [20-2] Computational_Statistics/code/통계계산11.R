### Ch8 몬테칼로 추론 ###

# 1. 점추정
# (1) 표준오차: E[g(X1,X2)]=E|X1-X2|
# (2) 평균제곱오차(MSE): E[(θ_hat- θ)^2] by 절사평균 
# 2. 구간추정
# (1) 신뢰구간: j번째 표본에 대한 신뢰구간 Cj 계산
# (2) 신뢰수준: 경험적 신뢰수준 계산
# 3. 가설검정
# (1) 제 1종 오류: H0가 참인데 기각할 확률 -> H0 분포에서 생성
# (2) 검정력: H0를 기각할 확률 -> 1-π(θ)

## E|X_1 - X_2|의 추정, X_1, X_2 ~ N(0,1)
m <- 1000 # 반복수
g <- numeric(m)
for (i in 1:m) { 
  x <- rnorm(2) # 정규분포로부터 2개의 샘플
  g[i] <- abs(x[1]-x[2]) # i번째 표본에 대해서 반복 계산
}
hist(g, prob = TRUE) # prob=TRUE; 상대도수
est <- mean(g) # 추정값
est # cf. 실제 이론값; 약 1.128


## 절사평균(k=1)의 MSE 
n <- 20
m <- 1000
tmean <- numeric(m)
for (i in 1:m) {
  x <- sort(rnorm(n)) # sorting
  tmean[i] <- sum(x[2:(n-1)])/(n-2) # tmean; 절사평균
}
g <- tmean^2
mse <- mean(g) # mse 추정값
se <- sqrt(sum((g-mean(g))^2))/m # se of mse
mse 
se


# 중앙값의 MSE
n <- 20
m <- 1000
tmean <- numeric(m)
for (i in 1:m) {
  x <- sort(rnorm(n))
  tmean[i] <- median(x) # tmean; 중앙값만 남기고 다 버림
}
g <- tmean^2
mse <- mean(g)
se <- sqrt(sum((g-mean(g))^2))/m  # se of mse
mse
se

# 오염된 정규분포에서 k차 절사평균의 MSE
# 오염된 정규분포; p*N(0,1)+(1-p)*N(0,100) 꼴
n <- 20
K <- n/2-1
m <- 1000
mse <- matrix(0,n/2,6)
trimmed.mse <- function(n, m, k, p) {
  tmean <- numeric(m)
  for (i in 1:m) {
    sigma <- sample(c(1,10), size = n, # sigma를 0~10에서 랜덤 추출
                    replace = TRUE, prob = c(p,1-p))
    x <- sort(rnorm(n, 0, sigma))
    tmean[i] <- sum(x[(k+1):(n-k)])/(n-2*k)
  }
  g <- tmean^2
  mse.est <- mean(g)
  se.mse <- sqrt(mean((g-mean(g))^2))/sqrt(m)
  return(c(mse.est, se.mse))
}

for (k in 0:K) {
  mse[k+1, 1:2] <- trimmed.mse(n=n, m=m, k=k, p=1.0)
  mse[k+1, 3:4] <- trimmed.mse(n=n, m=m, k=k, p=.95)
  mse[k+1, 5:6] <- trimmed.mse(n=n, m=m, k=k, p=.9)
}

mse # 1 -> 9로 갈수록 많이 버림


## N(mu, 1)에서 평균의 신뢰구간과 신뢰수준
n <- 20
alpha <- .05
x <- rnorm(n, mean=3, sd=1)
LCL <- mean(x)-qt(1-alpha/2,df=n-1)*sqrt(var(x))/sqrt(n)
UCL <- mean(x)+qt(1-alpha/2,df=n-1)*sqrt(var(x))/sqrt(n)
c(LCL, UCL) # 신뢰구간

n <- 20 
alpha <- .05
CL <- replicate(1000, expr = { # 몬테칼로 실험이므로 반복할 때마다 다름 
  x <- rnorm(n, mean=3, sd=1)
  LCL <- mean(x)-qt(1-alpha/2,df=n-1)*sqrt(var(x))/sqrt(n)
  UCL <- mean(x)+qt(1-alpha/2,df=n-1)*sqrt(var(x))/sqrt(n)
  c(LCL,UCL)
} )
sum(CL[1,] < 3 & CL[2,] > 3)
mean(CL[1,] < 3 & CL[2,] > 3) # 신뢰수준(=신뢰도)


## 경험적 1종의 오류율 계산
# 정규분포의 랜덤표본에 대하여 alpha=0.05일 때 H_0: mu=500 vs H_1: mu>500에 대한 t-검정
n <- 20
alpha <- .05
mu0 <- 500
sigma <- 100
m <- 10000          #number of replicates
p <- numeric(m)     #storage for p-values
for (j in 1:m)
{
  x <- rnorm(n,mu0,sigma) # 귀무가설에서 생성
  ttest <- t.test(x, alternative="greater", mu=mu0) # t-검정
  p[j] <- ttest$p.value # p-value
}
p.hat <- mean(p < alpha) # 귀무가설 기각 비율
se.hat <- sqrt(p.hat*(1-p.hat)/m) # 표준오차 추정값
print(c(p.hat,se.hat)) # 약 5%에서 표준오차 


## 경험적 검정력 추정
n <- 20
m <- 1000
mu0 <- 500
sigma <- 100
mu <- c(seq(450, 650, 10))    # alternatives
M <- length(mu)
power <- numeric(M)
for (i in 1:M) { # 여러가지 theta값에 대해서 검정력 추정
  mu1 <- mu[i]
  pvalues <- replicate(m, expr={
    # simulate under alternative mu1
    x <- rnorm(n, mean=mu1, sd=sigma)
    ttest <- t.test(x,alternative="greater", mu=mu0)
    ttest$p.value} )
  power[i] <- mean(pvalues <= .05) # 검정력 
}

library(Hmisc)   # for error bar
plot(mu, power) # 검정력을 함수의 형태로
abline(v=mu0, lty=1)
abline(h=.05, lty=1) # 5%
# add standard errors
se <- sqrt(power*(1-power)/m) # 표준오차
errbar(mu, power, yplus=power+se, yminus=power-se, xlab=bquote(theta))
lines(mu, power, lty=3) # 선으로 연결
detach(package:Hmisc) 
