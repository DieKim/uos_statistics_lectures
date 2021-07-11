### n���� 10������ ��ȯ �Լ� ###

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

### ���� - ���� ���; �������� �� ã�� ###

# Part 1
# f(x) = 0�� �ظ� �ٻ������� ã�� �� ���
# ���Լ� f'(a)�� �̿��� 1�� �ٻ��Լ��� �̿�
# f(x)=0 �� x�� ã�� ������ �ظ� �𸥴ٰ� ����, 
# �̶� x=a�� �ְ� f(a)�� ���� ���캻��
# ���� f(a)>0�̰� f'(a)>0 �̶�� x<a���� �ڸ�
# �˰����� ����
# 1. x_old ����
# 2. f(x_old) ���Ѵ�
# 3. f'(x_old) ���Ѵ�
# 4. x_new := x_old - (f(x_old)/f'(x_old))
# 5. ������ ������ ������ �ݺ�
# ���� ����
# 1. x���� ��ȭ�� ���� ���� �� 
# 2. f(x) = 0 �� ���
# 3. x_old�� ���� �־��� ������ ��� ���
# 4. f�� x_old ���� �̺� �Ұ����� ���

############################################

### �ǽ� ###

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

# ���Ϸ��������� �ִ��ּ� ã��
# x_new := x_old - (f'(x_old)/f''(x_old))

### ���Ϸ��� ��� ###

fffunction = function(df, ddf, x0, max_iter, threshold){
  x1 = x0 - f(x0)/df(x0)
  iter = 0
  while(f(x1) != 0 && abs(x1-x0)> threshold && iter < max_iter){   # while��... ������ �Ǹ� ����... 
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

### ���� ������ �Լ� ###

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

### �ζ� Ȯ�� �Լ� ###

# %in% �Լ�; �տ� �� �������� ��ġ���� �˷���

A = sample(1:10, 3)
B = sample(1:10, 3)
C = A %in% B  # TRUE or FALSE
sum(C)   # �� ���� ��ġ�� �� �� �� ����  

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

### ���� ���� �˰����� ###

# 1-50 ���� ���߱� 

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

# +,-,* ���� ���� ���� 

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



  