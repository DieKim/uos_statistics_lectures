### ·Î¶Ç È®·ü ¾Ë°í¸®Áò ###

# ·Î¶Ç 5µî ´çÃ· È®·ü

lotto_1 = function(N){
  y = rep(NA,N)
  for(i in 1:N){
    LOTTO = sample(1:45, 6)
    MINE = sample(1:45, 6)
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

lotto_1(10^5)

# ·Î¶Ç 3µî ´çÃ· È®·ü

lotto_3 = function(N){
  y = rep(NA,N)
  for(i in 1:N){
    LOTTO = sample(1:45, 6)
    MINE = sample(1:45, 6)
    WIN = sum(MINE %in% LOTTO) == 5
    if(WIN){
      y[i] = T
    }else{
      y[i] = F
    }
  }
    Out = sum(y)/N
    return(Out)
}

lotto_3(10^5)

# ·Î¶Ç 2µî ´çÃ· È®·ü

lotto_2 = function(N){
  y = rep(NA,N)
  for(i in 1:N){
    LOTTO = sample(1:45, 7)
    MINE = sample(1:45, 6)
    WIN = sum(MINE %in% LOTTO[1:6]) == 5 && LOTTO[7] == MINE[!(MINE %in% LOTTO[1:6])]
    if(WIN){
      y[i] = T
    }else{
      y[i] = F
    }
  }
  Out = sum(y)/N
  return(Out)
}

lotto_2(10^5)

