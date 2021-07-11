### Ch6 확률난수의 발생 - Part1 ###

# part1; 일반적인 방법들

# 1. 역변환법(inverse transform method)
# 역확률 적분변환; 분포함수의 역함수를 구하기 쉬울 때
# u=F(x), u~U(0,1)를 만족하는 x는 F를 따름
# 예제1; 지수분포(연속형)
# 예제2; 베르누이분포(이산형) -> 구간이 많아지면 비교횟수가 늘어 비효율적

# 2. 기각법(rejection metod)
# 분포함수의 역함수를 구하기 어렵거나 계산이 어려울 때
# X의 pdf; f(x)=c*h(x)*g(x)
# h(x)의 분포함수 H(x)의 역함수가 구하기 쉽다고 가정
# c*h(x); 비교함수, 채택역을 잘 잘 잡아야 효율적 
# 알고리즘
# (i) 서로 독립인 한 쌍의 균일난수 (u1,u2) 생성
# (ii) y=H^-1(u1) by 역변환법
# (iii) u2<g(y)이면 y를 확률난수로 선택, 아니면 기각
# 예제1; 정규분포(연속형)
# 예제2; 이항분포(이산형) -> 분포함수로 코쉬분포를 많이 사용

# 3. 분해법(decomposition method)
# 분포함수를 상대적으로 난수발생이 용이한 분포의 가중합으로 표현
# 알고리즘 
# (i) 균일난수 u 발생
# (ii) u가 가중합 사이로 표현되면 해당 분포 F를 선택
# (iii) 선택한 분포 F에서 확률난수 생성 by 역변환법 or 기각법
# 예제1; 이중지수분포(연속형)

# 4. 회선법(convolution method)
# iid 확률변수들의 선형결합이 특정 분포를 따를 때
# 예제1; iid 베르누이 합 ~ 이항분포

#####################################################################################

## r의 난수발생 함수

# Bernoulli r.v.
set.seed(23207) # 시드값 고정
guesses = runif(20) # uniform에서 20개 생성
correct.answers = (guesses < 0.2) # R에서 괄호(); 논리식 
correct.answers # 0.2보다 작은 값을 T/F로 변환
table(correct.answers) # table로 확인 -> 난수가 많을 수록 이론값에 가까워짐

# Binomial r.v.
dbinom(x=4, size=6, prob=0.5)	# dbinom; 확률값=Pr(X=4) 
pbinom(4, 6, 0.5) # pbinom; 누적확률값=Pr(X <= 4)
qbinom(0.89, 6, 0.5) # qbinom; 분위수=89 percentile

defectives = rbinom(24, 15, 0.1) # rbinom; 난수 생성
defectives # E(X)=1.5; 대부분 그 근처의 값을 얻을 거임
any(defectives > 5) # 없음 

# Poisson r.v.
dpois(x=3, lambda=0.5) # dpois; 포아송 확률값
rpois(10, 3.7) # rpois; 포아송 난수 발생

# exponential r.v.
pexp(1, rate = 3) # pexp; 지수분포 확률값=Pr(X<=1)

# normal r.v.
qnorm(0.95, 0, 1)
qnorm(0.95, mean=2.7, sd=3.3) # qnorm; 분위수
rnorm(10,-3,0.5) # rnorm; 난수 발생

# x ~ N(0,1) conditional on 0<x<3
x = rnorm(10000) # 10000개 생성
x = x[(0<x) & (x<3)] # 조건에 맞는 X
hist(x, probability=T) # 히스토그램

# multivariate normal r.v.
library(MASS)
mu = c(0, 1)
sigma = matrix(c(1, 0.5, 0.5, 1), 2, 2, byrow = T)
mvrnorm(10, mu, sigma) # mvrnorm; 다변량정규분포 난수 생성

## 일반적인 난수 발생법

# 역변환법
rexponential = function(n, lambda) # 지수분포; 사실 굳이?
{
  if (lambda <= 0) stop("lambda should be positive") # lambda 양수 조건
  return(-log(runif(n))/lambda)
}

rBernoulli = function(n, p) # 베르누이 
{
  if (p<0 || p>1) stop("p should be in [0,1]")
  q = 1 - p
  return(ceiling(runif(n)-q))
}

# 기각법
rnormal = function(n, mu=0, std=1) # 정규분포; 오류
{
  if (std<=0) stop("std should be positive")
  r = rep(0, n)
  for (i in 1:n) 
  {
    repeat
    {
      u = runif(2)
      u = - log(u)
      if (u[2] > (u[1]-1)^2)
        r[i] = u[1]
        if (runif(1) < 0.5) r[i] = -r[i]
        break
    }
  }
  r = std*r + mu
  return(r)
}

rbinomial.rejection = function(n, size, prob) # 이항분포
{
  if (prob<0 || prob>1) stop("prob must be in [0,1]")
  p = ifelse(prob<=0.5, prob, 1-prob) # 생략가능
  a = sqrt(2*size*p*(1-p))
  x0 = size*p
  rbinom = rep(0, n)
  for (i in 1:n)
  {
    repeat
    {
      u12 = runif(2)
      yx0 = a * tan(pi*u12[1])
      y = yx0 + x0
      gx = 1.2*a*(1+yx0^2/(a^2))*dbinom(as.integer(y), size, p)
      if (u12[2] <= gx) break
    }
    rbinom[i] = as.integer(y)
  }
  rbinom = ifelse(prob<=0.5, rbinom, size - rbinom) # 생략가능
  
  return(rbinom)
}
