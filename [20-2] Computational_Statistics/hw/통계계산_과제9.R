### Q1 ### 

eps = 1e-5 # 오차한계
theta = diff = 0.5 # 초기값
k = 0
result = c(k, theta, diff)
while(diff > eps) { 
  y = 44 * theta / (theta+1) # 기대화 단계
  th_hat = 3/2 * (y/(y+19)) # theta에 대한 추정값
  diff = abs(theta - th_hat) # 업데이트
  theta = th_hat # 업데이트
  k = k + 1 # 업데이트
  result = rbind(result, c(k, theta, diff)) # 결과값
}
round(result, 8) # 10번째 단계만에 끝

### Q2 ###

# 1. 혼합분포에서 N=1000개의 난수 발생
set.seed(2020)
rnum=c()
for(i in 1:1000){
  r=runif(1, 0, 1)
  if(r<0.4){
    rnum[i]=rexp(1, 2)
  }else{
    rnum[i]=rexp(1, 3)
  }
}

rnum

# 2. EM 알고리즘에 의해 모수 추정 
Log.lik = function(x, R=2,rate, prior)
{
  lik = 0
  for (r in 1:R)
    lik = lik + prior[r] * dexp(x,rate[r])
  return(sum(log(lik)))
}

Normal.Mixture = function(X, R=2, maxiter=100, eps=1e-5)
{
  # 초기화
  X = as.vector(X)
  N = length(X)
  rate = prior = rep(0, R)
  gama = matrix(0, R, N)
  # 초기치 할당
  prior = rep(1/R, R)
  kmfit = kmeans(X, R)
  rate = 1/kmfit$centers
  old.lik = Log.lik(X, R, rate, prior)
  track.lik = as.vector(NULL)
  track.lik = c(old.lik)
  for (i in 1:maxiter)
  {
    for (r in 1:R){
      gama[r, ] = prior[r] * dexp(X,rate[r])}
    denom = apply(gama, 2, sum)
    for (r in 1:R)
    {
      gama[r, ] = gama[r, ] / denom
      rate[r] = sum(gama[r, ]) /(t(gama[r, ]) %*% X )
    }
    prior = apply(gama, 1, sum) / N
    new.lik = Log.lik(X, R, rate, prior)
    if (abs(old.lik - new.lik) < eps * abs(old.lik)) break
    old.lik = new.lik
    track.lik = c(track.lik, old.lik)
  }
  return(list(lambda = rate, alpha = prior,
              track = track.lik, resp = gama[r,]))
}

Mixture.prob = function(x, rate, prior)
{
  R = length(rate)
  prob = 0
  for (r in 1:R)
    prob = prob + prior[r] * dexp(x,rate[r])
  return(prob)
}

fit = Normal.Mixture(rnum)
fit$lambda # lambda 추정
fit$alpha # alpha 추정

X=rnum
hist(X, nclass = 20, xlab = "X", freq = FALSE, col =10, ylim = c(0, 1))
X.grid = seq(min(X), max(X), length=100)
lines(X.grid, Mixture.prob(X.grid, fit$lambda, fit$alpha), # 추정된 확률값
     type = "l", ylab = "density", xlab = "X",
     ylim = c(0, 1), col = 1)

plot(1:length(fit$track), fit$track, # likihood의 변화; 항상 증가하는 방향
     xlab = "iteration", ylab = "Obs. log-likelihood", type = "b", 
     col = 12)

