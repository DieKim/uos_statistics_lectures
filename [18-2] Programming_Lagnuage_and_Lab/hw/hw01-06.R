### Homework 1 ###

hwfunction = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x_old = sample(c(0,1),1)     #sample; c(0,1) 중 임의로 1개를 선택해라
    x_new = sample(c(0,1),1)
    num_of_iter = 2   #던진 횟수
    while(!all(c(x_old,x_new)==c(1,0))){    #while; ()동안 계속 반복해라; ()거짓이 될때까지 돌려라
      num_of_iter = num_of_iter + 1         #all; ()가 모두 참이냐
      x_old = x_new
      x_new = sample(c(0,1),1)
    }
    y[iter] = num_of_iter   
  }
  return( mean(y) )     #return; ()를 내보내라
}

hwfunction(10^3)
hwfunction(10^4)
hwfunction(10^5)
hwfunction(10^6)

!(x_old == 1 && x_new == 0)

######################################

### Homework 2 ###

#2-1
HW21Function = function(ITER){
  y = rep(NA, ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while(!all(c(x1,x2,x3) == 0)){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = x3
      x3 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

HW21Function(10^3)
HW21Function(10^4)
HW21Function(10^5)
HW21Function(10^6)

#2-2
HW22Function = function(ITER){
  y = rep(NA, ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while(!all(c(x1,x2,x3) == c(0,1,0))){
      num_of_iter = num_of_iter + 1
      x1 = x2 
      x2 = x3
      x3 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

HW22Function(10^3)
HW22Function(10^4)
HW22Function(10^5)
HW22Function(10^6)

######################################

### Homework 3 ###

#%in%; 앞에 것 기준으로 몇개가 겹치는지(교집합?)

HW31Funtion = function(N){
  y = rep(NA,N)
  for(i in 1:N){
    LOTTO = sample(1:45,7)
    MINE = sample(1:45,6)
    WIN = sum( MINE %in% LOTTO[1:6] ) == 5 && LOTTO[7] == MINE[!(MINE %in% LOTTO[1:6])]
    if(WIN){
      y[i] = T
    }else{
      y[i] = F
    }
    }
  Out = round(sum(y)/N, digits = 10)   #숫자가 너무 작아서 반올림
  return( Out )
}

HW31Funtion(10^6)
HW31Funtion(10^7)
HW31Funtion(10^8)

### HOMEWORK 4 ###

# Input : 3진수의 수
# Output : 변환된 10진수의 수

HW4 = function(Input){
  if( Input == 0 ){
    Output = 0
  }else {
    k = floor(log(Input, base = 10))
    a = rep(NA, k+1)
    l = length(a)
    for( i in 1:l ){
      a[i] = Input%/%10^(l-i)
      Input = Input%%10^(l-i)
    }
    Output = 0
    for( j in 1:l ){
      Output = Output + a[j]*(3^(l-j))
    }
  }
  return(Output)
}

HW4(0)
HW4(12)
HW4(221)

### HOMEWORK 5 ###

HW5 = function(Input){
  if(Input == 0){
    Output = 0
  }else{
    a = floor(log(Input,2)) + 1
    b = rep(NA,a)
    Output = 0
    for(i in 1:a){
      b[i] = Input %/%(2^(a-i))
      Input = Input %%(2^(a-i))
    }
    l = length(b)
    for(j in 1:l){
      Output = Output + b[j]*10^(l-j)
    }
  }
  return(Output)
}

HW5(0)
HW5(10)
HW5(2)

### HOMEWORK 6 ###

HW6 = function(Input){                          
  x = rep(NA, times = ncol(Input))                      
  x = (sapply(Input, class) == "numeric")
  Input_numeric = data.frame(Input[,x])
  
  mean = sapply(Input_numeric, mean)
  median = sapply(Input_numeric, median)
  quartile1 = sapply(Input_numeric, quantile)[2,]
  range = sapply(Input_numeric, range) ; rownames(range) = c("range.from", "range.to")
  IQR = sapply(Input_numeric, IQR)
  variance = sapply(Input_numeric, var)
  
  Output = list(n = nrow(Input),
              p = ncol(Input),
              center = rbind(mean = mean, median = median, quartile1 = quartile1),
              dispersion = rbind(range = range, IQR = IQR, variance = variance))
  
  return(Output)
}

HW6(iris)

### HOMEWORK 7 ###

HW7 = function(data, K, iter.max){
  data_mat = as.matrix(data) 
  n = nrow(data_mat)
  p = ncol(data_mat)
  
  if(length(K) == 1){
    center_mat = data_mat[sample(1:n, K), ]
  } else {
    center_mat = K
    K = nrow(center_mat)
  }
  dist = matrix(nrow = n, ncol = K)
  iter = 1
  while (iter < iter.max) {
    iter = iter + 1
    
    for(i in 1:K){
      dist[,i] = apply( data_mat, 1, function(x)  sum( abs(x -  center_mat[i,]) )  ) 
    } 
    cluster = apply(dist, 1, which.min)
    
    
    for(i in 1:K){
      center_mat[i, ] = colMeans(data_mat[cluster == i, ])
    } 
    
    
  }
  
  
  return(cluster)
}
HW7(iris[,1:2],2,50)
HW7(iris[,1:2],3,50)
HW7(iris[,1:2],4,50)

par(mfrow = c(1,3))
plot(iris[,1:2], col =HW7(iris[,1:2],2,50))
plot(iris[,1:2], col =HW7(iris[,1:2],3,50))
plot(iris[,1:2], col =HW7(iris[,1:2],4,50))




