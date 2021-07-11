/* 예제1 ex1 데이터 */
/* 시점을 나타내는 변수 t와 2차 자기상관을 갖는 y변수 존재 */

/* (1) 데이터 불러오기 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\ex1.csv" 
dbms=csv replace out=ex1;
getnames=yes;
run; quit;

/* (2) 시계열도 확인하기 */
proc sgplot data=ex1;
series x=t y=y;
run; quit;

/* (3) 선형회귀모형 적합 */
proc reg data=ex1;
model y=t/dw spec;
output out=out1 p=pred r=resid;
run; quit;

/* (4) 잔차의 시계열도 */
proc sgplot data=out1;
series x=t y=resid;
refline 0/axis=y;
run; quit;

/* (5) 오차의 자기상관성 검정 */
proc autoreg data=ex1;
model y=t/ dw=3 dwprob;
run; quit;

/* (6) AR(2)모형 적합 */
proc autoreg data=ex1;
model y=t/nlag=2 method=ml dw=2 dwprob;
output out=out2 p=pred pm=trendhat;
run; quit;
/* cf */
proc autoreg data=ex1;
model y=t/backstep nlag=3 method=ml dwprob;
output out=out2 p=pred pm=trendhat;
run; quit;

/* (7) 적합한 모형을 이용하여 예측 */
proc sgplot data=out2;
series x=t y=pred;
series x=t y=trendhat/lineattrs=(color=red);
run; quit;

/* 예제2 lakelevel 데이터 */
/* 흑점의 크기(x)와 연도(t)에 따른 호수의 수위(y) 데이터 */

/* (1) 데이터 불러오기 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\lakelevel.txt"
dbms=dlm replace out=ex2;
getnames=yes; delimeters=",";
run; quit;

/* (2) 산점도와 시계열도 그리기 */
proc sgplot data=ex2; /* 산점도; 선형추세 */
scatter x=sunspt y=lakelev;
run; quit;
proc sgplot data=ex2; /* 시계열도; 자기상관 */
series x=year y=lakelev;
refline 0/axis=y;
run; quit;

/* (3) 선형모형 vs 자기상관모형 */
proc reg data=ex2; /* 선형모형 */
model lakelev=year sunspt/dw spec;
run; quit;
proc autoreg data=ex2; /* 시계열모형; AR모형 선택 X */
model lakelev=year sunspt/method=ml nlag=2 dw=2 dwprob;
run ;quit;

/* 예제3 salesadvert 데이터 */
/* 월별 광고비(x)와 판매량(y) 데이터 */

/* (1) 데이터 입력 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\salesadvert.txt"
dbms=dlm replace out=ex3;
getnames=yes; delimeter=",";
run; quit;

/* (2) 선형회귀모형적합 */
proc reg data=ex3; /* 잔차의 산점도와 DW 통계량 확인 */
model sales=adver/dw dwprob;
run; quit;
proc autoreg data=ex3; /* 5 시점까지의 잔차의 자기상관과 DW 통계량 확인 */
model sales=adver/method=ml nlag=5 dw=5  dwprob;
run; quit;

/* (3) 세가지 모형 적합 */
data ex3_2; /* for model 2, 3 */
set ex3;
ym=lag(sales); /* y_(t-1) */
xm=lag(adver); /* x_(t-1) */
run ;quit;
/* Model 1; AR(1) */
proc autoreg data=ex3;
model sales=adver/nlag=1 method=ml dw=5 dwprob;
run; quit;
/* Model 2 */
proc autoreg data=ex3_2;
model sales=ym adver xm/dw=5 dwprob;
run; quit;
/* Model 3 */
proc autoreg data=ex3_2;
model sales=ym adver/dw=5 dwprob;
run; quit;

/* (4) Cochran-Orcutt 방법을 통해 AR(1)모형의 모수 추정 */
/* step1; OLSE */
proc autoreg data=ex3 outest=outest;
model sales=adver/method=ml;
output out=out r=resid;
run; quit;
/* step2; OLSE의 잔차 */
proc autoreg data=out outest=outest2;
model resid= /method=ml nlag=1 noint;
run; quit;
/* step 3 */
data CO;
if _n_=1 then set outest;
if _n_=1 then set outest2;
set out;
ym=lag(sales);
xm=lag(adver);
ystar=sales+_A_1*ym;
xstar=adver+_A_1*xm;
run; quit;
proc autoreg data=CO outest=outest3;
model ystar=xstar/method=ml dw=5 dwprob;
run; quit;
/* step 4 */
data final;
set outest;
set outest2;
set outest3;
b0_hat = Intercept/(1+_A_1);
run; quit;
proc print data=final; run;
