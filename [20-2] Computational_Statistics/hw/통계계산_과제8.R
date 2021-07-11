### Q1 ###

# 1. 잭나이프 for law data
data(law, package="bootstrap")
n = nrow(law)
lsat = law$LSAT
gpa = law$GPA
theta.hat = cor(lsat, gpa)
theta.hat
theta.jack = numeric(n)

for (i in 1:n){
  lsat = law$LSAT[-i]
  gpa = law$GPA[-i]
  theta.jack[i] = cor(lsat,gpa)
}

# 2. 편의
bias = (n-1)*(mean(theta.jack)-theta.hat)
bias    

# 3. 표준오차
se = sqrt((n-1)*mean((theta.jack-mean(theta.jack))^2))
se

### Q2 ###

# 1. 붓스트랩 for aircondit data
data(aircondit, package="boot")
X = aircondit$hours
theta.hat = 1/mean(X) 
theta.hat
B = 2000
n = nrow(aircondit)
theta.b = numeric(B)

for (b in 1:B) {
  i = sample(1:n, size=n, replace=T) 
  X = aircondit$hours[i]
  theta.b[b] = 1/mean(X)
}

# 2. 편의
bias = mean(theta.b) - theta.hat
bias

# 3. 표준오차
se = sd(theta.b) # <=> sqrt(1/(B-1)*sum((theta.b-mean(theta.b))^2))
se

