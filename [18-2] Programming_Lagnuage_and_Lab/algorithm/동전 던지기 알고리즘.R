### 동전 던지기 알고리즘 ###

# 앞면이 2번 연속나올 때까지 평균적으로 몇 번 던지는 지

coinfunction1 = function(ITER){
  y = rep(NA, ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    num_of_iter = 2
    while( !(x1 == 0 && x2 == 0) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter 
  }
  return( mean(y) )
}

coinfunction1(10^5)

# 앞면, 뒷면 순서로 나올 때까지 평균적으로 몇 번 던지는 지

coinfunction2 = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    num_of_iter = 2
    while( !(x1 == 0 && x2 == 1) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter 
  }
  return( mean(y) )
}

coinfunction2(10^5)

# 앞면이 세번 연속 나올 때까지 평균적으로 몇 번 던지는 지

coinfunction3 = function(ITER){
  y = rep(NA,ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while( !(x1 == 0 && x2 == 0 && x3 == 0) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = x3 
      x3 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction3(10^5)

# 앞면, 뒷면, 앞면이 나올 때까지 평균적으로 몇 번 던지는 지

coinfunction4 = function(ITER){
  y = rep(NA, ITER)
  for(iter in 1:ITER){
    x1 = sample(c(0,1),1)
    x2 = sample(c(0,1),1)
    x3 = sample(c(0,1),1)
    num_of_iter = 3
    while( !(x1 == 0 && x2 == 1 && x3 == 0) ){
      num_of_iter = num_of_iter + 1
      x1 = x2
      x2 = x3
      x3 = sample(c(0,1),1)
    }
    y[iter] = num_of_iter
  }
  return( mean(y) )
}

coinfunction4(10^5)
