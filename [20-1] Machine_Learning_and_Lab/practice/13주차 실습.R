### Chapter 10 Lab 1: Principal Components Analysis

# 주성분 분석

states=row.names(USArrests) #주이름 
states
names(USArrests)
apply(USArrests, 2, mean) #평균
apply(USArrests, 2, var) #분산

pr.out=prcomp(USArrests, scale=TRUE) #스케일링; 표준화
names(pr.out)
pr.out$center #center 값
pr.out$scale #표준편차
pr.out$rotation #주성분 score; r에서는 특이하게 부호가 반대

dim(pr.out$x) #50 by 4
biplot(pr.out, scale=0) #byplot; 주성분 함수에 대한 scatter plot, 변수를 좌표로 표현

pr.out$rotation=-pr.out$rotation
pr.out$x=-pr.out$x
biplot(pr.out, scale=0) #부호를 바꿔서 biplot; 책하고 똑같음 

pr.out$sdev #표준편차; 변동의 설명비
pr.var=pr.out$sdev^2 #분산 = 표준편차^2
pr.var

pve=pr.var/sum(pr.var) #누적비율
pve

plot(pve, xlab="Principal Component", ylab="Proportion of Variance Explained", ylim=c(0,1),type='b') #pve plot
plot(cumsum(pve), xlab="Principal Component", ylab="Cumulative Proportion of Variance Explained", ylim=c(0,1),type='b') #누적합
a=c(1,2,8,-3)
cumsum(a) #cumsum; 누적합 

### Chapter 10 Lab 2: Clustering

# K-Means Clustering

#데이터 생성
set.seed(2)
x=matrix(rnorm(50*2), ncol=2)
x[1:25,1]=x[1:25,1]+3
x[1:25,2]=x[1:25,2]-4

km.out=kmeans(x,2,nstart=20) #k-means clustering; k=2, nstart=초기값의 개수 
km.out$cluster #clustering 결과
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=2", xlab="", ylab="", pch=20, cex=2) #cluster plot 

set.seed(4)
km.out=kmeans(x,3,nstart=20) #k=3
km.out
plot(x, col=(km.out$cluster+1), main="K-Means Clustering Results with K=3", xlab="", ylab="", pch=20, cex=2)

set.seed(3)
km.out=kmeans(x,3,nstart=1) #nstart=1; 초기값 1개
km.out$tot.withinss 
km.out=kmeans(x,3,nstart=20) #nstart=20; 초기값 20개
km.out$tot.withinss #withinss sum이 줄었음; 초기값이 많으면 더 좋은 결과 선택

# Hierarchical Clustering

hc.complete=hclust(dist(x), method="complete") #dist(x); 유클리드 거리 계산 함수 
hc.average=hclust(dist(x), method="average")
hc.single=hclust(dist(x), method="single")

par(mfrow=c(1,3))
plot(hc.complete,main="Complete Linkage", xlab="", sub="", cex=.9)
plot(hc.average, main="Average Linkage", xlab="", sub="", cex=.9)
plot(hc.single, main="Single Linkage", xlab="", sub="", cex=.9)

?cutree #옵션 k or h
cutree(hc.complete, 2) #높이 별로 짜르기; cluster 생성
cutree(hc.average, 2) 
cutree(hc.single, 2) #마지막 하나만 다른 군집
cutree(hc.single, 4)

xsc=scale(x) #데이터 표준화
plot(hclust(dist(xsc), method="complete"), main="Hierarchical Clustering with Scaled Features") #계층적 군집 결과

x=matrix(rnorm(30*3), ncol=3) #데이터 변경
dd=as.dist(1-cor(t(x))) #correlation에 기반한 거리
plot(hclust(dd, method="complete"), main="Complete Linkage with Correlation-Based Distance", xlab="", sub="")

### Chapter 10 Lab 3: NCI60 Data Example

# The NCI60 data

library(ISLR)
?NCI60
nci.labs=NCI60$labs
nci.data=NCI60$data
dim(nci.data) #64 by 6830
nci.labs[1:4]
table(nci.labs)

# PCA on the NCI60 Data; 주성분 분석

pr.out=prcomp(nci.data, scale=TRUE) #데이터 scaling
Cols=function(vec){ #주성분 분석 할 때 색깔 지정을 위한 함수
  cols=rainbow(length(unique(vec)))
  return(cols[as.numeric(as.factor(vec))])
}

par(mfrow=c(1,2)) 
plot(pr.out$x[,1:2], col=Cols(nci.labs), pch=19,xlab="Z1",ylab="Z2") #그나마 잘보임  
plot(pr.out$x[,c(1,3)], col=Cols(nci.labs), pch=19,xlab="Z1",ylab="Z3") #명확하진 않지만 cluster 생성

summary(pr.out) #주성분 분석 결과; PC 64개까지 가능
plot(pr.out) #주성분의 설명 비율 plot; 분산의 크기별로

pve=100*pr.out$sdev^2/sum(pr.out$sdev^2) 
par(mfrow=c(1,2))
plot(pve,  type="o", ylab="PVE", xlab="Principal Component", col="blue") #PVE를 직접 찍어본 그래프
plot(cumsum(pve), type="o", ylab="Cumulative PVE", xlab="Principal Component", col="brown3") #누적 PVE 그래프
#대략 7개 정도 잡으면 약 40%정도 설명; 차원 축소가 잘 되는 데이터는 아님 

# Clustering the Observations of the NCI60 Data

sd.data=scale(nci.data) #데이터 scaling
par(mfrow=c(1,3)) #각각 다른 cluster 생성
data.dist=dist(sd.data)
plot(hclust(data.dist), labels=nci.labs, main="Complete Linkage", xlab="", sub="",ylab="")
plot(hclust(data.dist, method="average"), labels=nci.labs, main="Average Linkage", xlab="", sub="",ylab="")
plot(hclust(data.dist, method="single"), labels=nci.labs,  main="Single Linkage", xlab="", sub="",ylab="")

?hclust
hc.out=hclust(dist(sd.data))
hc.clusters=cutree(hc.out,4) #cuttree=4
table(hc.clusters,nci.labs)

par(mfrow=c(1,1))
plot(hc.out, labels=nci.labs)
abline(h=139, col="red") #높이 139에서 나무 cut; 4개의 cluster 생성
hc.out

set.seed(2)
km.out=kmeans(sd.data, 4, nstart=20)
km.clusters=km.out$cluster
table(km.clusters,hc.clusters) #4개로 했을 때의 결과; 단일 결과는 크게 다르지 않은 듯

hc.out=hclust(dist(pr.out$x[,1:5])) #주성분 분석 중 앞의 5개만 사용해서 분석
plot(hc.out, labels=nci.labs, main="Hier. Clust. on First Five Score Vectors")
table(cutree(hc.out,4), nci.labs) #책 설명 참고

