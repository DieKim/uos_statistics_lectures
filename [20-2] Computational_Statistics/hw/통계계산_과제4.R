### chapter5; 균일난수의 생성과 모의실험 ###

# 1. 균일난수의 생성
# (1) 선형합동법; x=(a*x0+c)[mod M]
# 가능한 긴 주기가 되도록 선택
# 비교적 큰 a 선택 for 임의성 
# 완전 주기 M을 가질 필요충분조건
# (i) M과 c는 서로소
# (ii) P가 M의 소인수면 (a-1)은 P로 나뉘어짐
# (iii) M이 4의 배수이면 (a-1)도 4로 나뉘어짐
# (2) 승산합동법; x=a*x0[mod M] -> c=0인 선형합동법
# 연산이 줄어 시간은 절약되지만 완전주기 X
# (3) R의 난수발생 함수
# RNGkind; 난수발생기 선택
# .Random.seed; seed값 저장

# 2. 난수의 경험적 검정
# (1) H0: 생성된 난수가 [0,1]사이의 균일분포를 따른다 검정
# 카이제곱 적합도 검정; [0,1]을 k구간으로 나눠 검정
# 콜모고로프-스미르노프 적합도 검정; by ks.test()
# (2) H0: 생성된 난수가 독립이다 검정
# 런검정; Up-and-Down 검정, Run above and below the mean 검정 by runs.test()
# 포커, 자기상관, 간격검정, 산점도 등 

# 3. 확률 모의실험
# 모의실험; 확률적인 시험 모형에 근거한 확률행동을 모방하는 것 by sample()
# 뷔퐁의 바늘실험 
# 간격 d 평행선, 길이 l 바늘; 바늘이 평행선에 걸쳐질 확률
# 몬테칼로 실험에 의한 모수 추정 by 난수 발생

##########################################################################

### Q1 ###

# (1) 난수 100개 생성 by 승산합동법
random_uni = function(n){
  rnum = c()
  for (i in 1:n){
    seed = (16807*seed)%%2147483647
    rnum[i] = seed/2147483647
  }
  return(rnum)
}

seed=2020
rnum = random_uni(100)
rnum

# (2) 확률난수인지 확인 

# (i) 균일분포에 대한 검정

# 카이제곱적합도 검정

# 단계1; [0,1] 구간 나누기 
df = data.frame(rnum=rnum) 
df[df['rnum']>0.9]=10
df[df['rnum']<=0.9 & df['rnum']>0.8]=9
df[df['rnum']<=0.8 & df['rnum']>0.7]=8
df[df['rnum']<=0.7 & df['rnum']>0.6]=7
df[df['rnum']<=0.6 & df['rnum']>0.5]=6
df[df['rnum']<=0.5 & df['rnum']>0.4]=5
df[df['rnum']<=0.4 & df['rnum']>0.3]=4
df[df['rnum']<=0.3 & df['rnum']>0.2]=3
df[df['rnum']<=0.2 & df['rnum']>0.1]=2
df[df['rnum']<=0.1]=1

# 단계2; 난수들의 관측도수 구하기
t = as.numeric(table(df$rnum)) 
t

# 단계3; 카이제곱검정 
chisq.test(t, p=rep(1/10, 10)) # 귀무가설 기각X; 따라서 균일분포를 따른다.

# 콜모고로프-스미르노프 검정
ks.test(rnum,runif(100,0,1)) # 귀무가설 기각X; 따라서 균일분포를 따른다.

# (ii) 독립성 검정

# 런검정
library(randtests)
runs.test(rnum)

# 산점도 검정
mat = data.frame(x1=rep(0,99), x2=rep(0,99), stringsAsFactors = F)
mat[,1] = rnum[-length(rnum)]
mat[,2] = rnum[-1]
plot(mat)

### Q2 ### 

# (1) 이론적인 값 
p = (0.8)^6 # 시스템이 다운되지 않을 확률
q = 1-p # 시스템이 다운될 확률
q 

# (2) 모의실험
# 1; 시스템 다운X, 2; 시스템 다운 
set.seed(2020)
x = sample(1:2, size=1000, replace=T, prob=c(p, q))
table(x) # size가 커질수록 이론적 값과 같아짐
prob = 745/1000
prob

# 비슷하다

### Q3 ###

set.seed(2020); l=15; d=20; 
n1=10; n2=50; n3=100; n4=1000; n5=5000;

# (1) 추정값
Buffon = function(n, lofneedle, distance)
{
  lofneedle = lofneedle / 2
  distance = distance / 2
  r1 = runif(n)
  r2 = runif(n)
  prob = mean(r1*distance < lofneedle*sin(r2*pi))
  return(prob)
}
p1 = Buffon(n1,l,d) # 0.6 
p2 = Buffon(n2,l,d) # 0.52 
p3 = Buffon(n3,l,d) # 0.41
p4 = Buffon(n4,l,d) # 0.512
p5 = Buffon(n5,l,d) # 0.4844
p1;p2;p3;p4;p5

# (2) 이론값
p = (2*l)/(pi*d) # 0.4775
p

# (3) 그래프
n = c(n1,n2,n3,n4,n5) # x축; 반복수
y1 = c(p1,p2,p3,p4,p5) # 추정값
y2 = rep(p,5) # 이론값
y3 = y1-y2 # 추정값-이론값; 추정값과 이론값의 차이

plot(x=n, y=y3, xlab="반복수", ylab="추정값과 이론값의 차이", type="b") 


