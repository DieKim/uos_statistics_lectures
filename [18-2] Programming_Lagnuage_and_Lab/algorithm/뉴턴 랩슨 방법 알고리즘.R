### 뉴턴 랩슨 방법 ###

# 교수님 방법

newton_method <- function(f, df, x0, 
                          
                          threshold = 0,    #threshold; 오차
                          
                          max_iter = 10^3,                        #최대 돌리는 횟수
                          
                          left_b = -10,                          #왼쪽 경계
                           
                          right_b = 10){                         #오른쪽 경계 
  
  # criteria for starting point x_0 
  
  if (left_b > x0 || right_b < x0){                              #x0가 경계 밖이라면 
    
    warning("your starting point is out of bound, please try point in the bounds") 
    
    return(NA) 
    
  } 
  
  x1 = x0 - (f(x0)/df(x0))
  
  # variable initialization 
  
  iters = 0 
  
  #x_0 <- sample(1:100, 1) 
  
  distance = abs(x1-x0) 
  
  # do while until # 1) x does not move 
  
  # 2) exceed the maximun iteration 
  
  # 3) the function value become close to zero 
  
  while ( 
    
    (distance > threshold) 
    
    && (iters < max_iter) 
  
    && (f(x0) != 0) 
    
  ){ 
    
    # newton method 
    
    iter = iter + 1
    x0 = x1
    x1 <- x0 - ( f(x0) / df(x0) ) 
    
    # out of bound case                                        #x1가 경계 밖이라면
    
    if (x1 <= left_b){}
      x1 = left_b 
    }
    if (right_b <= x1){ 
      
      x1 = right_b
    } 
  } 
  
  # return the final point 
  
  if (x0 == left_b | x0 == right_b){ 
    
    warning("\n", "Final point is on the boundary", "\n") 
    
  } 
  
  if (iters > max_iter){ 
    
    warning("\n", "Cannot find the root during the iteration.", "\n") 
    
  } 
  
  cat("Final value of function:", f(x_0), "\n") 
  
  return(  c(root = x_0, num_of_iterations = iters )  )
  
# 방정식의 해 찾기
  
f = function(x){
  5*x^5 + 3*x^3 + 2*x^2 + x + 1
}

df = function(x){
  25*x^4 + 9*x^2 + 4*x 
}

ddf = function(x){
  100*x^3 + 18*x
}  
  
newton_method = function(f, df, x0, max_iter, threshold){
  x1 = x0 - (f(x0)/df(x0))
  iter = 0
  while( f(x1) != 0 && abs(x1-x0) > threshold && iter < max_iter ){
    iter = iter + 1
    x0 = x1
    x1 = x0 - (f(x0)/df(x0))
  }
  return(c(x1,iter))
}  

newton_method(f,df,1.2,max_iter = 10^3, threshold = 0)기

# 최대 최소값 찾기 <=> df = 0 을 이용 & ddf 의 부호

f = function(x){
  (x-1)^6 + 3*(x-1)^4 + 8*(x-1)^2 + 1
}

df = function(x){
  6*(x-1)^5 + 12*(x-1)^3 + 16*(x-1)
}

ddf = function(x){
  30*(x-1)^4 + 36*(x-1)^2 + 16
}

Newton_method = function(df,ddf,x0,max_iter,threshold){
  x1 = x0 -(df(x0)/ddf(x0))
  iter = 0
  while( df(x1) != 0 && abs(x1-x0) > threshold && iter < max_iter ){
  iter = iter + 1
  x0 = x1
  x1 = x0 -(df(x0)/ddf(x0))
  }
  return(c(x1,iter))
}

Newton_method(df,ddf,2,max_iter = 10^3, threshold = 0)  

new = function(df,ddf,x0,max_iter,threshold){
  x1 = x0 - (df(x0)/ddf(x0))
  iter = 0
  while( (df(x1) != 0 || ddf(x1) >= 0 ) && (abs(x1-x0)>threshold) && (iter < max_iter) ){  # 극대 극소 구분 ? 
    x0 = x1
    x1 = x0 - (df(x0)/ddf(x0))
    iter = iter + 1
  }
  return(c(x1,iter))
}

new(df,ddf,2,max_iter = 10^3,threshold = 0)









