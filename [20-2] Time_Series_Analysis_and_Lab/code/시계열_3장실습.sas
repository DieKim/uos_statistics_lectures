/* 3장 평활법 */

/* 예제1 단순지수평활에 의한 예측 */

/* (1) 데이터 불러오기; mindex.txt */
data mindex;
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\mindex.txt";
input mindex @@; 
date=intnx('month','1jan86'd,_n_-1); 
format date monyy.; run; 

/* (2) 시계열도 확인; 평균 수준이 시간대별로 다름 -> 단순지수평활법 */
proc sgplot data=mindex;
series x=date y=mindex;
run; quit;

/* (3) w=0.6일 때 이중지수평활법; w 선택 by SSE 최소 */
proc forecast data=stock
interval=month method=expo out=out1 outest=est1
weight=0.6 trend=2 lead=6 outfull outresid;
id date; var stock; run; quit;
proc print data=out1; run; /* 데이터 */
proc print data=est1; run; /* 통계량 */
proc sgplot data=out1; /* 이중지수평활된 시계열도 */
series x=date y=stock/group=_type_;
where _type_^='RESIDUAL'; 
refline '01jan92'd/axis=x;
yaxis values=(100 to 1100 by 100); run; quit;
data out11; set out1; /* 예측오차 */ 
  if _type_='RESIDUAL'; error=stock; run;
proc sgplot data=out11; /* 예측오차의 시계열도 */
  series x=date  y=error;
  refline  0 / axis=y; 
  yaxis values=(-100 to 150 by 50); run;
proc arima data=out11; identify var=error; run; /* 오차의 자기상관성 확인 */
proc univariate data=out11; var error; run; /* 오차의 기술통계량 확인 */

/* 단순지수평활된 시계열도 + 예측오차의 시계열도 등을 보니 w=0.89 > w=0.2로 결론 */

/* 예제2 이중지수평활에 의한 예측 */

/* (1) 데이터 불러오기; stock.txt */
data stock;
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\stock.txt";
input stock @@; 
date=intnx('month','1jan84'd,_n_-1); 
format date monyy.; run; 

/* (2) 시계열도 확인; 추세가 시간대별로 다름 -> 이중지수평활법 */
proc sgplot data=stock;
series x=date y=stock;
run; quit;

/* (3) w=0.89일 때 단순지수평활법; w 선택 by SSE 최소 */
proc forecast data=mindex
interval=month method=expo out=out3 outest=est3
weight=0.89 trend=1 lead=6 outfull outresid;
id date; var mindex; run; quit;
proc print data=out3; run; /* 데이터 */
proc print data=est3; run; /* 통계량 */
proc sgplot data=out3; /* 단순지수평활된 시계열도 */
series x=date y=mindex/group=_type_;
where _type_^='RESIDUAL'; 
refline '01may94'd/axis=x;
yaxis values=(0 to 30 by 5); run; quit;
data out33; set out3; /* 예측오차 */ 
  if _type_='RESIDUAL'; error=mindex; run;
proc sgplot data=out33; /* 예측오차의 시계열도 */
  series x=date  y=error;
  refline  0 / axis=y; 
  yaxis values=(-6 to 5 by 1);run;
proc arima data=out33; identify var=error; run; /* 오차의 자기상관성 확인 */
proc univariate data=out33; var error; run; /* 오차의 기술통계량 확인 */

/* 단순지수평활된 시계열도 -> 잘 적합된 듯하다 */
/* 예측오차의 시계열도 -> 이분산성 감지, 개선 필요 */

/* 예제3 Winters의 계절지수평활에 의한 예측 with 승법모형 */ 

/* (1) 데이터 불러오기; koreapass.txt */
data koreapass;
infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\koreapass.txt";
input pass @@; 
date=intnx('month','1jan81'd,_n_-1); 
format date monyy.; run; 

/* (2) 시계열도 확인; 변화하는 선형추세+계절추세+이분산성 */
proc sgplot data=koreapass;
series x=date y=pass;
run; 

/* (3) 가법계절지수평활법; 비교를 위해 */
proc forecast data=koreapass
  interval=month method=addwinters out=out4 outest=est4 /* 가법; addwinters */
  weight=0.4 weight=0.1 weight=0.7 lead=12 seasons=12 /* w=(0.4, 0.1, 0.7) */
  outfull outresid;
  id date; var pass; run; 
proc print data=est4; run;
proc print data=out4; run;   
proc sgplot data=out4; /* 가법계절지수평활된 시계열도 */
  series x=date y=pass / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01jan90'd / axis=x; run; 
data out44; set out4;  
  if _type_='RESIDUAL'; error=pass;  run;
proc sgplot data=out44; /* 예측오차의 시계열도 */
  series x=date  y=error;
  refline  0 / axis=y;  run;
proc arima data=out44; identify var=error; run; 
proc univariate data=out44; var error; run; 

/* (4) 승법계절지수평활법 */
proc forecast data=koreapass
  interval=month method=winters out=out5 outest=est5 /* 승법; winters */
  weight=0.5 weight=0.1 weight=0.4 lead=12 seasons=12
  outfull outresid;
  id date; var pass; run;
proc print data=est5; run;
proc print data=out5; run; 
proc sgplot data=out5; /* 승법계절지수평활된 시계열도 */
  series x=date y=pass / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01jan90'd / axis=x; run; 
data out55; set out5;  
  if _type_='RESIDUAL'; error=pass;  run;
proc sgplot data=out55; /* 예측오차의 시계열도; 가법보단 낫지만 여전히 끝은 불안정 */
  series x=date y=error;
  refline 0 / axis=y; run;
proc arima data=out55; identify var=error; run; 
proc univariate data=out55; var error; run;  
