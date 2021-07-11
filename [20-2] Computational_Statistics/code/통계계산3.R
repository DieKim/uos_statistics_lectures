### Ch3 수치적 방법 - Part1 ###

# Part1; 최적화방법
# 최적화; 최대/최소값 찾기 <-> Gradient(기울기)=0이 되는 x 찾기
# 최적화방법; 최대하강법/뉴튼-랩슨/선형계획법/이차계획법

# (1) 최대하강법; 감소 방향(d)을 이용한 해 갱신
# 1. 초기값 x0 설정
# 2. i = 1,...,M에 대해 수렴할 때까지 다음 반복
# - xi의 감소방향(d) 선택; *d = -Gradient = -∇f(xi) 
# - f(xi+λd) < f(xi)를 만족하는 λ 찾기; 스텝하강법 등
# - x(i+1) = xi + λ; x값 갱신
# - 수렴조건 확인 

# (2) 뉴튼-랩슨 알고리즘; 이차도함수까지 이용
# 1. 초기값 x0 설정
# 2. i = 1,...,M에 대해 수렴할 때까지 다음 반복
# - xi의 감소방향(d) 선택; *d = -(2차Gradient역행렬)Gradient 
# - f(xi+λd) < f(xi)를 만족하는 λ 찾기; 스텝하강법 등
# - x(i+1) = xi + λ; x값 갱신
# - 수렴조건 확인 

# (3) 선형계획법; 선형식에 대한 최적화 + 제약조건
# 가용영역(제약조건 만족)/비가용영역(제약조건 만족X)
# 비음일 조건 만들기; x = x+ - x-
# 예제; 제약회사
# - xi; i번째 처리
# - 비용; C = 5x1 + 8x2
# - 제약조건; 유해물질1; x1+x2>2 / 유해물질2; x1+2x2>3 / x1,x2>0

# (4) 이차계획법; 이차식에 대한 최적화 + 제약조건 
# 이차형식; x'Dx ≥ 0, D는 양정치 행렬
# 예제; 단순선형회귀의 기울기가 최소 1인 조건 하에 모수 추정

###############################################################################

### 최적화 ###

f = function(x) # 이변수 함수; x[1], x[2]
{
  f = (x[1] - 1)^2 + (x[2] - 1)^2 - x[1] * x[2]
}

df = function(x) # Gradient
{
  df1 = 2 * (x[1] - 1) - x[2]
  df2 = 2 * (x[2] - 1) - x[1]
  df = c(df1, df2)
  return(df)
}

Norm = function(u)
{
  return(sqrt(sum(u^2)))
}

### 최대하강법; 직접 일반적인 함수로 만들어서 써도 됨 ###

m = 100 # 최대반복수

par(mfrow=c(1,2), pty="s") # 해의 궤적을 구하기 위해서 구간을 나눔
x1 = x2 = seq(-10.5, 10.5, length=m)
xg = expand.grid(x1, x2) # 100*100
z = matrix(apply(xg, 1, f), m, m) # matrix 형태로 쌓아올림
xh = NULL; fh = NULL # 중간에 업데이트 될 값
x0 = c(-10, -3); fx0 = f(x0); ni = 0 # 초기값 

for (i in 1:10) # 간단하게 10번만 돌리기
{  
  xh = rbind(xh, x0); fh = c(fh, fx0); ni = ni+1
  cat("iteration=", round(i,2))
  cat("  x0=", round(x0,2), "  f(x0)=", round(f(x0),3), "\n")
  d = df(x0)
  for (iters in 1:20) # step-halving
  {
    x = x0 - d; fx = f(x)
    if (fx < fx0) break # 작아지면 탈출
    d = d / 2 # 작아지지 않으면 d값 줄이기
  }
  x0 = x; fx0 = fx
} # 10번 정도하니까 대충 수렴함 

contour(x1, x2, z, levels=round(fh, 2)) # 함수에 대해서 contour
for (i in 1:(ni-1)) # 해의 궤적 추적 by 빨간선
{
  points(xh[i,1], xh[i,2], pch=as.character(i))
  x1=xh[i,1]; y1=xh[i,2]; x2=xh[i+1,1]; y2=xh[i+1,2]
  arrows(x1, y1, x2, y2, length=0.1, col="red", lwd=0.5)
}
points(xh[ni,1], xh[ni,2], pch=as.character(ni)) # 번호 부여 

### 뉴튼-랩슨 알고리즘 ###

x1 = x2 = seq(-10.5, 10.5, length=m)
xg = expand.grid(x1, x2)
z = matrix(apply(xg, 1, f), m, m)
xh = NULL; fh = NULL
x0 = c(-10, -3); fx0 = f(x0); ni = 0
df2 = matrix(c(2,-1,-1,2),2,2); v = solve(df2) # 이차도함수

for (i in 1:10)
{  
  xh = rbind(xh, as.vector(x0)); fh = c(fh, fx0); ni = ni+1
  cat("iteration=", round(i,2))
  cat("  x0=", round(x0,2), "  f(x0)=", round(f(x0),3), "\n")
  d = v %*% df(x0)  # cf. 최대하강법; d = df(x0)
  for (iters in 1:20) # step-halving
  {
    x = x0 - d; fx = f(x)
    if (fx < fx0) break
    d = d / 2
  }
  if (abs(fx-fx0) < 1e-5) break
  x0 = x; fx0 = fx
} # 2번만에 stop

contour(x1, x2, z, levels=round(fh, 2)) # for 해의 궤적
for (i in 1:(ni-1)) # 해의 궤적; 2번만에 바로 찾음
{
  points(xh[i,1], xh[i,2], pch=as.character(i))
  x1=xh[i,1]; y1=xh[i,2]; x2=xh[i+1,1]; y2=xh[i+1,2]
  arrows(x1, y1, x2, y2, length=0.1, col="red", lwd=0.5)
}
points(xh[ni,1], xh[ni,2], pch=as.character(ni)) # 번호 부여


### 기타 최적화; 선형계획법 ###

library(lpSolve)
eg.lp = lp(objective.in=c(5,8), # 제약회사 예제
           const.mat=matrix(c(1,1,1,2),nrow=2), # 제약조건 계수
           const.rhs=c(2,3), # 제약조건 우변 
           const.dir=c(">=",">="), direction="min") # >=, >=, min; 최소값
eg.lp # success
eg.lp$solution # 최적값 

# degeneracy; 축퇴? 해가 여러 개

degen.lp = lp(objective.in = c(3,1),
              const.mat = matrix(c(1,1,1,4,1,2,3,1), nrow=4),
              const.rhs = c(2,3,4,4), const.dir = rep(">=",4))
degen.lp # success
degen.lp$solution	# still finds the optimum

# infeasibility; 가용영역 내 해 X

eg.lp = lp(objective.in=c(5,8),
           const.mat=matrix(c(1,1,1,1),nrow=2),
           const.rhs=c(2,1),
           const.dir=c(">=","<="))
eg.lp # no feasible solution

# unboundedness; 발산하는 해

eg.lp = lp(objective.in=c(5,8),
           const.mat=matrix(c(1,1,1,2),nrow=2),
           const.rhs=c(2,3),
           const.dir=c(">=",">="), direction="max")
eg.lp # status 3; unboundedness solution

### 기타 최적화; 이차계획법 ###

# 예제1; quadprog

library(quadprog)
x = c(.45, .08, -1.08, .92, 1.65, .53, .52, -2.15, -2.20,
      -.32, -1.87, -.16, -.19, -.98, -.20, .67, .08, .38,
      .76, -.78)
y = c(1.26, .58, -1, 1.07, 1.28, -.33, .68, -2.22, -1.82,
      -1.17, -1.54, .35, -.23, -1.53, .16, .91, .22, .44,
      .98, -.98)
X = cbind(rep(1,20), x)
XX = t(X) %*% X
Xy = t(X) %*% y
A = matrix(c(0, 1), ncol = 1)
b = 1
solve.QP(Dmat = XX, dvec = Xy, Amat = A, bvec = b) 

# 예제2; 주식회사

# optimal portfolio for investing in 3 stocks
# beta_i : ratio of investment, nonnegative and sum to 1
# x: daily return for stocks: 0.002, 0.005, 0.01
# D: variability in the returns (covariance)

A = cbind(rep(1,3), diag(rep(1,3)))
D = matrix(c(.01,.002,.002,.002,.01,.002,.002,.002,.01), nrow=3)
x = c(.002,.005,.01)
b = c(1,0,0,0)
solve.QP(2*D, x, A, b, meq=1) # meq=1; 제약조건 관련 

# optimal strategy: invest 10.4%, 29.2%, 60.4% for stocks 1,2,3
# optimal value is 0.002