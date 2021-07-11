### chapter 3; 수치적 방법 ###

# 1; 최적화 방법
# 다차원 함수의 최적값 구하기; gradient=0이 되는 x 구하기
# (1) 최대하강법(steepest descent)
# (i) d=-gradient; x_now를 감소시킬 방향
# (ii) lambda; f(x_now+lambda*d) < f(x_now)인 lambda 찾기 by 스텝반감법
# (iii) x_next = x_now + lambda*d; 해 갱신
# (iv) 수렴조건 확인 
# (2) 뉴턴-랩슨 알고리즘
# 최대하강법보다 빠름(2차도함수까지 이용)
# (i) d=-2차gradient*gradient; x_now를 감소시킬 방향
# (ii) lambda; f(x_now+lambda*d) < f(x_now)인 lambda 찾기 by 스텝반감법
# (iii) x_next = x_now + lambda*d; 해 갱신
# (iv) 수렴조건 확인 

# 2; 기타 최적화 기법
# 제약조건이 있을 때 최적화 방법; 가용영역(만족)/비가용영역(만족X) 
# (1)선형계획법(linear programming); 선형 제약조건
# (2) 이차계획법(quadratic programming); 이차 제약조건; x'Dx 

# 2; 비선형 함수의 해법
# (1) 이분법(bisection method)
# 구간 [a,b]에 해가 존재할 경우 f(a)f(b)<0인 성질 이용
# '초기구간'을 '절반'씩 줄여가며 오차한계를 만족할 때까지 반복
# 장점; 구간 내 하나의 근이 있을 때 유용
# 단점; 수렴속도 느림
# 이분법 적용에 문제가 있는 경우
# (i) 여러 해 존재; 하나의 근만 찾아줌
# (ii) 중근 존재; 근을 찾기 어렵
# (iii) 무한 불연속 함수; 구간 안에 해가 존재하는 것으로 간주
# (2) 뉴턴법(Newton method)
# 접선이 x축과 만나는 점 이용; y=f'(x0)(x-x0)+f(x0) by 테일러 전개 
# 0~=f(x*)~=f(x0)+f'(x0)(x-x0) -> x*=x0-f(x0)/f'(x0) 반복
# 장점; 수렴속도 빠름
# 단점; 도함수를 구해야하며 초기치 선택이 중요

# 3; 수치적분
# 직사각형법 < 사다리꼴법 < 심슨법
# (*)주오차항; 최소 구간 개수 구하기
# (1) 직사각형법; 구분구적법
# (2) 사다리꼴법; 사다리꼴로 근사 
# (3) 심슨법; 2차 함수로 근사

### Q1 ###

# 함수 정의
f = function(x) # 이변수 함수; x[1](=x), x[2](=y)
{ 
  (1-x[1])^2+100*(x[2]-x[1]^2)^2 
}

df = function(x) # 1차 도함수
{
  df1 = -2+2*x[1]-400*x[1]*x[2]+400*x[1]^3
  df2 = 200*(x[2]-x[1]^2)
  df = c(df1, df2)
  return(df)
}

# (1) 최대하강법

# 방법1
lambda=1
x0=0;y0=3
x_now=c(x0,y0); fx0 = f(x_now)
i=1

for(i in 1:20){
  cat("iteration=", round(i,2))
  cat("  x_now=", round(x_now,2), "  f(x_now)=", round(f(x_now),3), "\n")
  d=-df(x_now) # 단계 1; 이동할 방향 d 선택
  x_next=x_now+lambda*d; fx = f(x_next) # 단계2; x값 갱신
  
  if (abs(fx-fx0) < 1e-5){  # 단계3; 수렴조건 확인 
    cat("final x,y=",x_next,"n=",i)
    return()
  }else{
    x_now = x_next; fx0 = fx; i=i+1 
  }
}

# 방법2
library(pracma)
optimizer1 = function(f, x0)
{
  sd = steep_descent(x0, f, maxiter = 1000, tol = 1e-5)
  cat("iterations =", round(sd$niter, 2))
  cat(" x0 =", round(sd$xmin[1], 2), " y0 =", round(sd$xmin[2], 2), " f(x0, y0) =",
      round(sd$fmin), "\n")
}

optimizer1(f, c(0,3))

# (2) 뉴튼-랩슨 알고리즘

library(numDeriv)
lambda=1
x0=0;y0=3
x_now=c(x0,y0); fx0 = f(x_now)
ddf = jacobian(df,x_now); v= solve(ddf) # 이차도함수
i=1

for(i in 1:20){
  cat("iteration=", round(i,2))
  cat("  x_now=", round(x_now,2), "  f(x_now)=", round(f(x_now),3), "\n")
  d = v %*% df(x0) # 단계 1; 이동할 방향 d 선택
  x_next=x_now+lambda*d; fx = f(x_next) # 단계2; x값 갱신
  
  if (abs(fx-fx0) < 1e-5){  # 단계3; 수렴조건 확인 
    cat("final x,y=",x_next,"n=",i)
    return()
  }else{
    x_now = x_next; fx0 = fx; i=i+1 
  }
}

# cf

library(numDeriv)
optimizer2= function(f, df, x0, tol = 1e-5, lambda=1)
{
  iters = 1
  while(sqrt(sum(df(x0)^2)) > tol)
  {
    d = - solve(jacobian(df, x0)) %*% df(x0)
    x0 = x0 + lambda*d
    iters = iters + 1
  }
  cat("iterations =", round(iters,2))
  cat(" x0 =", round(x0[1],2), " y0 =", round(x0[2],2), " f(x0, y0) =", round(f(x0), 3), "\n")
}

optimizer2(f, df, c(0,3))


### Q2 ###

# 함수 정의
f = function(x){(x-1)^1/3}

# (1) 이분법
Bisection = function(x0, x1, epsilon = 1e-5)
{
  fx0 = f(x0)
  fx1 = f(x1)
  if (fx0 * fx1 >0) # 부호 체크
    return("wrong initial values")
  error = abs(x1 - x0)
  N = 1 
  temp = data.frame(stringsAsFactors = F)
  while (error > epsilon) # 종료규칙
  {
    N = N + 1
    error = error / 2
    x2 = (x0 + x1) / 2 # 중점
    fx2 = f(x2)
    if (fx0 * fx2 < 0) # 근을 포함하는 지 체크
    {
      x1 = x2; fx1 = fx2
    } else
    {
      x0 = x2; fx0 = fx2
    }
    temp1 = data.frame(x=x2, k=N, abs=abs(x2-1))
    temp = rbind(temp, temp1)
  }
  return(temp)
}

Bisection(-1,3)
Bisection(-1,3.1)


# (2) 뉴턴법
Newton = function(x0, epsilon = 1e-5, n = 100){
  e = 1
  N = 1
  d = epsilon
  temp = data.frame(x=x0, k=0, abs=abs(x0-1))
  while (e > epsilon) # 종료규칙
  {
    N = N + 1
    if (N > n) 
      return("not converge after 100 iterations")
    x1 = x0 - f(x0) * d / (f(x0 + d) - f(x0)) # 실제 도함수 대신에 수치적인 도함수 사용 
    e = abs(x1 - x0)
    x0 = x1
    temp1 = data.frame(x=x1, k=N-1, abs=abs(x1-1))
    temp = rbind(temp, temp1)
  }
  return(temp)
}

Newton(3)
1.310241e-11 < 1e-5 # TRUE

### Q3 ###

# 함수 정의
f = function(x){3/2*sqrt(x)}

# (1) 직사각형법
Integral = function(a, b, n)
{
  integral = 0
  h = (b - a) / n
  for (i in 1:n)
    integral = integral + h * f(a + (i-1/2) * h) # 중점에서의 함수값을 높이로 이용
  
  return(integral)
}

df1 = data.frame(stringsAsFactors = F)
for(i in seq(2,20,2)){
  I = Integral(0,1,i)
  abs = abs(I-1)
  temp = data.frame(n=i, I=I, abs=abs, stringsAsFactors = F)
  df1 = rbind(df1,temp)
}

df1

# (2) 사다리꼴법
Trapezoid = function(a, b, n)
{
  h = (b - a) / n
  integral = (f(a) + f(b)) / 2 # 적분 초기값으로 끝점
  
  x = a
  n1 = n - 1
  for (i in 1:n1)
  {
    x = x + h
    integral = integral + f(x)
  }
  integral = integral * h
  
  return(integral)
}

df2 = data.frame(stringsAsFactors = F)
for(i in seq(2,20,2)){
  I = Trapezoid(0,1,i)
  abs = abs(I-1)
  temp = data.frame(n=i, I=I, abs=abs, stringsAsFactors = F)
  df2 = rbind(df2,temp)
}

df2

# (3) 심슨법
Simpson = function(a, b, n)
{
  h = (b - a) / n
  integral = f(a) + f(b) 
  x2 = a
  x3 = a + h
  even = 0
  odd = f(x3)
  h2 = 2 * h
  n1 = n / 2 - 1
  for (i in 1:n1)
  {
    x2 = x2 + h2
    x3 = x3 + h2
    even = even + f(x2)
    odd = odd + f(x3)
  }
  integral = (integral + 4 * odd + 2 * even) * h / 3
  
  return(integral)
}

df3 = data.frame(stringsAsFactors = F)
for(i in seq(2,20,2)){
  I = Simpson(0,1,i)
  abs = abs(I-1)
  temp = data.frame(n=i, I=I, abs=abs, stringsAsFactors = F)
  df3 = rbind(df3,temp)
}

df3
