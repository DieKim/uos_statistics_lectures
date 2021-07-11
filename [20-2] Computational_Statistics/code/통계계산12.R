## boot 함수
library(boot)
library(bootstrap)

## 표준오차에 대한 붓스트랩 추정
data(law) # 15개만 random sample
data(law82) # 원래 82개의 데이터
cor(law$LSAT, law$GPA) # 성적과 졸업시험 점수의 상관관계 
cor(law82$LSAT, law82$GPA) # 거의 비슷; 상관성 꽤 높음

B = 200 # 반복수
n = nrow(law) # 데이터 개수
R = numeric(B) # 저장할 correlation 개수

# 직접 붓스트랩 구현
for (b in 1:B) {
  i = sample(1:n, size=n, replace=T) # 복원추출
  LSAT = law$LSAT[i]
  GPA = law$GPA[i]
  R[b] = cor(LSAT, GPA)
}
print(se.R <- sd(R)) # 표준오차에 대한 추정값
hist(R, prob=TRUE) # 히스토그램; 1로 치우침

# boot 함수 이용
r = function(x, i) { # correlation을 구하는 함수
  cor(x[i,1], x[i,2])
}

obj = boot(data=law, statistic=r, R=2000) # R=B; 붓스트랩 반복수
obj

## 편의에 대한 붓스트랩 추정
theta.hat = cor(law$LSAT, law$GPA)
B = 2000
n = nrow(law)
theta.b = numeric(B)

for (b in 1:B) { # 직접 붓스트랩
  i = sample(1:n, size=n, replace=T) # 복원추출
  LSAT = law$LSAT[i]
  GPA = law$GPA[i]
  theta.b[b] = cor(LSAT, GPA)
}
bias = mean(theta.b) - theta.hat
bias


## interval estimation for sd; 구간추정
dice = c(1,2,3,2,6,6,5,1,1,1,4,2,4,1,4,5,6,6,3,2,
         5,6,4,1,2,3,2,2,5,3,5,6,1,4,4,4,3,5,5,1,
         6,1,3,3,2,5,2,2,1,4)

sd(dice)
length(dice)
boot.sample = matrix(0, 200, 50)
std = rep(0, 200)
set.seed(12345)

for(n in 1:200) {
  boot.sample[n,] = sample(dice, replace=T, 50) # size=50
  std[n] = sd(boot.sample[n,])
}

summary(std) # 200번 붓스트랩에 대한 통계량 확인 
hist(std, xlim=c(1.2,2.2), ylim=c(0,50), xlab="bootst.sd") 
quantile(std, probs=c(0.025, 0.975)) # 95% 신뢰구간 by 신뢰하한, 신뢰상한


## jackknife for patch data
data(patch, package="bootstrap") # bootstrap 패키지의 patch 데이터
n = nrow(patch)
y = patch$y # old - placebo
z = patch$z # new - old
theta.hat = mean(y)/mean(z) # | | <= .2; 차이가 거의 없음
theta.hat

# 편의
theta.jack = numeric(n)
for (i in 1:n){
  theta.jack[i] = mean(y[-i])/mean(z[-i])
}
bias = (n-1) * (mean(theta.jack) - theta.hat) # 평균값 - 원래 데이터 값
bias # -5.925762?

# 표준오차
se = sqrt((n-1)*mean((theta.jack-mean(theta.jack))^2))
print(se)

