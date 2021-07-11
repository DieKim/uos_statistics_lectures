### Ch4 연립방정식의 해법 - Part2 ###
 
# Part2; LU분해/촐레스키 분해/SV분해/QR분해/기타

# (1) LU분해; A=LU
# 하삼각(L), 상삼각(U) 행렬로 분해
# 단계1; Ly=b by 전방대입법
# 단계2; Ux=y by 후방대입법

# (2) 촐레스키 분해; A=LL'
# A = LL'를 만족하는 하삼각행렬 L이 유일하게 존재
# 단, A는 양정치 + 대칭

# (3) SV분해; A=USV'
# 머신러닝에서 많이 사용
# A의 Moore-Penrose 역행렬; 유일, 분산분석

# (4) QR분해; X=QR
# 회귀모형에 주로 사용
# 최소제곱법에 비하여 계산비용은 더 크지만 더 정확한 결과

# (5) 기타; 행렬식/가우스-조던 소거법/역행렬
# 행렬식; LU분해로 구하는 것이 더 효율적
# 가우스-조던 소거법; 상삼각행렬 -> 대각행렬 
# cf. 가우스 소거법; 상삼각행렬(-> 후방대입법)
# 역행렬; 가우스-조던 소거법으로 역행렬 구하기

###############################################################################

# Singular value decomposition(SVD)
H3.svd = svd(H3)
H3.svd
H3.svd$u %*% diag(H3.svd$d) %*% t(H3.svd$v) # 원래 행렬
H3.svd$v %*% diag(1/H3.svd$d) %*% t(H3.svd$u) # inverse; Moore-Penrose 역행렬

# Choleski decomposition
H3.chol = chol(H3)
H3.chol
crossprod(H3.chol, H3.chol) # H3랑 일치
chol2inv(H3.chol)	# inverse
# H_3 x = b, b = (1,2,3)'
b = 1:3
y = forwardsolve(t(H3.chol), b) 	# 단계1; forward elimination (lower)
backsolve(H3.chol,y)			# 단계2; back substitution (upper)

# QR decomposition
H3.qr = qr(H3)
H3.qr
Q = qr.Q(H3.qr)
Q
R = qr.R(H3.qr)
R
Q %*% R # 원래 행렬
qr.solve(R) %*% t(Q)	# inverse

# LU decomposition
set.seed(1)
library(Matrix)
mm = Matrix(round(rnorm(9),2), nrow=3) # 행렬 생성
mm

lum = lu(mm)
str(lum)

elu = expand(lum)
elu

with(elu, P %*% L %*% U)

# spectral decomposition(분광분해)
A = matrix(c(5,25,35,25,155,175,35,175,325), ncol = 3)
A
EA = eigen(A, symmetric = T)
EA
det(A)

prod(EA$values)

# rank: SV and eigenvalue
rk(A)
A.svd = svd(A)
sum(A.svd$d != 0)
sum(EA$values != 0)

# inner and outer product(내적&외적)
x1 = 1:5
outer(x1, x1, "/")
outer(x1, x1, "-")
y = 5:10
outer(x1, y, "+")

# real symmetric and positive definite matrix
A1 = matrix(c(4, 345, 193, 297), 2)
eigen(A1)$value
library(matrixcalc)
is.positive.definite(A1)
A2 = (A1 + t(A1)) / 2
eigen(A2)$value
is.positive.definite(A2)

### 해법 ###

# 전방 대입법 
forwardsub = function(L,b){
  x = c(0)
  n = nrow(L)
  for (i in (1:n)){
    x[i] = b[i]
    if (i > 1){
      for (j in (1:(i-1))){
        x[i] = x[i] - L[i,j]*x[j]
      }
    }
    x[i] = x[i]/L[i,i]
  }
  return(cbind(x))
}

# 후방 대입법
backwardsub = function(U,b){
  x = c(0)
  n = nrow(U)
  for (i in (n:1)){
    x[i] = b[i]
    if (i < n){
      for (j in ((i+1):n)){
        x[i] = x[i] - U[i,j]*x[j]
      }
    }
    x[i] = x[i]/U[i,i]
  }
  return(cbind(x))
}

# 가우스 소거법
gaussianelimination = function(Ab){
  n = nrow(Ab)
  for (k in (1:(n-1))){
    for (i in ((k+1):n)){
      mik = Ab[i,k]/Ab[k,k]
      Ab[i,k]=0
      for (j in ((k+1):(n+1))){
        Ab[i,j] = Ab[i,j] - mik*Ab[k,j]
      }
    }
  }
  return(Ab)
}

# 가우스 소거법(부분 피버팅)
gaussianeliminationpartial = function(Ab){
  n = nrow(Ab)
  for (k in (1:(n-1))){
    pivotindex = k
    for (i in ((k+1):n)){
      if (abs(Ab[i,k]) > abs(Ab[pivotindex,k])){
        pivotindex = i
      }
    }
    if (pivotindex != k){
      for (j in (k:(n+1))){
        buffer = Ab[k,j]
        Ab[k,j] = Ab[pivotindex,j]
        Ab[pivotindex,j] = buffer
      }
    }
    for (i in ((k+1):n)){
      mik = Ab[i,k]/Ab[k,k]
      Ab[i,k] = 0
      for (j in ((k+1):(n+1))){
        Ab[i,j] = Ab[i,j] - mik*Ab[k,j]
      }
    }
  }
  return(Ab)
}

# LU 분해 
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

# 촐레스키 분해
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

# 가우스 조던 소거법
gaussjordanelimination = function(Ab){
  n = nrow(Ab)
  for (k in (1:n)){
    if (k > 1){
      for (i in (1:(k-1))){
        mik = Ab[i,k]/Ab[k,k]
        Ab[i,k] = 0
        for (j in ((k+1):(n+1))){
          Ab[i,j] = Ab[i,j] - mik*Ab[k,j]
        }
      }
    }
    if (k < n){
      for (i in ((k+1):n)){
        mik = Ab[i,k]/Ab[k,k]
        Ab[i,k] = 0
        for (j in ((k+1):(n+1))){
          Ab[i,j] = Ab[i,j] - mik*Ab[k,j]
        }
      }			
    }
  }
  return(Ab)
}