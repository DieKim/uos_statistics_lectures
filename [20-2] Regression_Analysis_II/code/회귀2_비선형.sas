/* 예제1  염소 농도 감소 데이터 */
/* 제품 생산 후 경과시간(x)에 따른 가용 염소농도(y)를 나타낸 데이터 */

/* (1) 염소농도(y)와 경과시간(x) 간의 산점도 확인 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\chlorine.txt" dbms= dlm replace
out = ex1;
getnames = yes; /* 열이름 */
delimiter = ","; /* 구분자; 콜론(,) */
run;
proc sgplot data=ex1;
scatter x=Age Y=Chlor;
run; quit;

/* (2) 먼저, 선형회귀모형 적합 */
proc reg data=ex1;
model chlor=age;
output out=ex1_reg p=pred r=resid;
run; quit;
proc sgplot data=ex1_reg;
scatter X=age Y=chlor; /* 실제 데이터의 산점도 */
series X=age Y=pred/ lineattrs=(color=red); /* 추정된 회귀직선 */
run; quit;
proc sgplot data=ex1_reg;
series X=age Y=resid/ lineattrs=(color=blue); /* 잔차그림 with 독립변수 */refline 0/axis=y; /* 참고선; y=0 */
run; quit;

/* (3) 잔차분석 결과, 비선형모형에 적합 */
proc nlin data=ex1 method=newton; /* or method=gauss(디폴트) */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=0.35 b=0.034;
output out=ex1_nlin1 p=pred r=resid;
run; quit;
proc sgplot data=ex1_nlin1;
scatter X=age Y=chlor;
series X=age Y=pred/lineattrs=(color=red); /* 선형모형보다 훨씬 잘 적합됨 */
run; quit;
proc sgplot data=ex1_nlin1;
scatter X=age Y=resid; /* 잔차그림을 봐도 잘 적합된 듯? */
refline 0/axis=y;
run; quit;

/* (4) 잘 적합되었지만, 초기값을 바꿔서 한번더 비선형모형 적합해보기 */
proc nlin data=ex1 method=newton; /* or method=gauss(디폴트) */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=1 b=1; /* 초기값을 바꿨더니 수렴 X; 초기값의 중요성 */
output out=ex1_nlin2 p=pred r=resid;
run; quit;

/* (5) 최종모형 선택 후 모형진단 */
proc nlin data=ex1 method=newton plots=(fit diagnostics); /* proc sgplot 단계 생략 가능 */
model chlor=a+(0.49-a)*exp(-b*(age-8));
parms a=0.35 b=0.034;
output out=ex1_nlin1 p=pred r=resid; /* 없어도 됨; plots 옵션을 썼으니까 */
run; quit;

/* 예제2 nitrate 데이터 */
/* 광도(x)에 따른 부시콩의 질산염 활용수치(y)를 나타낸 데이터 */

/* (1) 데이터를 불러오고 산점도 확인 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\nitrate.txt" dbms=dlm replace
out = ex2; 
getnames = yes;
delimeter = ",";
run; quit; 
proc sgplot data=ex2;
scatter X=Light Y=NitDay1; /* 비선형 모형임을 확인 가능 */
run; quit;

/* (2) 두가지 비선형모형에 적합 후 결과 비교 */
proc nlin data=ex2 method=newton plots=(fit diagnostics);
model nitday1=(b1*light)/(b2+light); /* Michaelis-Menton model */
parms b1=1 b2=1;
run; quit;
proc nlin data=ex2 method=newton plots=(fit diagnostics); 
model nitday1=b1*(1-exp(-b2*light)); /* Exponential rise model */
parms b1=20000 b2=0.01;
run; quit;

/* 예제3 puromycin 데이터 */
/* 항생제처리(x)에 따른 효소반응속도(y)를 나타낸 데이터 */

/* (1) 데이터를 불러와서 treated 그룹만 추출해 분석하기 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\puromycin.csv" dbms=csv replace
out=ex3_raw;
getnames=yes;
run; quit;
data ex3;
set ex3_raw(where=(state="treated")); /* 변수 state의 값이 "treated"인 데이터만 추출해서 새로운 데이터셋 생성 */
run; quit;

/* (2) 산점도 그리기 */
proc sgplot data=ex3;
scatter X=conc Y=rate; /* 비선형관계임을 확인 */
run; quit;

/* (3) conc*=1/conc, rate*=1/rate로 변환한 후 모형적합 */
data ex3_t; /* 변환 */
set ex3;
conc_t = 1/conc; /* conc*=1/conc */
rate_t = 1/rate; /* rate*=1/rate */
run; 
proc sgplot data=ex3_t; /* 산점도 */
scatter X=conc_t Y=rate_t;
reg X=conc_t Y=rate_t; /* 회귀직선; 어느정도 선형모형에 가까워진 듯  */
run; quit;
proc reg data=ex3_t; /* 선형모형적합 */
model rate_t = conc_t;
output out=ex3_reg p=pred_t; /* pred_t = 1/pred(y_hat) */
run; quit;

/* (4) 적합된 모형을 해석하기 위해 다시 변환 후 확인 */
data ex3_r; /* 해석하고자 하는 pred(y_hat)으로 변환 */
set ex3_reg;
pred = 1/pred_t;
run; 
proc sgplot data=ex3_r; /* 모형적합 결과 확인 */
scatter X=conc Y=rate;
series X=conc Y=pred/lineattrs=(color=purple); /* 나름 비선형에 가깝게 적합 완료 */
run; quit;

/* (5) 변환 대신에, 비선형함수를 이용해 바로 모형 적합 */
proc nlin data=ex3 method=newton plots=(fit diagnostics);
model rate=(t1*conc)/(conc+t2);
parms t1=0.02 t2=0.02;
output out=ex3_nlin p=pred r=resid;
run; quit;
proc sgplot data=ex3_nlin;
scatter X=conc Y=resid; /* 잔차그림 with 독립변수 */
run; quit;
proc sgplot data=ex3_nlin;
scatter X=pred Y=resid; /* 잔차그림 with 적합값 */
run ;quit;

/* (6) Q-Q plot & 잔차가정 확인 */
proc univariate data=ex3_nlin;
qqplot resid/normal(mu=0 sigma=10.93161); /* sigma = 루트 MSE */
run; quit; 
