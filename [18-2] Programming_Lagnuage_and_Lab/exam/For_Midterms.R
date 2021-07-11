### n진수 10진수로 변환 함수 ###

ThreeFunction = function(Input){
  if( Input == 0 ){
    Output = 0
  }else {
    k = floor(log(Input, base =10))
    a = rep(NA, k+1)
    l = length(a)
    for(i in 1:l){
      a[i] = Input %/% 10^(l-i)
      Input = Input %% 10^(l-i)
    }
    Output = 0
    for( j in 1:l ){
      Output = Output + a[j]*(3^(l-j))
    }
  }
  return(Output)
}

ThreeFunction(0)
ThreeFunction(22)
ThreeFunction(121)

FourFunction = function(Input){
  if( Input == 0 ){
    Output = 0
  }else {
    k = floor(log(Input, base = 10))
    a = rep(NA, k+1)
    l = length(a)
    for( i in 1:l ){
      a[i] = Input %/% 10^(l-i)
      Input = Input %% 10^(l-i)
    }
    Output = 0
    for( j in 1:l ){
      Output = Output + a[j]*(4^(l-j))
    }
  }
  return(Output)
}

FourFunction(0)
FourFunction(12)
FourFunction(321)

###########################################################

### 뉴턴 - 랩슨 방법; 방정식의 근 찾기 ###

# Part 1
# f(x) = 0의 해를 근사적으로 찾을 때 사용
# 도함수 f'(a)를 이용한 1차 근사함수를 이용
# f(x)=0 인 x를 찾고 싶은데 해를 모른다고 하자, 
# 이때 x=a를 넣고 f(a)의 값을 살펴본다
# 만약 f(a)>0이고 f'(a)>0 이라면 x<a임이 자명
# 알고리즘 구조
# 1. x_old 설정
# 2. f(x_old) 구한다
# 3. f'(x_old) 구한다
# 4. x_new := x_old - (f(x_old)/f'(x_old))
# 5. 조건을 충족할 때까지 반복
# 종료 조건
# 1. x값의 변화가 거의 없을 때 
# 2. f(x) = 0 인 경우
# 3. x_old의 값이 주어진 구간을 벗어난 경우
# 4. f가 x_old 에서 미분 불가능인 경우

############################################

### 실습 ###

f = function(x){
  (x-1)^2
}

df = function(x){
  2*(x-1)
}

ddf = function(x){
  2
}

newton_method <- function(f, df, x_0, 
                          
                          stop_criteria = .Machine$double.eps, 
                          
                          max_iter = 10^3, 
                          
                          left_b = -Inf, 
                          
                          right_b = Inf){ 
  
  # criteria for starting point x_0 
  
  if (left_b > x_0 | right_b < x_0){ 
    
    warning("your starting point is out of bound, please try point in the bounds") 
    
    return(NA) 
    
  } 
  
  
  # variable initialization 
  
  iters <- 0 
  
  #x_0 <- sample(1:100, 1) 
  
  distance <- Inf 
  
  # do while until # 1) x does not move 
  
  # 2) exceed the maximun iteration 
  
  # 3) the function value become close to zero 
  
  while ( 
    
    (distance > stop_criteria) 
    
    & (iters < max_iter) 
    
    & (abs(f(x_0)) > stop_criteria) 
    
  ){ 
    
    # newton method 
    
    x_1 <- x_0 - ( f(x_0) / df(x_0) ) 
    
    
    
    # out of bound case 
    
    if (x_1 <= left_b) { 
      
      x_1 <- left_b 
      
    } 
    
    if (right_b <= x_1){ 
      
      x_1 <- right_b 
      
    } 
    
    distance <- abs(x_0 - x_1) 
    
    iters <- iters + 1 
    
    x_0 <- x_1 
    
  } 
  
  # return the final point 
  
  if (x_0 == left_b | x_0 == right_b){ 
    
    warning("\n", "Final point is on the boundary", "\n") 
    
  } 
  
  if (iters > max_iter){ 
    
    warning("\n", "Cannot find the root during the iteration.", "\n") 
    
  } 
  
  cat("Final value of function:", f(x_0), "\n") 
  
  return(  c(root = x_0, num_of_iterations = iters )  )
  
}  

# 뉴턴랩슨법으로 최대최소 찾기
# x_new := x_old - (f'(x_old)/f''(x_old))

### 뉴턴랩슨 방법 ###

fffunction = function(df, ddf, x0, max_iter, threshold){
  x1 = x0 - f(x0)/df(x0)
  iter = 0
  while(f(x1) != 0 && abs(x1-x0)> threshold && iter < max_iter){   # while은... 거짓이 되면 멈춰... 
    iter = iter + 1
    x0 <- x1
    x1 <- x0 - df(x0)/ddf(x0)
    
  }
  return(c(x1, iter))
}
fffunction(f, df, 100, max_iter = 10^4, threshold = 0)

f(1)

f = function(x){
  return(2*x^4 + 3*x^2 + 5*x + 6)
}

df = function(x){
  return(8*x^3 + 6*x + 5)
}

ddf = function(x){
  return(24*x^2 + 6)
}

newton_method = function(df, ddf, x0, max_iter, threshold){
  x1 = x0 - (df(x0)/ddf(x0))
  iter = 0
  while( f(x1) != 0 && abs(x1-x0)> threshold && iter < max_iter ){
    iter = iter + 1
    x0 = x1
    x1 = x0 - (df(x0)/ddf(x0))
  }
  return(c(x1,iter))
}

newton_method(df, ddf, 3 , max_iter = 10^3, threshold = 0)

######################################################################

### 동전 던지기 함수 ###

coinfunction = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x_old = sample(c(0,1),1)
    x_new = sample(c(0,1),1)
    num_of_iter = 2
    while( any( c(x_old, x_new) == 0 ) ){
      num_of_iter = num_of_iter + 1
      x_old = x_new
      x_new = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction(10^3)
coinfunction(10^4)

coinfunction = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x_old = sample(c(0,1),1)
    x_new = sample(c(0,1),1)
    num_of_iter = 2
    while( any( c(x_old, x_new) == c(0,1) ) ){
      num_of_iter = num_of_iter + 1
      x_old = x_new
      x_new = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction(10^3)
coinfunction(10^4)

coinfunction = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while( any( c(x1, x2, x3) == c(0, 0 ,0) ) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = x3
      x3 = sample(c(0,1),1)
    }
      y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction(10^3)
coinfunction(10^4)

coinfunction = function(ITER){
  y = rep(NA, ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while( any( c(x1,x2,x3) != c(0,1,0) ) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = x3
      x3 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction(10^3)
coinfunction(10^4)

x1=1
x2=1
# while(sum(c(x1,x2) == c(0,1)) != 2)

#####################################################

### 로또 확률 함수 ###

# %in% 함수; 앞에 것 기준으로 겹치는지 알려줌

A = sample(1:10, 3)
B = sample(1:10, 3)
C = A %in% B  # TRUE or FALSE
sum(C)   # 몇 개가 겹치는 지 알 수 있음  

lottofunction = function(N){
  y = rep(NA, N)
  for( i in 1:N ){
    LOTTO = sample( 1:45 , 7 )
    MINE = sample( 1:45, 6 )
    WIN = sum( MINE %in% LOTTO[1:6] ) == 5 && LOTTO[7] == MINE[!(MINE %in% LOTTO[1:6])]
    if(WIN){
      y[i] = T
    }else {
      y[i] = F
    }
  }
  Out = sum(y)/N
  return(Out)
}

lottofunction(10^6)

lottofunction = function(N){
  y = rep(NA, N)
  for( i in 1:N ){
    LOTTO = sample( 1:45 , 6 )
    MINE = sample( 1:45, 6 )
    WIN = sum(MINE %in% LOTTO) == 3
  if(WIN){
    y[i] = T
  }else {
    y[i] = F
  }
  }
  Out = sum(y)/N
  return(Out)
}

lottofunction(10^6)

### 문제 내기 알고리즘 ###

# 1-50 숫자 맞추기 

guessfunction = function( up = 50,
                          down = 1){
  n = sample(up:down, 1)
  x = 0
  iter = 0
  while( n != x && iter < 5){
    if(x>n){
      up = x-1
    }else{
      down = x+1
    }
    print(paste0("Guess the number between ", down, " and ", up))
    x = scan(n=1)
    iter = iter + 1
  }
  if( n == x){
    Out = paste0("You win! Only ", iter, " times" )
  }else{
    Out = "Fail"
  }
  return(Out)
}
guessfunction()

# +,-,* 랜덤 문제 내기 

a = sample(1:10, 1)
b = sample(1:10, 1)
p = sample(1:3, size = 1, prob = c(1/4, 1/4, 1/4))
if(p == 1){
  print(paste0(a, " + ", b ))
  solution = a + b
}else if(p == 2){
  print(paste0(a,"-",b))
  solution = a - b
}else if(p == 3){
  print(paste0(a,"*",b))
  solution = a * b
}
x = scan(n = 1)
iter = 1
while ( x != solution  && iter < 5 ) {
  x = scan(n = 1)
  iter = iter +1   
}
print(paste0("WIN"))



  