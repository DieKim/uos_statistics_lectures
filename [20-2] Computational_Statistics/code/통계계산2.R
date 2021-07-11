### Ch2 알고리즘의 복잡도 ###

# 알고리즘의 복잡도; 효율성 문제  

# 프로그램 복잡도; 내적 -> 시간복잡도, 메모리비용 계산

innerproduct = function(v,w){ # 단 v,w 벡터의 길이가 같아야 함
  sumvalue = 0 # 내적값
  for(i in 1:length(v)){
    sumvalue = sumvalue+v[i]*w[i]
  }
  return(sumvalue)
}

# 향상된 프로그램; 길이 체크 추가 -> 시간복잡도 비슷, 메모리비용 동일 

innerproduct = function(v,w){
  if (length(v) == length(w)){
    sumvalue = 0 
    for(i in 1:length(v)){
      sumvalue = sumvalue+v[i]*w[i]
    }
    return(sumvalue)
  } else{
    print("Vectors must have the same length!")
  }
}

# 복잡도의 차수; Big O notation으로 효율성 비교
# 입력이 큰 경우에 대한 성능비교
# 특정 프로그래밍의 변형보다 기저 알고리즘의 효울성에 관심
# 차수; 로그<다항<지수<팩토리얼

# 알고리즘의 여러가지 차수
# (1) 외판원 문제; 총 n개 도시 방문 시 최단경로
# (2) 피보나치 수열; 재귀 vs 반복문 -> 반복문이 더 효율적

# R에서 시간복잡도 확인; system.time()