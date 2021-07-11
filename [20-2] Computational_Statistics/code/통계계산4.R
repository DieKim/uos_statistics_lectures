### Ch3 수치적 방법 - Part2 ###

# Part2; 비선형 함수의 해법, 수치적분
# 비선형 함수의 해법; 이분법/뉴턴법
# 수치적분; 직사각형법/사다리꼴법/Simpson 적분

# 비선형 함수의 해법 

# (1) 이분법; 구간길이를 절반씩 줄여가며 근을 찾을 때까지 반복
# 주어진 구간에서 함수 f(x)가 연속
# 주어진 구간에 해가 존재할 경우 f(a)f(b)<0를 만족하는 성질 이용
# 장점; 하나의 근일 때 유용
# 단점; 수렴속도 느림/여러 해 존재 시 X/중근 존재 시 X/불연속 함수 X

# (2) 뉴턴법; 접선을 이용해 x축과 만나는 점을 이동하며 근을 찾을 때까지 반복
# 뉴턴법의 수렴은 보장되지 않지만 수렴하면 반드시 근임
# 장점; 수렴속도가 빠름
# 단점; 도함수가 존재해야함(수치적인 도함수로 대체 가능)/초기치 선택 중요

# 수치적분 

# (1) 직사각형법; x축의 각 구간을 h인 등간격으로 나누고 직사각형 근사 -> 상수
# 구분구적법과 유사
# 직사각형의 높이; 앞/중간/뒤 다 가능(중간 추천)

# (2) 사다리꼴법; x축의 각 구간을 h인 등간격으로 나누고 사다리꼴 근사 -> 선형함수
# 상수대신 선형함수에 근사; 직사각형법보다 우수
# 주오차항; 최소 구간개수 구할 때 이용(p.26 예 참고)

# (3) Simpson 적분; 2차함수로 근사
# 일반적으로 짝수개(n=2k)의 구간으로 나눔
# 구간을 적게 나눠도 정확
# 주오차항; 역시 최소 구간개수 구할 때 이용 가능

###############################################################################

### 비선형 함수의 해법 ###

# 이분법
Bisection = function(x0, x1, epsilon = 1e-5)
{
  fx0 = f(x0)
  fx1 = f(x1)
  if (fx0 * fx1 >0) # 부호 체크
    return("wrong initial values")
  error = abs(x1 - x0)
  N = 1 # 반복수
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
  }
  
  return(list(x = x2, n = N)) # 근, 반복수 반환
}

# 뉴턴법
Newton = function(x0, epsilon = 1e-5, n = 100)
{
  e = 1
  N = 1
  d = epsilon
  while (e > epsilon) # 종료규칙
  {
    N = N + 1
    if (N > n) 
      return("not converge after 100 iterations")
    x1 = x0 - f(x0) * d / (f(x0 + d) - f(x0)) # 실제 도함수 대신에 수치적인 도함수 사용 
    e = abs(x1 - x0)
    x0 = x1
  }
  
  return(list(x = x1, n = N))
}

### 수치적분 ###

# 직사각형법
Integral = function(a, b, n)
{
  integral = 0
  h = (b - a) / n
  for (i in 1:n)
    integral = integral + h * f(a + (i-1/2) * h) # 중점에서의 함수값을 높이로 이용
  
  return(integral)
}

# 사다리꼴법
Trapezoid = function(a, b, n = 50)
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

# 심슨 적분법
Simpson = function(a, b, n = 12)
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

### 예 3-1 ###
f = function(x) {x^2-3}
result = Bisection(1,2)

result # 이분법
Newton(1) # 뉴턴법; 훨씬 빠르게 수렴

# 예 3-2
f = function(x) dnorm(x)
Trapezoid(-1,1) # 사다리꼴법
Simpson(-1,1) # 심슨적분; 구간수는 더 적지만 더 정확
2*(pnorm(1)-0.5)

# 예 3-3
Trapezoid(3,4)
Simpson(3,4) # 역시 심슨적분이 더 정밀
pnorm(4)-pnorm(3) # 정규분포의 끝쪽으로 갈수록 맞히기 어려움

Trapezoid(3, 4, n=100)
Simpson(3, 4, n=24)


# *예 3-4

# F(x)(=cdf)를 구할 때는 심슨적분 이용
# F(x) = p를 구할때는 뉴턴법 이용

zq = function(p, x0=0, epsilon = 1e-5, n=100) { # zq; 백분위수 계산 함수
  f = function(x) dnorm(x)
  F = function(x){Simpson(-4, x, n=24)-p}
  e=1
  N=1
  while (e > epsilon) {
    N = N+1
    if (N>n) return("not converge after 100 iterations")
    x1 = x0 - F(x0) / f(x0)
    e = abs(x1-x0)
    x0 = x1
  }
  return(list(x1, N))
}

zq(0.9) # 심슨적분/뉴턴법 이용
qnorm(0.9) # R 내장함수 이용

