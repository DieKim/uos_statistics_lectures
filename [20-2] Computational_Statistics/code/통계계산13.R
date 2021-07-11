### EM algorithm

## Example 1: multinomial 
eps = 1e-5 # 오차한계
theta = diff = 0.5 # 초기값
k = 0
result = c(k, theta, diff)

while(diff > eps) { 
  y = 125 * theta / (theta+2) # 기대화 단계
  th_hat = (34+y) / (38+34+y) # theta에 대한 추정값
  diff = abs(theta - th_hat) # 업데이트
  theta = th_hat # 업데이트
  k = k + 1 # 업데이트
  result = rbind(result, c(k, theta, diff)) 결과값
}
round(result, 8) # 6번째 단계만에 끝

## Example 2: censored data(심장병환자들의 생존시간)
y1 = c(39, 2, 101, 20, 31, 15) # 절단 x
y0 = c(118, 91, 427)           # 절단 o
n = length(c(y1,y0))
r = length(y1)

eps = 1e-5
maxiter = 1000 # 최대 반복수 지정
mu.old = mean(y1) # 초기값

for (i in 1:maxiter) {
  mu.new = (sum(y1) + sum(y0) + (n-r)*mu.old) / n
  diff = abs(mu.old - mu.new) / abs(mu.old)
  if (diff < eps) break
  cat("iter=", i, "old=", mu.old, "new=", mu.new,"\n")
  mu.old = mu.new
}

## Example 3: normal mixture

Log.lik = function(x, R=2, mu, sigma, prior) # 로그가능도 추정 함수
{   
  lik = 0
  for (r in 1:R)
    lik = lik + prior[r] * dnorm(x, mean = mu[r], sd = sigma[r]) 
  return(sum(log(lik)))
}

Normal.Mixture = function(X, R=2, maxiter=100, eps=1e-5)
{
  X = as.vector(X)
  N = length(X)
  mu = sigma = prior = rep(0, R) # 초기화
  gama = matrix(0, R, N)
  # find initial centroids using K-means clustering
  prior = rep(1/R, R) # 초기값
  kmfit = kmeans(X, R) # for 초기값 
  mu = kmfit$centers # 초기값
  sigma = sqrt(kmfit$withinss /(kmfit$size - 1))     
  old.lik = Log.lik(X, R, mu, sigma, prior) 
  track.lik = as.vector(NULL)
  track.lik = c(old.lik)
  for (i in 1:maxiter) # EM알고리즘 
  {
    for (r in 1:R)
      gama[r, ] = prior[r] * dnorm(X, mean = mu[r], sd = sigma[r])
    denom = apply(gama, 2, sum)
    for (r in 1:R)
    {
      gama[r, ] = gama[r, ] / denom
      mu[r] = t(gama[r, ]) %*% X / sum(gama[r, ])
      sigma[r] = sqrt(t(gama[r, ]) %*% (X - mu[r])^2 / sum(gama[r, ]))
    }
    prior = apply(gama, 1, sum) / N
    new.lik = Log.lik(X, R, mu, sigma, prior)
    if (abs(old.lik - new.lik) < eps * abs(old.lik))  break
    old.lik = new.lik
    track.lik = c(track.lik, old.lik)
  }
  return(list(mu = mu, sigma = sigma, prior = prior, 
              track = track.lik, resp = gama[r, ]))
}

Mixture.prob = function(x, mu, sigma, prior)
{
  R = length(mu)
  prob = 0
  for (r in 1:R)
    prob = prob + prior[r] * dnorm(x, mu[r], sigma[r]) 
  return(prob)
}

X = c(-0.39, 0.12, 0.94, 1.67, 1.76, 2.44, 3.72, 4.28, 4.92, 5.53,
      0.06, 0.48, 1.01, 1.68, 1.80, 3.25, 4.12, 4.60, 5.28, 6.22)
fit = Normal.Mixture(X)     

hist(X, nclass = 20, xlab = "X", freq = FALSE, col = 2, ylim = c(0, 1))

X.grid = seq(min(X), max(X), length=100)
plot(X.grid, Mixture.prob(X.grid, fit$mu, fit$sigma, fit$prior), # 추정된 확률값
     type = "l", ylab = "density", xlab = "X",
     ylim = c(0, 1), col = 2)
lines(sort(X), 1-fit$resp[sort(X, index.return = T, decreasing=T)$ix], # 실제값과 비교
      type = "b", col = 3)

plot(1:length(fit$track), fit$track, # likihood의 변화; 항상 증가하는 방향
     xlab = "iteration", ylab = "Obs. log-likelihood", type = "b", 
     col = 3)
