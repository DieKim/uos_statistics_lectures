### Q1 ###

# 1. 표준 라플라스 분포로부터 난수발생 by 역변환법
rlaplace = function(n){
  u=runif(n)
  x=c()
  for(i in 1:n){
    if(u[i]<0.5){
      x[i]=log(2*u[i])
    }else
      x[i]=-log(2-2*u[i])
  }
  return(x)
}

set.seed(0401)
rnum = rlaplace(1000)
rnum

# 2. 확률밀도함수 vs 히스토그램
library(extraDistr) # for laplace 관련 함수
curve(dlaplace(x), xlim=c(-10,10), type='l') # pdf
hist(rnum, breaks=seq(-15,15,0.2), freq=FALSE, add=TRUE) # 히스토그램

# 3. QQ-plot
library(lattice) # for qqmath
qqmath(~rnum, distribution = function(p) qlaplace(p), xlim=c(-5,5), ylim=c(-5,5))

### Q2 ###

# 1. 난수 발생 
rdiscrete = function(n){
  u=runif(n)
  x=c()
  for (i in 1:n){
    if(u[i]<0.1) {x[i]=0}
    else if (0.1 <= u[i] && u[i] < 0.3) {x[i]=1}
    else if (0.3 <= u[i] && u[i] < 0.5) {x[i]=2}
    else if (0.5 <= u[i] && u[i] < 0.7) {x[i]=3}
    else {x[i]=4}
  }
  return(x) 
}

set.seed(2020)
rnum = rdiscrete(1000)
rnum

# 2. 이론적 확률 vs 경험적 확률
table(rnum)/1000

### Q3 ###

# 1. 코시분포로부터 난수발생
r_cauchy = function(n, alpha, beta){
  z1=rnorm(n) 
  z2=rnorm(n)
  z=alpha+(z1/z2)*beta
  return(z)
}

set.seed(2020)
rnum = r_cauchy(1000, 0, 1)
rnum

# 2. 확률밀도함수 vs 히스토그램
curve(dcauchy(x), xlim=c(-50,50), type='l') # pdf
hist(rnum, breaks=seq(-1000,1000,0.5), freq=FALSE, add=TRUE) # 히스토그램

### Q4 ###

# 1. Box-Muller 변환
Box_Muller=function(n, mu=0, std=1){
  if(std<=0) stop("std should be positive")
  r=rep(0,2*n)
  for(i in 1:n){
    u=runif(2)
    Z1=sqrt((-2)*log(u[1]))*cos(2*pi*u[2])
    Z2=sqrt((-2)*log(u[1]))*sin(2*pi*u[2])
    r[2*i-1]=Z1
    r[2*i]=Z2
  }
  r=std*r+mu
  return(r)
}

# 2. 극좌표 변환
Polar=function(n, mu=0, std=1){
  if(std<=0) stop("std should be positive")
  r=rep(0,2*n)
  i=1
  while(r[2*n]==0){
    v=runif(2,-1,1)
    w=sqrt(v[1]^2)+v[2]^2
    if(w^2<=1){
      Z1=sqrt((-2)*log(w^2))*v[1]/w
      Z2=sqrt((-2)*log(w^2))*v[2]/w
      r[2*i-1]=Z1
      r[2*i]=Z2
      i=i+1
    }
  }
  r=std*r+mu
  return(r)
}

# 3. 난수발생 및 실행시간 비교
Box_Muller(100000) 
Polar(100000)
system.time(Box_Muller(100000)) 
system.time(Polar(100000))


