### Ch5 균일난수의 생성과 모의실험 ###

# 1. 균일난수의 생성
# 사실 유사난수 by 컴퓨터 알고리즘
# 효율적인 유사난수 발생 알고리즘; 간단, 빠름, 긴 주기, 독립, [0,1] 균일분포 
# (1) 선형합동법; X=(a*X0+c)[Mod M]
# 간단, 빠른 연산 but 상대적으로 짧은 반복주기, 난수의 상관관계 존재 
# a; 승수, c; 증분, M; 양의 정수 -> 가능하면 긴 주기를 갖도록 선택
# a값은 완전주기 M을 만족하는 값 중 비교적 큰 값으로 결정
# Hull과 Dobell의 완전주기 M을 가질 필요충분조건
# (i) M과 c는 서로소;  최대공약수 1
# (ii) P가 M의 소인수면 (a-1)은 P로 나누어짐
# (iii) M이 4의 배수이면 (a-1)도 4로 나누어짐 
# (2) 승산합동법; X=a*X0[Mod M] 
# 선형합동법에서 c=0인 경우, 계산은 더 빠르지만 완전주기 X  
# M이 소수일 떄 최대 (M-1)까지의 주기
# (3) R의 난수발생 함수
# 난수발생기 선택; RNGkind(kind="난수발생기이름", normal.kind="정규난수발생기이름")
# seed값 저장; .Random.seed

# 2. 난수의 경험적 검정
# (1) 균일분포에 대한 검정
# (i) 카이제곱 적합도 검정; N이 크면 세트를 나누어 검정
# (ii) 콜모고로프-스미르노프 적합도 검정; ks.test()
# (iii) 그 외; 히스토그램, Q-Q 그림, 실제 백분율 등
# (2) 독립에 대한 검정
# (i) 런 검정; Up-and-Down 검정, Run above and below the mean 검정 by runs.test()
# (ii) 그 외; 포커, 자기상관, 간격 검정, 산점도 등 

# 3. 확률 모의실험 by sample()
# 뷔퐁의 바늘실험; 간격 d 평행선, 길이 l 바늘 -> 바늘이 평행선에 걸쳐질 확률

###############################################################################

# pseudo random number
runif(5) # 5개의 uniform 난수 
runif(10, min=-3, max=-1) # 10개의 uniform 난수; 최소 -3 ~ 최대 -1 사이
set.seed(32789) # seed값 부여
runif(5)
set.seed(32789)
runif(5) # 같은 seed, 같은 난수

# sample function
x = sample(1:3, size=100, replace=T, prob=c(.2, .3, .5)) # replace=T; 복원추출
table(x) # size가 커질수록 이론적 값과 같아짐

# Buffon's needle
Buffon = function(n, lofneedle, distance)
{
  lofneedle = lofneedle / 2
  distance = distance / 2
  r1 = runif(n)
  r2 = runif(n)
  prob = mean(r1*distance < lofneedle*sin(r2*pi)) # a < (l/2)*sin(theta)
  return(prob)
}
Buffon(5000,15,20)


