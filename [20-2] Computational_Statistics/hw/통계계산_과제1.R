### chapter 1; 부동소수점과 오차 ###

# 1; 숫자의 표현
# (1) 부동소수점수; 컴퓨터에서 실수를 표현하는 방법(2진수의 근사값)
# (2) 수의 변환; 정수부분, 소수부분

# 2; 오차
# (1) 마무리 오차; 컴퓨터에서 나타내는 실수는 근사값이므로 오차 존재
# (2) 오버플로우와 언더플로우; 부동소수점으로 표현 가능한 범위를 벗어날 경우
# (i) 오버플로우; 범위를 벗어나는 큰 값의 오차 -> 무한 or NaN
# (ii) 언더플로우; 아주 작은 값의 오차 -> 0
# (3) 유효숫자의 상실; 수학적으로는 동치, 수치적으로는 오차 존재 

### chapter 2; 알고리즘의 복잡도 ###

# 1; 프로그램 복잡도; 내적
# (1) 시간 복잡도
# (2) 메모리 비용

# 2; 복잡도의 차수(order)
# 프로그래밍 스타일 변형보다 기저 알고리즘 효율성에 관심
# 특히 n이 커질 때 관심
# 차수; 로그 < 다항 < 지수

# 3; 알고리즘의 여러가지 차수
# (1) 외판원 문제; 최단 경로 찾기기
# (2) 피보나치 수열; 재귀 < for문/while문

#### Q1 ###

#  == 연산자
.2 == .3-.1 # FALSE

# all.equal 함수
all.equal(.2, .3-.1) # TRUE

### Q2 ###

# (기본) evaluatefunctionsinc 

evaluatefunctionsinc = function(xmin,xmax,n){ 
  x = c(0)
  f = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    f[i+1] = sin(x[i+1])/x[i+1]
  }
  plot(x,f,type="l",col="blue",xlab="x",ylab="function")
}

evaluatefunctionsinc(-10,10,100) # 0 근방에서 불연속
evaluatefunctionsinc(-10^-20, 10^-20, 100) # 0 근방에서 불연속; 확대


# (수정) evaluatefunctionsincwithcheck

evaluatefunctionsincwithcheck = function(xmin,xmax,n,epsilon){ 
  x = c(0)
  f = c(0)
  for (i in (0:n)){
    x[i+1] = xmin + i*(xmax-xmin)/n
    if (abs(x[i+1]) > epsilon){
      f[i+1] = sin(x[i+1])/x[i+1]
    }
    else{
      f[i+1] = 1 # 0 근방에서 1로 정의
    }
  }
  plot(x,f,type="l",col="blue",xlab="x",ylab="function")
}

evaluatefunctionsincwithcheck(-10^-20, 10^-20, 100, 10^-30) # 0에서 연속 

### Q3 ###

# 재귀 프로그램

fib1 = function(i){
  if (i<=2){
    value = 1
  }
  else{
    return (fib1(i-1)+fib1(i-2))
  }
}

system.time(fib1(10))
system.time(fib1(20))
system.time(fib1(30))
system.time(fib1(40))

# 반복 프로그램

fib2 = function(i){
  if (i<=2){
    value = 1
  }
  else{
    value1 = 1
    value2 = 1
    for (j in 3:i){
      value = value1 + value2
      value1 = value2
      value2 = value
    }
  }
return (value)
}

system.time(fib2(10))
system.time(fib2(20))
system.time(fib2(30))
system.time(fib2(40))

