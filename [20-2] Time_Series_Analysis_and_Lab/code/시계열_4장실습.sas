/* 4장 분해법과 계절조정 */

/* 예제1 추세모형에 의한 분해법 */

/* (1) 데이터 불러오기 및 변수 생성 */
data food; /* 월별 음식물 출하지수 자료 */
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt";
input food @@; 
date = intnx('month', '1jan80'd, _n_-1); /* date 변수 생성; 1980년 1월부터 시작 */
format date monyy.; t+1; /* date 변수의 형식 지정 */
mon = month(date); /* mon 변수 생성 for 계절성분 */
if mon=1 then i1=1; else i1=0;  if mon=2 then i2=1; else i2=0;
if mon=3 then i3=1; else i3=0;  if mon=4 then i4=1; else i4=0;
if mon=5 then i5=1; else i5=0;  if mon=6 then i6=1; else i6=0;
if mon=7 then i7=1; else i7=0;  if mon=8 then i8=1; else i8=0;
if mon=9 then i9=1; else i9=0;  if mon=10 then i10=1; else i10=0;
if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0;
run;
proc print data=food; run;

/* (2) 시계열도 확인; 선형추세+계절성+이분산성 확인 with 승법모형 */
proc sgplot data=food;
series x=date y=food; /* 시계열도 */
reg x=date y=food; /* 추세선 */
run;

/* (3) 원시계열 {Zt}에서 추세성분 분해; 선형추세모형 적합 */
proc reg data=food;
model food=t/dw dwprob; /* 오차의 자기상관성 존재하는 듯 */
output out=trendata p=trend; /* 추세성분 분해 */
id date; run; quit;
data adtrdata; /* 원시계열에서 추세성분 제거하기 */
set trendata; 
adjtrend=food/trend; /* 승법모형이므로; {Zt/Tt} */
run;

/* (4) 잔차시계열 {Zt/Tt}에서 계절성분 분해; 자기회귀오차모형 적합 */
proc autoreg data=adtrdata;
model adjtrend=i1-i12/noint nlag=13 dwprob backstep;
output out=seasdata p=seasonal;
run; quit;

/* (5) 불규칙성분 분해 */
data all;
set seasdata; 
keep t date food trend seasonal irregular fitted;
irregular=adjtrend/seasonal; /* 불규칙성분; I = Z/(T*S) */
fitted=trend*seasonal; /* 적합값; Z_hat=T_hat*S_hat */
run;
proc arima data=all;
identify var=irregular nlag=12; /* 12시차까지의 자기상관계수 확인; 잘 적합되었음 */
run; quit;

/* (6) 추세모형을 이용한 분해결과 확인 */
proc print data=all; /* t, date(x), food(Z), T, S, I, Z_hat */ 
var t date food trend seasonal irregular fitted; run;
proc sgplot data=all; /* 추세성분 분해 */
series x=date y=food/lineattrs=(pattern=1 color=blue); /* 원시계열 */
series x=date y=trend/lineattrs=(pattern=2 color=red); /* 추세성분 */
run; quit;
proc sgplot data=all; /* 계절성분 분해 */
series x=date y=seasonal; run; quit;
proc sgplot data=all; /* 불규칙성분 분해 */
series x=date y=irregular; run; quit;
proc sgplot data=all; /* 예측 */
series x=date y=food/lineattrs=(pattern=1 color=blue); /* 원시계열 */
series x=date y=fitted/lineattrs=(pattern=2 color=red); /* 추정값(예측) */
run; quit;

/* 예제2 이동평균법 */

/* (1) 데이터불러오기 및 변수 생성 */
data mindex; /* 중간재 출하지수 자료 */
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\mindex.txt";
input mindex @@;
date = intnx('month','1jan86'd,_n_-1);
format date monyy.; t+1; run;
proc print data=mindex; run;

/* (2) 이동평균법을 이용한 평활 */
proc expand data=mindex out=out1;
convert mindex=m3/transformout=(cmovave 3 trim 1); /* m=3일 때, 중심이동평균법 */ 
convert mindex=m7/transformout=(cmovave 7 trim 3); /* m=7일 때, 중심이동평균법 */
run; quit;
proc print data=out1; run; /* 결과 출력 */
proc sgplot data=out1; /* m=3일 때 평활그림; 좀더 민감 */
series x=date y=mindex/lineattrs=(pattern=1 color=blue); /* 원시계열 */
series x=date y=m3/lineattrs=(pattern=2 color=black); /* 3항 단순이동평균 */
xaxis values=('1jan86'd to '1jan94'd by year);
run ;quit;
proc sgplot data=out1; /* m=7일 때 평활그림; 좀더 완만 */
series x=date y=mindex/lineattrs=(pattern=1 color=blue); /* 원시계열 */
series x=date y=m7/lineattrs=(pattern=2 color=black); /* 7항 단순이동평균 */
xaxis values=('1jan86'd, to '1jan94'd by year);
run ;quit;

/* 예제3 이동평균법에 의한 분해법 */ 

/* (1) 데이터 불러오기 및 변수 생성 */
data food;
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt";
input food @@; 
date=intnx('month','1jan80'd,_n_-1); format date monyy.;
t+1; mon=month(date); run; quit; 

/* (2) 이동평균법에 의한 분해법 with 가법모형 */
proc expand data=food out=out2;
convert food=tc/transformout=(cda_tc 12); /* tc; 추세순환성분 */
convert food=s/transformout=(cda_s 12); /* s; 계절성분 */
convert food=i/transformout=(cda_i 12); /* i; 불규칙성분 */
convert food=sa/transformout=(cda_sa 12); /* sa; 계절조정 */
run; quit;
proc sgplot data=out2; /* 추세순환성분; 예4.1과 비교 */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=tc/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* 계절성분 */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=s/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* 불규칙성분 */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=i/lineattrs=(pattern=2 color=black);
run; quit;
proc sgplot data=out2; /* 계절조정 */
series x=date y=food/lineattrs=(pattern=1 color=purple);
series x=date y=sa/lineattrs=(pattern=2 color=black);
run; quit;

/* 예제4 계절조정 */

/* (1) 데이터불러오기 및 변수생성 */
data food;
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt";
input food @@; 
date=intnx('month','1jan80'd,_n_-1); format date monyy.;
t+1; mon=month(date); run; quit; 

/* (2) proc X12의 X11방법에 의한 분해법 및 계절조정 */
proc X12 data=food seasons=12 start=jan1980;
var food; x11;
output out=out3 a1 d10 d11 d12 d13;
run ;quit;
proc print data=out3; run;

/* (3) X11을 이용한 계절조정 결과 확인 */
proc sgplot data=out3;
series x=_DATE_ y=food_D10; /* 계절성분 */
run; quit;
proc sgplot data=out3;
series x=_DATE_ y=food_A1; /* 원시계열 */
series x=_DATE_ y=food_D11; /* 계절조정 */
run; quit;
proc sgplot data=out3; 
series x=_DATE_ y=food_A1; /* 원시계열 */
series x=_DATE_ y=food_D12; /* 추세순환성분 */
run; quit;
proc sgplot data=out3;
series x=_DATE_ y=food_D13; /* 불규칙성분 */
refline 1.0/axis=y; /* 승법모형; 평균 1을 중심으로 랜덤하게 산포 */
run; quit;
proc arima data=out3;
identify var=food_D13 nlag=24; /* 불규칙성분의 자기상관성 확인 */
run; quit;
