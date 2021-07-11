# Reference : "https://www.r-bloggers.com/r-k-means-clustering-on-an-image/" 
library(jpeg) 
# install.packages("RCurl") 
library(RCurl) 
rm(list = ls())
gc()
setwd("C:\\Users\\User\\OneDrive - 서울시립대학교\\프로그래밍 언어 및 실습")
source("./k-means/mykmeans.R")

url = "https://raw.githubusercontent.com/mages/diesunddas/master/Blog/LloydsBuilding.jpg" 
readImage = readJPEG(getURLContent(url, binary=TRUE)) 
dm = dim(readImage) 
rgbImage = data.frame( 
  x=rep(1:dm[2], each=dm[1]), 
  y=rep(dm[1]:1, dm[2]), 
  r.value=as.vector(readImage[,,1]), 
  g.value=as.vector(readImage[,,2]), 
  b.value=as.vector(readImage[,,3])) 

head(rgbImage)
plot(y ~ x, data=rgbImage, main="Lloyd’s building", 
     col = rgb(rgbImage[c("r.value", "g.value", "b.value")]), 
     asp = 1, pch = ".") 


kColors = 5 
system.time((kMeans = mykmeans(data = rgbImage[, c("r.value", "g.value", "b.value")], 
                  centers = kColors, iter.max = 20)))

system.time((kMeans2 = kmeans(rgbImage[, c("r.value", "g.value", "b.value")], 
                   centers = kColors, iter.max = 20)))

clusterColour = rgb(kMeans$centers[kMeans$cluster, ]) 

plot(y ~ x, data=rgbImage, main="Lloyd’s building", 
     col = clusterColour, asp = 1, pch = ".", 
     axes=FALSE, ylab="", 
     xlab="k-means cluster analysis of 5 colours") 

clusterColour2 = rgb(kMeans2$centers[kMeans2$cluster, ]) 

plot(y ~ x, data=rgbImage, main="Lloyd’s building", 
     col = clusterColour2, asp = 1, pch = ".", 
     axes=FALSE, ylab="", 
     xlab="k-means cluster analysis of 5 colours") 


url = " https://2.bp.blogspot.com/-d47GF28COio/VBI3EMlHenI/AAAAAAAAB5U/DoHJ5n6jYwE/s1600/ColorfulBird.jpg" 

readImage = readJPEG(getURLContent(url, binary=TRUE)) 
dm = dim(readImage) 
rgbImage = data.frame( 
  x=rep(1:dm[2], each=dm[1]), 
  y=rep(dm[1]:1, dm[2]), 
  r.value=as.vector(readImage[,,1]), 
  g.value=as.vector(readImage[,,2]), 
  b.value=as.vector(readImage[,,3])) 

plot(y ~ x, data=rgbImage, main="Bird", 
     col = rgb(rgbImage[c("r.value", "g.value", "b.value")]), 
     asp = 1, pch = ".") 

kColors = 5 
kMeans = kmeans(rgbImage[, c("r.value", "g.value", "b.value")], 
                 centers = kColors) 
clusterColour = rgb(kMeans$centers[kMeans$cluster, ]) 

plot(y ~ x, data=rgbImage, main="Bird", 
     col = clusterColour, asp = 1, pch = ".", 
     axes=FALSE, ylab="", 
     xlab="k-means cluster analysis of K colors") 
