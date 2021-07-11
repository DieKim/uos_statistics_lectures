### 2주차 실습 ###

#1. Basic Commands

x <- c(1,3,2,5) #vector 생성
x

x = c(1,6,2) #'<-' == '='; 값 할당
x

y = c(1,4,3)

length(x) #vector의 길이
length(y)

x+y #vector의 합; length가 같아야 함 

ls() #ls(); 현재 작업공간 상의 객체 모두 나열

rm(x,y) #rm(); 객체 제거
ls()

rm(list=ls()) #모든 객체 제거
ls() #ls()를 통해 모든 객체의 나열을 list로 받아서 rm() 실행; character(0)

?matrix #R에서의 help

x=matrix(data=c(1,2,3,4), nrow=2, ncol=2) #2x2 matrix 생성 
x 

x=matrix(c(1,2,3,4),2,2) #위의 결과와 같음
x #디폴트 byrow = False; 열 우선 생성

matrix(c(1,2,3,4),2,2,byrow=TRUE) #byrow = True; 행 우선 생성

sqrt(x) #각 원소 루트 
x^2 #각 원소 제곱

x=rnorm(50) #표준정규분포에서 난수 50개 발생
y=x+rnorm(50,mean=50,sd=.1) #like 회귀분석 모형 
cor(x,y) #1에 가까운 correlation

set.seed(1303) #seed값 지정
rnorm(50)      

set.seed(3)
y=rnorm(100)

mean(y)
var(y)
sqrt(var(y))
sd(y)

#2. Graphics

x=rnorm(100)
y=rnorm(100)

plot(x,y) #기본 그래프
plot(x,y,xlab="this is the x-axis", #xlab, ylab; x, y축 제목
     ylab="this is the y-axis",main="Plot of X vs Y") #main; plot 제목

pdf("Figure.pdf") #plot을 pdf파일로 저장
plot(x,y,col="green") #col; 색상 지정
dev.off()

x=seq(1,10) #1-10까지 수열
x

x=1:10 #1-10까지 수열
x

x=seq(-pi,pi,length=50) #seq; 실수열 생성
y=x

f=outer(x,y,function(x,y)cos(y)/(1+x^2)) #outer; 외적

contour(x,y,f) #contour plot 
contour(x,y,f,nlevels=45,add=T) #nlevers; 등고선 수, add; 기존 그래프에 추가

fa=(f-t(f))/2 #t(f); 전치 
contour(x,y,fa,nlevels=15)

image(x,y,fa) #2차원 그래프
 
persp(x,y,fa) #3차원 그래프
persp(x,y,fa,theta=30)
persp(x,y,fa,theta=30,phi=20)
persp(x,y,fa,theta=30,phi=70)
persp(x,y,fa,theta=30,phi=40)

#3. Indexing Data; 중요!

A=matrix(1:16,4,4)
A

A[2,3] #2행 3열
A[c(1,3),c(2,4)] #1,3행의 2,4열
A[1:3,2:4] #1-3행의 2-4열 
A[1:2,] #1-2행의 모든 열
A[,1:2] #모든 행의 1-2열
A[1,] #1행의 모든 열; 1행
A[-c(1,3),] #'-'; 해당 부분 제외
A[-c(1,3),-c(1,3,4)] #2,4행의 2열

dim(A) #dim; matrix나 array의 dimension

#4. Loading Data

install.packages("ISLR") #ISLR 패키지 설치
library(ISLR)

data(Auto)
write.table(Auto, "Auto.data") #Auto data 생성

Auto=read.table("Auto.data") #Auto data 읽기
fix(Auto) #spread sheet 형식으로 보여줌

Auto=read.table("Auto.data",header=T,na.strings="?")
fix(Auto) #header=T; 첫번째 줄을 변수명으로 인식

write.csv(Auto,"Auto.csv") #csv 형식 파일 생성

Auto=read.csv("Auto.csv",header=T,na.strings="?") #파일 읽기
fix(Auto) #창 띄우기

dim(Auto) #392행 10열
Auto[1:4,] #1-4행의 모든 열 

sum(is.na(Auto)) #missing data의 개수 = 0
Auto=na.omit(Auto) #missing data가 있으면 제거
dim(Auto)
names(Auto) #변수명 출력

#5. Additional Graphical and Numerical Summaries

plot(cylinders, mpg) #Error; dataframe명 필요
plot(Auto$cylinders, Auto$mpg) #Auto의 변수명임을 명시 

attach(Auto) #디폴트 dataframe 설정
plot(cylinders, mpg) #Auto$ 생략가능

cylinders=as.factor(cylinders) #cylingders; 범주형 변수
plot(cylinders, mpg) #box plot 형식
plot(cylinders, mpg, col="red")
plot(cylinders, mpg, col="red", varwidth=T) #varwidth; 가변길이
plot(cylinders, mpg, col="red", varwidth=T,horizontal=T) #horizontal=T; 수평
plot(cylinders, mpg, col="red", varwidth=T, xlab="cylinders", ylab="MPG")

hist(mpg)
hist(mpg,col=2) #col=2; red
hist(mpg,col=2,breaks=15) #breaks; 구간의 개수

pairs(Auto) #pairs; 모든 변수 조합에 대해서 scatterplots 그리기(경향성 확인)
pairs(~ mpg + displacement + horsepower + weight + acceleration, Auto) #연속형 데이터에 대해서만 pairs

plot(horsepower,mpg)
identify(horsepower,mpg,name) #특이한 observation 탐색; ESC로 종료

summary(Auto) #각 변수별로 대략적인 분포를 알 수 있음
summary(mpg) 
