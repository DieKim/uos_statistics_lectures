###Q3.5###

#3-(b)
A=matrix(c(3,1,1,1,4,2,1,2,2),nrow=3,ncol=3,byrow=T)
eigen(A) #고유값과 고유벡터

###Q3.6###
A=matrix(c(2,1,1,1,4,0,1,0,1),nrow=3,ncol=3,byrow=T)

#6-(a)
det(A) #행렬식
solve(A) #역행렬

#6-(b)
eigen(A) #고유값과 고유벡터

#6-(c)
cor(A) #상관계수 행렬 

###Q3.7###
A=matrix(c(2,1,3,1,2,3,3,3,6),nrow=3,ncol=3,byrow=T)

#7-(a)
det(A) #행렬식
solve(A) #행렬식이 0인 경우 역행렬 존재하지 않음

#7-(b)
eigen(A) #고유값과 고유벡터

#7-(C)
cor(A) #상관계수 행렬

###Q3.10###
X=matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,
           30,30,30,30,40,40,40,50,50,50,60,60,60,60)
         ,nrow=14,ncol=2)
Xt=t(X)
y=matrix(c(55.8,59.1,54.8,54.6,43.1,42.2,45.2,31.6
          ,30.9,30.8,17.5,20.5,17.2,16.9),nrow=14,ncol=1)

#1
Xt%*%X

#2
solve(Xt%*%X)

#3
lse=solve(Xt%*%X)%*%Xt%*%y
lse

######################################################################

###Q3.1###
A=matrix(c(2,3,2,0,2,1,1,2,4),nrow=3,ncol=3)
A

#1-(a)
t(A) #t(A); 행렬의 전치

#1-(b)
t(A)%*%A #%*%; 행렬의 곱

#1-(c)
diag(A) #diag(A); 대각행렬 
sum(diag(A)) #대각원소의 합=대각합
sum(diag(t(A)%*%A))

#1-(d)
det(A) #det(A); 행렬식
det(t(A)%*%A)


###Q3.2###
X=matrix(c(1,1,1,1,-1,1,-1,1,-1,-1,1,1),nrow=4,ncol=3)
y=matrix(c(4,3,5,7),nrow=4,ncol=1)

#2-(a)
t(X)%*%X #1
t(X)%*%y #2
solve(t(X)%*%X) #3
(solve(t(X)%*%X))%*%t(X)%*%y #4

#2-(b)
#항등행렬은 대각행렬(= 대각원소 제외 모든 원소 0) 
#서로 역함수 관계; 곱하면 항등행렬

###Q3.4###
A=matrix(c(2,-1,-1,2),2,2)
A

#4-(a)
det(A)
solve(A) #solve(A); 역행렬

#4-(b)
eig=eigen(A) #eigen(A); 고유값과 고유벡터
u=eig$values #고유값
v=eig$vectors #고유벡터

#4-(c)
A=v%*%diag(u)%*%t(v) #스펙트럴 분해

#4-(d)
#공분산 행렬; 대칭행렬 + 양정치행렬(고유치 양수)
cor(A) #상관계수 행렬; 공분산 행렬의 표준화 

###Q3.5###
A=matrix(c(3,1,1,1,4,2,1,2,2),3,3)
A

#5-(a)
det(A)
solve(A)

#5-(b)
eig=eigen(A)
u=eig$values
v=eig$vectors

#5-(c)
v%*%diag(u)%*%t(v)

#5-(d)
cor(A)


###Q3.6###
A=matrix(c(2,1,1,1,4,0,1,0,1),3,3)
A

#6-(a)
det(A)
solve(A)

#6-(b)
eig=eigen(A)
u=eig$values
v=eig$vectors

#6-(c)
#A; 대칭행렬이자 양정치행렬(고유치 양수)
#따라서 A는 공분산행렬이 될 수 있음
#즉 상관계수 행렬을 구할 수 있음
cor(A)

###Q3.7###
A=matrix(c(2,1,3,1,2,3,3,3,6),3,3)

#7-(a)
det(A) 
solve(A) #행렬식이 0이므로 역행렬 존재 X

#7-(b)
eigen(A)

#7-(c)
cor(A)

###Q3.8###
A=matrix(c(1,3,4,1,2,2),nrow=2,ncol=3)
B=matrix(c(4,2,2,1,2,4),nrow=3,ncol=2)

#8-(a)
A%*%B
qr(A%*%B)$rank #r(AB)=2

#8-(b)
B%*%A
qr(B%*%A)$rank #r(BA)=2 

###Q3.10###
X=matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,
           30,30,30,30,40,40,40,50,50,50,60,60,60,60)
         ,nrow=14,ncol=2)
Xt=t(X)
y=matrix(c(55.8,59.1,54.8,54.6,43.1,42.2,45.2,31.6
           ,30.9,30.8,17.5,20.5,17.2,16.9),nrow=14,ncol=1)

          
Xt%*%X #1; X'X
solve(Xt%*%X) #2; X'X 역행렬
(solve(Xt%*%X))%*%Xt%*%y #3; LSE
