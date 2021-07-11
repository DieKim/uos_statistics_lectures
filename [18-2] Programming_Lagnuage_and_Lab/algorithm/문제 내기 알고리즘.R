### 문제 내기 알고리즘 ###

# 1-50 숫자 맞추기 

guessfunction = function(up, down){
  n = sample(down:up, 1)                                # 컴퓨터가 생각한 숫자
  x = 0                                                 # 내가 말한 숫자
  iter = 0                                              # 몇번 말하고 있는 지
  while( x != n && iter < 5 ){                          # 참일 동안 돌려라. 거짓이면 멈춤
    if( x > n ){
      up = x-1
    }else if( x < n ){
    down = x+1
    }
    print(paste0("Guess the number between ", down, " and ", up))   # 여전히 while문 안에서
    x = scan(n=1)
    iter = iter + 1
  }
  if( n == x ){
    Out = print(paste0("You win in ", iter, " times!" ))
  }else{
    Out = print("You lose!")
  }
  return(Out)
}

guessfunction(up = 10, down = 1)

# +,-,* 랜덤 문제 내기 

questionfunction = function(){
  a = sample(1:10, 1)
  b = sample(1:10, 1)
  p = sample(1:3, 1, prob = c(1/3,1/3,1/3))
  x = 0
  iter = 0
  solution = 10^4
  while( x != solution && iter < 5 ){
    if( p == 1 ){
      print(paste0(a,"+",b, " = ?"))
      solution = a+b
    }else if( p == 2 ){
      print(paste0(a,"-",b, " = ?"))
      solution = a-b
    }else if( p == 3 ){
      print(paste0(a,"*",b, " = ?"))
      solution = a*b
    }
    x = scan(n=1)
    iter = iter + 1
    print("FALSE")
    }
  if( x == solution ){
  Out = print("TRUE")
  }else{
  Out = print(paste0("FALSE, The answer is ", solution ))
  }
  return(Out)
}

questionfunction()

