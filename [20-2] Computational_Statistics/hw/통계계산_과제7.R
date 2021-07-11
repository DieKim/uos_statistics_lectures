### Q1 ###

# (1) 신뢰구간 
n = 30
alpha = 0.05
x = rlnorm(n, mean=0, sd=1)
y = log(x)
LCL = mean(y)-qt(1-alpha/2,df=n-1)*sqrt(var(y))/sqrt(n)
UCL = mean(y)+qt(1-alpha/2,df=n-1)*sqrt(var(y))/sqrt(n)
c(LCL, UCL) # 95% 신뢰구간

# (2) 신뢰수준 by 몬테칼로 방법
set.seed(1118)
CL = replicate(1000, expr = { 
  x = rlnorm(n, mean=0, sd=1)
  y = log(x)
  LCL = mean(y)-qt(1-alpha/2,df=n-1)*sqrt(var(y))/sqrt(n)
  UCL = mean(y)+qt(1-alpha/2,df=n-1)*sqrt(var(y))/sqrt(n)
  c(LCL, UCL) 
} )
sum(CL[1,] < 0 & CL[2,] > 0) # 0을 포함하는 신뢰구간 개수
mean(CL[1,] < 0 & CL[2,] > 0) # 신뢰수준(=신뢰도)

### Q2 ###

# 그래프 준비
m = 1000
mu0 = 500
sigma = 100
mu = c(seq(350, 650, 10))   
M = length(mu)
power = numeric(M)

pwr = function(n){
  for (i in 1:M) {
    mu1 = mu[i]
    pvalues = replicate(m, expr={
      x = rnorm(n, mean=mu1, sd=sigma)
      ttest = t.test(x, alternative="two.sided", mu=mu0)
      ttest$p.value } )
    power[i] = mean(pvalues <= .05)
  }
  return(power)
}

pwr1=pwr(10); pwr2=pwr(20); pwr3=pwr(30); pwr4=pwr(40); pwr5=pwr(50)

# 그래프 그리기 with error bound
library(Hmisc)
se = sqrt(pwr1*(1-pwr1)/m)
errbar(mu, pwr1, yplus=pwr1+se, yminus=pwr1-se, xlab=bquote(theta), col="black", pch=15)
par(new=TRUE); se = sqrt(pwr2*(1-pwr2)/m)
errbar(mu, pwr2, yplus=pwr2+se, yminus=pwr2-se, xlab=bquote(theta), col="red", pch=16)
par(new=TRUE); se = sqrt(pwr3*(1-pwr1)/m)
errbar(mu, pwr3, yplus=pwr3+se, yminus=pwr3-se, xlab=bquote(theta), col="blue", pch=17)
par(new=TRUE); se = sqrt(pwr4*(1-pwr4)/m)
errbar(mu, pwr4, yplus=pwr4+se, yminus=pwr4-se, xlab=bquote(theta), col="green", pch=18)
par(new=TRUE); se = sqrt(pwr5*(1-pwr5)/m)
errbar(mu, pwr5, yplus=pwr5+se, yminus=pwr5-se, xlab=bquote(theta), col="purple", pch=19)

lines(mu, pwr1, col="black")
lines(mu, pwr2, col="red")
lines(mu, pwr3, col="blue")
lines(mu, pwr4, col="green")
lines(mu, pwr5, col="purple")

abline(v=mu0, lty=1)
abline(h=.05, lty=1)

legend("bottomright", cex=0.6, legend=c("n=10","n=20","n=30","n=40","n=50") 
       , pch=c(15,16,17,18,19), col=c("black","red","blue","green","purple"))

