### 2진수 10진수 변환 알고리즘 ###

# 2진수를 10진수로 바꾸는 알고리즘 

twofunction = function(Input){
  if( Input == 0 ){
    Output = 0
  }else {
    k = floor(log(Input, base = 10))
    a = rep(NA, k+1)
    l = length(a)
    for(i in 1:l){
      a[i] = Input %/% 10^(l-i)
      Input = Input %% 10^(l-i)
    }
    Output = 0
    for(j in 1:l){
      Output = Output + a[j]*(2^(l-j))
    }
  }
  return( Output )
}

twofunction(0)
twofunction(10)

# 3진수를 10진수로 바꾸는 알고리즘

threefunction = function(Input){
  if( Input == 0 ){
    Output = 0
  }else{
    k = floor(log(Input, base = 10))
    a = rep(NA, k+1)
    l = length(a)
    for(i in 1:l){
      a[i] = Input %/% 10^(l-i)
      Input = Input %% 10^(l-i)
    }
    Output = 0
    for(j in 1:l){
      Output = Output + a[j]*(3^(l-j))
    }
  }
  return( Output )
}

threefunction(0)
threefunction(121)
