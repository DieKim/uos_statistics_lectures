### Q1 ###

# 적중법
f = function(x){return((1/sqrt(2*pi))*exp((-x^2)/2))} # 표준정규분포 pdf
integrate(f,0,1) # I; 수치적분 값

HitMiss = function(n,a,b,c){
  x = runif(n,a,b) # x~U(a,b)
  y = runif(n,0,c) # y~U(0,c)
  p = mean((f(x)-y)>0) # Hit or Miss
  area = p*((b-a)*c) # 적분값
  alpha=0.01 # 신뢰도
  error=10^(-3) # 오차한계
  N = (c^2*(b-a)^2*p*(1-p))/(alpha*(error^2)) # 표본의 수
  return(list(area=area, N=N))
}

f(0); f(1); # for c값 결정
HitMiss(10^6,0,1,0.4)

# 표본평균 몬테칼로 적분법
f2 = function(x){return(exp(-x^2)/(2*pi))}
integrate(f2,0,1) # I2

SampleMean = function(n,a,b){
  x = runif(n,a,b)
  area = mean(f(x))*(b-a) # 적분값
  alpha=0.01 # 신뢰도
  error=10^(-3) # 오차한계
  I = 0.3413447 
  I2 = 1.1188908 # integrate(f2,0,1)
  N = ((b-a)*I2-I^2)/(alpha*error^2) # 표본의 수
  return(list(area=area, N=N))
}
SampleMean(10^6,0,1)

# 비교
system.time(HitMiss(10^6,0,1,0.4))
system.time(SampleMean(10^6,0,1))

### Q2 ###

# (a) 이론적인 추정값 
set.seed(2020)
U = runif(10000); e=exp(1)
X = exp(U); Y = exp(1-U)

# cf
e-(e-1)^2 # Cov
e^2-1 + 2*e - 4*(e-1)^2 # Var
v1 = (e^2-1)/2-(e-1)^2 # V1
v2 = v1-12*((1-(e-1)/2)^2) # V2
100*(v1-v2)/v1 # 분산감소비율

# (b) 분산감소비율에 대한 경험적인 추정값 
g = function(x){
  return(exp(x))
} 

I1=c(); I2=c(); 
Var12 = function(){
  for(i in 1:1000){
    x = runif(100)
    I1[i] = mean(g(x)) # 표본평균 몬테칼로 적분법                                    
    I2[i] = sum((g(x)+g(1-x))/(2*100)) # 대조변수법
  }
  ss = apply(cbind(I1,I2), 2, sd)
  return((ss[1]^2-ss[2]^2)/ss[1]^2)
}

tmp=c()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
for(i in 1:1000){
  tmp[i]=Var12()
}
mean(tmp)

### Q3 ###

m = 10000
theta.hat = se = numeric(2)
g = function(x){x^2*exp(-x^2/2)/sqrt(2*pi)*(x > 1)}

library(VGAM)
curve(g(x), xlim=c(1,10), type='l') # g(x)
curve(dweibull(x,3,2), xlim=c(1,10), type='l') # Weibull
curve(drayleigh(x,1), xlim=c(1,10), type='l') # Rayleigh

# f1; 와이블 분포
w = rweibull(m,3,2)          
phi1 = g(w)/dweibull(w,3,2)
theta.hat[1] = mean(phi1)
se[1] = sd(phi1)

# f2; 레일리 분포
r = rrayleigh(m,1)        
phi2 = g(r)/drayleigh(r,1)
theta.hat[2] = mean(phi2)
se[2] = sd(phi2)

rbind(theta.hat, se) # 1번째가 더 적은 분산 