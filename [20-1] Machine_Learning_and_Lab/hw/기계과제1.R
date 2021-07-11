###############과제1#################

###Q7
X1 = c(0,2,0,0,-1,1)
X2 = c(3,0,1,1,0,1)
X3 = c(0,0,3,2,1,1)
Y = c("Red","Red","Red","Green","Green","Red")
Q7 = data.frame(X1,X2,X3,Y)
Q7

#7-(a). 유클리드 거리 구하기
d1 = sqrt(0+9+0) 
d2 = sqrt(4+0+0)
d3 = sqrt(0+1+9)
d4 = sqrt(0+1+4)
d5 = sqrt(1+0+1)
d6 = sqrt(1+1+1)
Distance = c(d1,d2,d3,d4,d5,d6)
ans_a = data.frame(Q7,Distance)
ans_a

###Q10

#10-(a)
library(MASS)
Boston
?Boston #Housing Values in Suburbs of Boston

dim(Boston) #506행 14열
head(Boston) #데이터의 앞부분만 확인 
summary(Boston)

#10-(b)
attach(Boston) #디폴트 데이터 설정 
pairs(Boston) #모든 변수 조합에 대해서 scatterplots 그리기 

#10-(c)
pheatmap(cor(Boston, use="pairwise.complete.obs"))

#10-(d)
par(mfrow=c(2,2))
hist(crim, main="Crime Rates\n (note the long tail)",breaks="FD")
hist(crim, main="Crime Rates with y-axis limited", 
     ylim=c(0, 40), breaks="FD")
hist(tax, main="Tax rates\n (note some high-tax outliers)", breaks="FD")
hist(ptratio, main="Pupil-teacher ratio\n (no real outliers)", breaks="FD")

#10-(e)
summary(chas==1) ## (=1 if tract bounds river; 0 otherwise)

#10-(f)
median(ptratio)

#10-(g)
which.min(medv)

par(mfrow=c(5,3), mar=c(2, 2, 1, 0))
for (i in 1:ncol(Boston)){
  hist(Boston[, i], main=colnames(Boston)[i], breaks="FD")
  abline(v=Boston[399, i], col="red", lw=3)
}

#10-(h)
summary(rm > 7)

summary(rm > 8)

idx <- rm > 8
summary(idx)

par(mfrow=c(5,3), mar=c(2, 2, 1, 0))
for (i in 1:ncol(Boston)){
  hist(Boston[, i], main=colnames(Boston)[i], breaks="FD")
  abline(v=Boston[idx, i], col="red", lw=1)
}
