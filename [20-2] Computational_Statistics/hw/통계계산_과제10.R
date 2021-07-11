### Q1 ###

# 1. 제안분포를 감마분포로 변경 
set.seed(1)
f <- function(x, sigma) {
  if (any(x < 0)) return (0)
  stopifnot(sigma > 0)
  return((x / sigma^2) * exp(-x^2 / (2*sigma^2)))
}

m <- 10000
sigma <- 4
x <- numeric(m)
x[1] <- rgamma(1, 1) # 초기값
k <- 0
u <- runif(m) # 난수의 개수만큼 발생

for (i in 2:m) {
  xt <- x[i-1]
  y <- rgamma(1, xt)
  num <- f(y, sigma) * dchisq(xt, df = y)
  den <- f(xt, sigma) * dchisq(y, df = xt)
  if (u[i] <= num/den) x[i] <- y else {
    x[i] <- xt
    k <- k+1     #y is rejected
  }
}
print(k) # 이는 강의안의 카이제곱분포보다 더 나은 결과

# 2. 경향성 확인
index <- 5000:5500
y1 <- x[index]
plot(index, y1, type="l", main="", ylab="x") # 경향성이 있는지 확인

# 3. qq plot과 히스토그램
b <- 2001      #discard the burnin sample; 2000개 번인
y <- x[b:m]
a <- ppoints(100)
QR <- sigma * sqrt(-2 * log(1 - a))  #quantiles of Rayleigh
Q <- quantile(y, a)

qqplot(QR, Q, main="", cex=.5,
       xlab="Rayleigh Quantiles", ylab="Sample Quantiles")
abline(0, 1) # 정상분포로 잘 수렴한 듯

hist(y, breaks="scott", main="", xlab="", freq=FALSE)
lines(QR, f(QR, 4)) # 이론적인 분포랑 매치; 잘 일치하고 있음

### Q2 ###

# 1. 2번량 정규 연쇄 (Xt,Yt) 생성
N <- 5000               #length of chain
burn <- 500            #burn-in length
X <- matrix(0, N, 2)    #the chain, a bivariate sample

rho <- 0.9             #correlation
mu1 <- 0
mu2 <- 0
sigma1 <- 1
sigma2 <- 1
s1 <- sqrt(1-rho^2)*sigma1 # 조건부 분포에 필요
s2 <- sqrt(1-rho^2)*sigma2

X[1, ] <- c(mu1, mu2)            #initialize; 초기값
for (i in 2:N) {
  x2 <- X[i-1, 2]
  m1 <- mu1 + rho * (x2 - mu2) * sigma1/sigma2
  X[i, 1] <- rnorm(1, m1, s1)
  x1 <- X[i, 1]
  m2 <- mu2 + rho * (x1 - mu1) * sigma2/sigma1
  X[i, 2] <- rnorm(1, m2, s2)
}

b <- burn + 1 # 앞에 500개를 버리고 501개부터
x <- X[b:N, ]
x

# 2. 번인 기간의 표본 제거 후, 생성된 표본의 산점도
cov(x) # 공분산 행렬 
plot(x, main="", cex=.5, xlab=bquote(X[1]), # 번인 제외 plot; 거의 정비례
     ylab=bquote(X[2]), ylim=range(x[,2]))

# 3. 단순선형회귀모형 적합
fit = lm(x[,2] ~ x[,1])
summary(fit)

# 4. 잔차의 정규성과 등분산성
par(mfrow=c(2,2))
plot(fit) 
