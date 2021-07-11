### chapter 4; 연립방정식의 해법 ###

# 1; 선형방정식
# 연립방정식 by 행렬; Ax=b
# (i) 해가 유일한 경우
# (ii) 해가 무한히 많은 경우
# (iii) 해가 존재하지 않는 경우

# 2; 삼각행렬의 해
# 선형방정식의 해법; Dx=b 
# (1) 전방대입법; 하삼각행렬
# (2) 후방대입법; 상삼각행렬

# 3; 가우스 소거법
# 대각원소 단위화 + 계수행렬 변환; Ux=b'
# (1) 기본 행 연산; 교환, 대체
# (2) 소거법의 단계; 상삼각행렬로 변환 후 후방대입법
# (3) (부분) 피버팅; 치환행렬을 곱해주는 연산 for 대각원소가 0인 문제 해결 

# 4; LU분해
# A=LU; Ax=b -> LUx=b (상삼각행렬로 변환 by 가우스 소거법)
# 단계 1; Ly=b by 전방대입법(하삼각행렬)
# 단계 2; y=Ux by 후방대입법(상삼각행렬)

# 5; 촐레스키 분해
# A가 양정치 + 대칭행렬일 때 L이 유일하게 존재; A=LL'

# (*)6; SV 분해(SVD)
# SVD; U'AV=S / A=USV' / SS'=U'AA'U
# S의 대각원소; A의 특이값
# U의 각 열; 대칭행렬 AA'의 고유벡터 
# A의 Moore-Penrose 역행렬을 구하는 데 유용; 유일, 분산분석

# 7; QR 분해
# 회귀모형에 주로 사용; SSE를 최소화할 때
# LSE에 비하여 계산시간과 메모리가 더 소모되나 정확한 계산 가능

# 8; 기타
# (1) 행렬식; 재귀적 계산 < LU분해 이용
# (2) 가우스-조던 소거법; 대각행렬로 만들어 해를 구함
# cf. 가우스 소거법; 상삼각행렬로 만들어 후방대입법으로 해를 구함
# (3) 역행렬; 가우스-조던 소거법 이용

### Q1 ###

# 행렬 X, y
X = matrix(c(1,1,1,1,2,3,1,3,3,1,5,4,1,5,4,1,7,5), nrow=6, byrow=T)
y = matrix(c(2,4,5,8,8,9), nrow=6)

# (a); 촐레스키 분해

# (1) X'X
A = t(X)%*%X
A

# (2) 강의 예제 함수
choleskyfactorization = function(A){
  n = nrow(A)
  L = matrix(0,nrow=n,ncol=n)
  for (i in (1:n)){
    L[i,i] = A[i,i]
    if (i > 1){
      for (k in (1:(i-1))){
        L[i,i] = L[i,i] - L[i,k]*L[i,k]
      }
    }
    L[i,i] = (L[i,i])^(1/2)
    if (i < n){
      for (j in ((i+1):n)){
        L[j,i] = A[j,i]
        if (i > 1){
          for (k in (1:(i-1))){
            L[j,i] = L[j,i] - L[j,k]*L[i,k]
          }
        }
        L[j,i] = L[j,i]/L[i,i]
      }
    }
  }
  return(L)
}

L = choleskyfactorization(A) 
L # L; 하삼각행렬
L %*% t(L) # A=LL'

# (3) R의 내장함수
chol(A) # 상삼각행렬로 반환
t(chol(A)) # L; 하삼각행렬
t(chol(A)) %*% chol(A) # A=LL'

# (b); SV 분해

# (1) X'X의 고유값
eigen(A)$values

# (2) D의 대각원소
svd(X)$d
(svd(X)$d)^2

# (c); QR 분해

# (1) QR분해 이용
X.qr = qr(X)
Q = qr.Q(X.qr)
R = qr.R(X.qr)
backsolve(R, t(Q)%*%y) # by 후방대입법

# (2) lm 이용
x1 = c(1,2,3,5,5,7)
x2 = c(1,3,3,4,4,5)
lm(y ~ x1 + x2)

### Q2 ###

A = matrix(c(5,-2,1,3,1,1,4,1,-1),nrow=3,byrow=T)
b = matrix(c(9,2,3),nrow=3)
Ab = cbind(A, b) # 확대행렬

# (1) 가우스 소거법
gausselimination = function(Ab){
  n = length(A[,1])
  x = c() # 해를 저장할 벡터
  i = 1
  for(i in 1:(n-1)){
    if (Ab[i,i]==0){
      p=i+1
      for(k in p:n){
        if(Ab[k,1]!=0){
          p=k
        }
      }
      temp=Ab[i,]
      Ab[i,]=Ab[p,]
      Ab[p,]=temp
    }
    for(j in (i+1):n){
      m=Ab[j,i]/Ab[i,i]
      Ab[j,]=(Ab[j,]-m*Ab[i,])
    }
  }
  if(Ab[n,n]==0){
    stop("방정식의 근을 구할 수 없습니다.")
  }else{
    x[n]=Ab[n,n+1]/Ab[n,n]
  }
  for(i in (n-1):1){
    temp=0
    for(j in (i+1):n){
      temp = temp+Ab[i,j]*x[j]
    }
    x[i]=(Ab[i,n+1]-temp)/Ab[i,i]
  }
  return(x)
}

gausselimination(Ab)

# (2) solve 함수
solve(A, b)

### Q3 ###

# 행렬 A
A = matrix(c(1,1,2,2,-2,-1,-1,1,1), nrow=3)

# (1) LU분해
lufactorization = function(A){
  n = nrow(A)
  L = matrix(0,nrow=n,ncol=n)
  for (k in (1:(n-1))){
    for (i in ((k+1):n)){
      L[i,k] = A[i,k]/A[k,k]
      A[i,k] = 0
      for (j in ((k+1):n)){
        A[i,j] = A[i,j] - L[i,k]*A[k,j]
      }
    }
  }
  for (k in (1:n)) L[k,k] = 1
  return(cbind(L,A))
}

LU = lufactorization(A)
L = LU[,1:3]
U = LU[,4:6]
det(U) # det(A)=det(U)

# (2) det 함수
det(A)


