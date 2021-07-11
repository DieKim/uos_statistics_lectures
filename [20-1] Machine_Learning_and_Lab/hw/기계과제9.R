### 링크 ###
# https://rpubs.com/ppaquay/65568
# https://rstudio-pubs-static.s3.amazonaws.com/385982_51ab081902c64ecc8d402eafa3cc59c7.html 
# https://rstudio-pubs-static.s3.amazonaws.com/299002_8ac0673ec1e74baabba66457ec030b94.html

### Q2 ###

#2-(a)
set.seed(1)
dis.mat = matrix(c(0, 0.3, 0.4, 0.7, 
                   0.3, 0, 0.5, 0.8,
                   0.4, 0.5, 0.0, 0.45,
                   0.7, 0.8, 0.45, 0.0), nrow=4)
colnames(dis.mat) = 1:4
q2_a = hclust(as.dist(dis.mat), method = 'complete')
plot(q2_a)
abline(h=q2_a$height, col=2, lty=2)
q2_a$height

#2-(b)
q2_b = hclust(as.dist(dis.mat), method = 'single')
plot(q2_b)
abline(h=q2_b$height, col=2, lty=2)
q2_b$height

#2-(c)
cutree(q2_a, 2)

#2-(d)
cutree(q2_b, 2)

#2-(e)
colnames(dis.mat) = c(2,1,4,3)
q2_e = hclust(as.dist(dis.mat), method = 'complete')
plot(q2_e)

### Q7 ###
library(ISLR)
set.seed(1)
scaled = t(scale(t(USArrests)))
q7.dist = as.matrix(dist(scaled))
q7.cor = cor(t(scaled))
plot(1-q7.cor, q7.dist^2)

#추가 설명 필요할 듯 ??
                    
### Q8 ###
library(ISLR)
set.seed(1)

#8-(a)
pr.out = prcomp(USArrests, center=T, scale=TRUE)
pr.var = pr.out$sdev^2
pve = pr.var / sum(pr.var)
pve

#8-(b)
loadings = pr.out$rotation
USA.scaled = scale(USArrests)
sumvar = sum(apply(as.matrix(USA.scaled)^2, 2, sum))
apply((as.matrix(USA.scaled) %*% loadings)^2, 2, sum) / sumvar

#or
loadings = pr.out$rotation
pve2 = rep(NA, 4)
dmean = apply(USArrests, 2, mean)
dsdev = sqrt(apply(USArrests, 2, var))
dsc = sweep(USArrests, MARGIN=2, dmean, "-")
dsc = sweep(dsc, MARGIN=2, dsdev, "/")
for (i in 1:4) {
  proto_x = sweep(dsc, MARGIN=2, loadings[,i], "*")
  pc_x = apply(proto_x, 1, sum)
  pve2[i] = sum(pc_x^2)
}
pve2 = pve2/sum(dsc^2)
pve2

### Q9 ###
library(ISLR)
set.seed(1)

#9-(a)
hc.complete = hclust(dist(USArrests), method="complete")
plot(hc.complete)

# for the most part, it looks like there are similar states in clusters - especially
# in larger clusters. Illinois and New York are together, which makes sense given
# that they have a very large city with a somewhat high crime rate. However, there
# are some states that are clustered together that are somewhat unexpected - North
# Dakota and Vermont, for example, are both fairly rural northern states, but
# don't tend to have much in common except for that.

#9-(b)
table(cutree(hc.complete,3))
cutree(hc.complete,3)

# Cluster 1 is kind of a hodgepodge - It has some southern states, some western 
# states, California, Nevada, and some states in New England. It looks like 
# these may be states that have a larger city in them, and are maybe clustered 
# because of their similar "urban population" predictor. Cluster 2 contains more
# rural states - some southern ones, as well as some ones in the west that are a 
# little more rural. However, cluster 2 also contains Massachusetts and New Jersey -
# states that don't make a ton of sense when compared to the rest of the states in 
# the cluster. Cluster 3 contains some more rural states (Montana, the Dakotas, 
# midwestern states like Indiana and Iowa). I was surprised that there wasn't a more
# consistent correlation in geographical area - it seems to have more to do with 
# the urban population than geographical area, although there are outliers that 
# suprised me in each cluster - indicating closer analysis may be helpful to try
# to determine intra-cluster commonalities.

#9-(c)
scaled = scale(USArrests)
hc.s.complete = hclust(dist(scaled), method="complete")
plot(hc.s.complete)

# Now we're starting to see some geographical correlation! We will look closer
# at this data and compare the three-cluster cutoff in the next section.

#9-(d)
cutree(hc.s.complete, 3)
table(cutree(hc.s.complete, 3))
table(cutree(hc.s.complete, 3), cutree(hc.complete, 3))

?USArrests

# 엄청 긴 코멘트... 링크 참고

