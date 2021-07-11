### Ch1 부동소수점과 오차 ###

# 부동소수점; in 컴퓨터, 실수 -> 2진수의 근사값으로 변환 by 부동소수점 형식  
# 오차; 절대오차/상대오차/마무리오차 등 참값과 근사값의 차이
# 오버플로우; 범위를 벗어나는 큰 값인 경우 -> 무한 또는 NaN으로 처리
# 언더플로우; 범위 사이 오차 -> 0으로 값 선택
# 유효숫자; 0이 아닌 첫 자리부터 연속적으로 동일한 자리의 개수

###############################################################################

### 예제1; 동치인 함수 ### 

# 1. f(x) = (1-cos x)/x^2: 0근방에서 부동소수점연산에 의해 오차가 생김
# 0/0 꼴 이므로 오차 발생 

evaluatefunction1 = function(xmin,xmax,n){ # n; 구간 수
  x = c(0)
  f = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    f[i+1] = (1-cos(x[i+1]))/(x[i+1])^2
  }
  plot(x,f,type="l",col="blue",xlab="x",ylab="function")
}

evaluatefunction1(-1,1,100) # 0 근방에서 불연속
evaluatefunction1(-10^-7, 10^-7, 200) # 0 근방에서 불안정하므로

# 2. 동치인 함수 f(x) = (sin^2(x/2))/(x^2/2)를 고려하면
# 0근처에서 오차의 영향을 줄일 수 있지만 여전히 0에서 불연속

evaluatefunction2 = function(xmin,xmax,n){
  x = c(0)
  f = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    f[i+1] = (sin(x[i+1]/2))^2/((x[i+1])^2/2)
  }
  plot(x,f,type="l",col="blue",xlab="x",ylab="function")
}

evaluatefunction1(-1,1,100) # 여전히 0 근방에서 불연속 
evaluatefunction2(-10^-7, 10^-7, 200) # 아까보다는 안정적이지만 역시 불연속

# 3. f(x) = (sin^2(x/2))/(x^2/2): 0에서 연속이 되도록 정의

evaluatefunction2withcheck = function(xmin,xmax,n,epsilon){ # 입실론 값을 추가로 받음 
  x = c(0)
  f = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    if (abs(x[i+1]) > epsilon){
      f[i+1] = (sin(x[i+1]/2))^2/((x[i+1])^2/2)
    }
    else{
      f[i+1] = 1/2 # 0 근방에서 1/2로 정의
    }
  }
  plot(x,f,type="l",col="blue",xlab="x",ylab="function")
}

evaluatefunction2withcheck(-1,1,100,10^-10) # 0에서 연속 
evaluatefunction2withcheck(-10^-7, 10^-7, 200, 10^-10) # 0에서 연속 

### 예제2; n차 다항식의 계산 ###

# 1. 직접 계산

polyeval = function(a,x0){
  n = length(a) - 1
  polyvalue = a[1]
  for (j in (1:n)){
    polyvalue = polyvalue + a[j+1]*(x0)^j # 멱급수 계산; cost가 큰 계산
  }
  return(polyvalue)
}

# 2. 멱급수 계산을 하지 않도록 수정

polyevalimproved = function(a,x0){
  n = length(a) - 1
  polyvalue = a[1]
  powersofx0 = 1
  for (j in (1:n)){
    powersofx0 = x0*powersofx0
    polyvalue = polyvalue + a[j+1]*powersofx0
  }
  return(polyvalue)
}

# 3. Horner의 알고리즘; 점화식 이용 

polyevalhorner = function(a,x0){
  n = length(a) - 1
  polyeval = a[n+1]
  for (j in (1:n)){
    polyeval = a[n+1-j] + x0*polyeval
  }
  return(polyeval)
}

# 4. p(x) = (x-2)^{10}를 $x=2.01$에서 계산하는 경우 
# 계산결과가 rounding error에 의해 달라짐

a = c(1024, -5120, 11520, -15360, 13440, -8064, 3360, -960, 180, -20, 1)

polyeval(a, 2.01) 
polyevalimproved(a, 2.01)
polyevalhorner(a, 2.01)

# 5. p(x) = (x-1)^3 = x^3 - 3x^2 + 3x - 1를 x = 1에서 계산

polyevalhornermultiple = function(a,xmin,xmax,n){
  x = c(0)
  y = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    y[i+1] = polyevalhorner(a,x[i+1])
  }
  plot(x,y,type="l",col="blue",xlab="x",ylab="function",cex.axis=1.5,cex.lab=1.5)
}

polyevalhornermultiple(-c(1,-3,3,-1), 0.99999, 1.00001, 200) # 1 근처에서 쭈글쭈글
curve((x-1)^3, from=0.99999, to=1.00001) # 매끄러움 

### 예제3; 행렬계산 ### 

# epsilon이 작은 경우;
# 역행렬이 존재하지만 수치적으로는 존재하지 않는 것처럼 보임 

# 1
epsilon = 10^-10
A = matrix(c(1, epsilon, 0, 1, 0, epsilon), nrow=3)
A
B = t(A) %*% A
B

# 2
epsilon = 10^-10
v = c(1, epsilon, -1)
w = c(1, epsilon, 1)
t(v) %*% w

### 예제4; 실수의 비교시 주의 ###

# 실수 비교 시 '=='를 사용하면 안 되고 all.equal() 함수 이용

.2 == .3 - .1 # 같아야 하는데 FALSE가 나옴; 변환과정에서 오차 발생  
isTRUE(all.equal(.2, .3 - .1))
all.equal(.2, .3)         
isTRUE(all.equal(.2, .3)) 

