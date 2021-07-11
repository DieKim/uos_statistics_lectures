### ch7 몬테칼로 적분 ###

# 1. 몬테칼로 적분
# 다중적분의 경우, 수치적분 적용이 어려울 때 사용
# 실제 값을 계산으로 추정하지 않고 확률적으로 추정
# (1) 적중법
# 사각형 아래 면적 I의 비율; hit or miss
# (2) 표본평균 몬테칼로 적분법
# X~U(a,b)일 때 E[g(X)]를 적률법에 의해 추정

# 2. 분산감소 기법
# For 정확도
# (1) 대조변수법
# Cov(X,Y)<0이면 X와 Y가 독립인 경우보다 Z의 분산이 작아지는 성질 이용
# (2) 주표본기법
# f(x)는 [a,b]에서 정의된 확률변수 X의 pdf
# g(x)가 복잡할 때 f(x)(=pdf)를 대신 이용
# (3) 통제변수법
# 미지의 평균 I를 갖는 X를 제어하기 위해 알려진 평균을 갖는 Y 이용
# 상수 α>0를 잘 정해야 함; 파일럿 몬테칼로 실험, 단순선형회귀 등  

## 적중법
# 예 7-1; Pi 추정
myPi.1 = function(n) 
{
  x = matrix(runif(n*2), ncol=2) # n*2; (x,y)
  r = mean(apply(x^2, 1, sum) < 1)
  return(4*r)
}

myPi.1(4000000) # Pi 추정값 


## 표본평균 몬테칼로
# pi by 표본평균법
Sample.Mean = function(n) 
{
  x = runif(n)
  return(4*mean(sqrt(1-x^2)))
}

Sample.Mean(4000000) # 훨씬 정밀; 더 작은 분산


## 분산감소: 대조변수법
# 정규분포 cdf; Phi(x) = E[xe^{-(xU)^2/2}], U ~ U[0,1] 
MC.Phi <- function(x, R=10000, antithetic=TRUE) { # antitheic=TRUE; 대조변수법
  u <- runif(R/2)
  if (!antithetic) v <- runif(R/2) else # 대조변수법이 아닌 경우
    v <- 1-u
  u <- c(u, v)
  cdf <- numeric(length(x))
  for (i in 1:length(x)) {
    g <- x[i]*exp(-(u*x[i])^2/2)            
    cdf[i] <- 0.5+mean(g)/sqrt(2*pi)        
  }
  cdf
}

x <- seq(.1, 2.5, length=5)
Phi <- pnorm(x) # pnorm; 정규분포의 cdf

set.seed(123)
MC1 <- MC.Phi(x, anti = FALSE) # 대조변수법 X; 표본평균법

set.seed(123)
MC2 <- MC.Phi(x) # 대조변수법

# 추정값 비교
print(round(rbind(x, MC1, MC2, Phi), 5)) # 비슷하지만 MC2가 조금 더 정밀

# 분산 비교
m <- 1000
MC1 <- MC2 <- numeric(m)
x <- 1.95
for (i in 1:m) {
  MC1[i] <- MC.Phi(x, R=1000, anti=FALSE) # 표본평균법
  MC2[i] <- MC.Phi(x, R=1000) # 대조변수법
}
print(sd(MC1))
print(sd(MC2)) # 훨씬 작은 분산
print(100*(var(MC1)-var(MC2))/var(MC1)) # 거의 100% 분산 감소      

## 분산감소 기법: 주표본 기법
# int_0^1 exp(-x)/(1+x^2) dx
m = 10000
theta.hat = se = numeric(3)
g = function(x) { # g(x)
  exp(-x - log(1+x^2)) * (x > 0) * (x < 1)
}

# candidate 1: I(0<x<1)
x = runif(m)     
fg = g(x)
theta.hat[1] = mean(fg)
se[1] = sd(fg)

# candiate 2: exp(-x) -> 정의역이 안 맞음 
x = rexp(m, 1) 
fg = g(x) / exp(-x)
theta.hat[2] = mean(fg)
se[2] = sd(fg)

# candiate 3: 4*(pi *(1+x^2))^{-1} I(0<x<1) (Cauchy dist on (0,1))
u = runif(m)    # inverse transform method
x = tan(pi * u / 4)
fg = g(x) / (4 / ((1 + x^2) * pi))
theta.hat[3] = mean(fg)
se[3] = sd(fg)

rbind(theta.hat, se) # 3번째가 가장 좋은 값 

## 분산감소 기법: 제어변량
# E[e^U]
m <- 10000
a <- -12+6*(exp(1)-1)    # a^*
U <- runif(m)

T1 <- exp(U)                        # simple MC(심플 몬테카를로)
T2 <- exp(U)+a*(U-1/2)              # controlled(대조변수법)

mean(T1)    
mean(T2)     

100*(var(T1)-var(T2))/var(T1) # 98%정도 감소(사실 비현실적)

# a^* 추정하기
# int_0^1 e^{-x}/(1+x^2) dx
# g(x) = e^{-x}/(1+x^2)과 가까운 f(x)=e^{-.5}/(1+x^2)

f <- function(u)  exp(-.5)/(1+u^2)
g <- function(u)  exp(-u)/(1+u^2)
x <- seq(0,1,by=0.01)
plot(x, f(x), type="l", ylim=c(0,1), ylab="")
lines(x, g(x), ylim=c(0,1), lty=2)
legend("topright", 1, c("g(x)", "f(x)"), lty = c(1:2), inset = .02)

# 파일럿 스터디에 의한 a^* 추정
set.seed(510)    # needed later
u <- runif(10000)

B <- f(u)
A <- g(u)

cor(A,B)
a <- -cov(A,B)/var(B) # a에 대한 추정값      
a

# 본 모의실험
m <- 100000
u <- runif(m)

T1 <- g(u)
T2 <- T1+a*(f(u)-exp(-.5)*pi/4)
c(mean(T1), mean(T2))
c(var(T1), var(T2)) # T2가 훨씬 작음 
100*(var(T1)-var(T2))/var(T1) 
