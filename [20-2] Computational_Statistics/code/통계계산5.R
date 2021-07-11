### Ch4 연립방정식의 해법 - Part1 ###

# Part1; 선형방정식/삼각행렬의 해/가우스 소거법

# (1) 선형방정식; 연립방정식 -> 행렬 꼴
# 1. 해가 유일한 경우
# 2. 해가 무한히 많은 경우
# 3. 해가 존재하지 않는 경우
# 미지수의 개수 = 방정식의 개수 

# (2) 삼각행렬의 해; 대각행렬 이용
# 1. 전방대입법; 하삼각행렬일 때
# 2. 후방대입법; 상삼각행렬일 때

# (3) 가우스 소거법; 상삼각행렬로 변환
# 대각원소의 단위화 + 계수행렬의 변환 -> 상삼각행렬
# 기본 행 연산 이용; 대체, 교환 
# 상삼각행렬로 변환 후 후방대입법으로 해 구하기
# 피버팅; 대각원소가 0일 경우 오류를 해결하기 위해 부분 피버팅 이용
# 부분 피버팅; 행을 교환, 즉 치환 행렬을 곱해주는 연산 

###############################################################################

# constructing matrix; 행렬 생성
H3 = 1/cbind(1:3, 2:4, 3:5) # 행렬생성 by cbind
matrix(seq(1,12), nrow = 3) # 행렬생성 by matrix; byrow=FALSE(디폴트)
matrix(seq(1,12), nrow = 3, byrow = TRUE) # byrow=TRUE; 행 우선 생성
x = seq(1,3) # 1,2,3
x2 = x^2 # 각 원소별로 제곱
X = cbind(x, x2) # cbind; 두 벡터가 열이 되는 행렬 생성
X
X = matrix(c(1,2,3,1,4,9), ncol = 2) # matrix; 열이 2개인 행렬 생성
X

# accessing matrix elements; 행렬원소 접근 by indexing
X[3,2] # 3행 2열
X[3,] # 3행
X[,2] # 2열
colnames(X) # 열이름; NULL
rownames(X) # 행이름; NULL
colnames(X) = c("var1", "var2") # 열이름 부여
rownames(X) = c("obs1","obs2","obs3") # 행이름 부여
X

# matrix properties; 행렬의 성질
mat = rep(1:4, rep(3,4)) # 1-4까지를 3번 반복; *rep(3,4)?
dim(mat) = c(3,4) # dimension을 조정해서 행렬로 생성
mat # 3 by 4 행렬 
dim(mat) # 3 by 4

# diagonal matrix; 대각행렬 
D = diag(c(1,2,3)) # diag; 대각원소가 1,2,3인 대각행렬 생성
D
diag(D) # diag; 대각원소 반환
I = diag(3) # diag; 3차 항등행렬 생성
I

# triangluar matrix; 삼각행렬
lower.tri(H3) # 하삼각행렬
Hnew = H3
Hnew[upper.tri(H3)] = 0 # 상삼각행렬 = 0; 하삼각행렬 꼴 
Hnew

# transpose; 전치
A = matrix(c(rep(1,5), -1, 1, -1), byrow = T, ncol = 4)
A
A1 = t(A)
A1

# matrix arithmetic; 행렬의 산술연산
Y = 2 * X
Y
Y + X
t(Y) + X # 행렬의 차원이 같아야 함
X * Y # 원소별 곱; 행렬의 곱 X

# matrix multiplication; 행렬 곱셈 
t(Y) %*% X # %*%; 행렬 곱셈 
Y %*% X # %*%; 행렬의 차원이 맞을 때
crossprod(Y,X) # crossproduct 계산

# determinant and inverse; 행렬식과 역행렬
A = matrix(10:13, 2)
B = matrix(c(3,5,8,9), 2)
det(A) # det; 행렬식
det(t(A))
det(A %*% B) 
det(A) * det(B)

H3inv = solve(H3) # solve; 역행렬 
H3inv
H3inv %*% H3 # 역행렬이 맞는 지 확인 
zapsmall(H3inv %*% H3) # zapsmall; 수치적으로 작은 값을 제거하는 함수

# rank; 계수
library(fBasics) # for rk(); 계수 구하기
set.seed(45)
A = sample(11:26) # random하게 원소를 가져옴
A = matrix(A, 4) 
rk(A) # rank = 4
B = A
B[1,] = rep(0, ncol(B)) # 첫 행을 0으로 바꿈
rk(B) # rank = 3

# generalized inverse; 일반화역행렬
library(limSolve) # for Solve(); 역행렬이 없는 경우에도 일반화역행렬을 구함
A = matrix(c(1:8, 6, 8, 10, 12), nrow=4, ncol=3)
B = 0:3
X = Solve(A, B) # Solve(); 일반화역행렬 cf. solve(); 역행렬 -> 모두 선형방정식의 해
A %*% X - B # 수치적으로 거의 0에 가까움; 해가 맞는 듯
(gA = Solve(A)) # 정방행렬이 아닌 경우에도 역행렬을 구할 수 있음 by 일반화역행렬

# solving linear equations; 선형방정식
A = matrix(c(4,2,1,-2,-1,3,3,1,-1), ncol = 3)
A
b = c(9,3,4)
solve(A,b) # solve; 선형방정식의 해 

