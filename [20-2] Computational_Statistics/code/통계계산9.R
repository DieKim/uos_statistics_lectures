### Ch6 확률난수의 발생 - Part2 ###

# part2

# 1. 이산형 확률난수의 발생
# (1) 이산형 균일분포; 역변환법
# (2) 이항분포; 회선법, 역변환법
# (3) 기하분포; 역변환법
# (4) 음이항분포; 회선법
# (5) 포아송분포; 지수분포 이용

# 2. 연속형 확률난수의 발생
# (1) 정규분포; 중심극한정리, Box-Muller 변환, 극좌표 변환
# (2) 감마분포; 자연수일 때/0~1사이일 때/1보다 클 때
# (3) 베타분포; 감마분포에서 유도
# (4) F-분포; 베타분포의 특수한 경우
# (5) 카이제곱분포; 정규분포 파생, 감마분포의 특수한 경우
# (6) t-분포; 정규분포/카이제곱분포 파생

# 3. 다변량 정규난수의 발생 
# 행렬의 분해
# (i) 분광분해; 고유값
# (ii) 촐레스키분해; 상삼각행렬

###################################################################################

## 이산 확률난수의 발생

rdiscunif = function(n, a, b) # 이산형균일분포
{
  if (as.integer(a) == a && as.integer(b) == b)
    return(as.integer(a+(b-a+1)*runif(n)))
  else stop("a and b should be integers.")
}

rbinomial = function(n, size, prob) # 이항분포
{
  if (prob>1 || prob<0) stop("p should be in [0,1]")
  p = ifelse(prob<=0.5, prob, 1-prob)
  f0 = (1-p)^size
  p1p = p/(1-p)
  ranbin = runif(n)
  for (i in 1:n)
  {
    x = 0
    fx = f0
    repeat
    {
      if (ranbin[i] <= fx)
      {
        ranbin[i] = x
        break
      } else
      {
        ranbin[i] = ranbin[i] - fx
        fx = (size-x)/(x+1)*p1p*fx
        x = x + 1
      }
    }
  }
  ranbin = ifelse(prob<=0.5, ranbin, size-ranbin)
  return(ranbin)
}

rpoisson = function(n, lambda) # 포아송분포
{
  ep = exp(-lambda)
  rpoiss = rep(0, n)
  for (i in 1:n)
  {
    tr = 1
    repeat
    {
      tr = tr*runif(1)
      if (tr <= ep) break
      else rpoiss[i] = rpoiss[i] + 1
    }
  }
  return(rpoiss)
}

# 다변량 정규난수: 분광분해법
mu <- c(0,0)
Sigma <- matrix(c(1,.9,.9,1), nrow=2, ncol=2)

rmvn.eigen <- function(n,mu,Sigma) { 
  d <- length(mu)
  ev <- eigen(Sigma, symmetric=TRUE) # 고유값
  lambda <- ev$values
  V <- ev$vectors
  R <- V%*%diag(sqrt(lambda))%*%t(V)
  Z <- matrix(rnorm(n*d), nrow=n, ncol=d)
  X <- Z%*%R+matrix(mu, n, d, byrow=TRUE)
  X
}

X <- rmvn.eigen(1000,mu,Sigma)
plot(X, xlab="x", ylab="y", pch=20) # 거의 직선 
print(colMeans(X)) # 0에 가깝
print(cor(X)) # 1에 가깝

# 다변량 정규난수: 촐레스키 분해법
rmvn.Choleski <- function(n,mu,Sigma){
  d <- length(mu)
  Q <- chol(Sigma) # Choleski factorization of Sigma
  Z <- matrix(rnorm(n*d), nrow=n, ncol=d)
  X <- Z %*% Q + matrix(mu, n, d, byrow=TRUE)
  X
}

y <- subset(x=iris, Species=="virginica")[, 1:4]
mu <- colMeans(y)
Sigma <- cov(y)
mu
Sigma

X <- rmvn.Choleski(200, mu, Sigma)
pairs(X)

# 다변량 정규난수 생성기 비교
library(MASS)
library(mvtnorm)
n <- 100            # sample size
d <- 30             # dimension
N <- 2000           # iterations
mu <- numeric(d)
set.seed(100)
system.time(for (i in 1:N) # 분광분해
  rmvn.eigen(n, mu, cov(matrix(rnorm(n*d), n, d))))
set.seed(100)
system.time(for (i in 1:N) # 촐레스키분해; 효율적
  rmvn.Choleski(n, mu, cov(matrix(rnorm(n*d), n, d))))
set.seed(100)
system.time(for (i in 1:N) # mvrnorm
  mvrnorm(n, mu, cov(matrix(rnorm(n*d), n, d))))
set.seed(100)
system.time(for (i in 1:N) # rmvnorm
  rmvnorm(n, mu, cov(matrix(rnorm(n*d), n, d))))
set.seed(100)
system.time(for (i in 1:N) # 공분산행렬; 별 의미없음
  cov(matrix(rnorm(n*d), n, d)))