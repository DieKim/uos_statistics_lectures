### Q1.7 ###

dir = choose.dir() # 자료파일이 저장된 directory 지정
setwd(dir)

# (1) 월별 전문기술행정직에 종사하는 여성근로자 수 

z <- scan("female_hw1.txt") 
z.ts <- ts(z, start=c(1983,1), frequency=12) 
ts.plot(z.ts, xlab="date", ylab="Zt", main="월별 전문직 종사 여성 근로자 수(단위: 십만 명)") 

# 추세성분

# (2) 월별 건축허가면적

z <- scan("build_hw1.txt") 
z.ts <- ts(z, start=c(1980,1),frequency=12) 
ts.plot(z.ts, xlab="date", ylab="Zt", main="월별 건축허가면적") 

# 추세성분 + 계절성분

# (3) 월별 수출액

z <- scan("export_hw1.txt") 
z.ts <- ts(z, frequency=12) 
ts.plot(z.ts, xlab="date", ylab="Zt", main="월별 수출액(단위: 억$)") 

# 추세성분 + 계절성분

# (4) 미국 월별 비행기 승객 수 

z <- scan("usapass_hw1.txt") 
z.ts <- ts(z, start=c(1949,1),frequency=12) 
ts.plot(z.ts, xlab="date", ylab="Zt", main="미국 월별 비행기 승객 수(단위: 천 명)") 

# 추세성분 + 계절성분 + 이분산성

