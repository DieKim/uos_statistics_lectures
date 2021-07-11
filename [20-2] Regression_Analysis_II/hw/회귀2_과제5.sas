/* Q1 */

/* (1) 아프리카 코끼리의 짝짓기 성공 데이터 입력 */
data ex1;
input age matings @@;
cards;
27 0 28 1 28 1 28 1 28 3 29 0 29 0 29 0 29 2 29 2 29 2 30 1
32 2 33 4 33 3 33 3 33 3 33 2 34 1 34 1 34 2 34 3 36 5 36 6
37 1 37 1 37 6 38 2 39 1 41 3 42 4 43 0 43 2 43 3 43 4 43 9
44 3 45 5 47 7 48 2 52 9
; run;

/* (2) 산점도 확인 */
proc sgplot data=ex1;
scatter X=age Y=matings;
run; quit;

/* (3) 포아송 회귀모형 적합 */
proc genmod data=ex1;
model matings=age /dist=poisson link=log type3;
output out=out1 pred=predicted resdev=resid;
run; quit;

/* (4) 추정된 모형 및 잔차 plot */
title " " ;
proc sgplot data=out1;
scatter X=age Y=matings;
scatter X=age Y=predicted;
series X=age Y=predicted;
run; quit;
proc sgplot data=out1;
scatter X=age Y=resid;
refline 0/axis=y;
run; quit;

/* (5) 모형의 Deviance를 이용하여 goodness of fit 검정 */
data ex1_dev;
dev = 51.0116;
df = 39;
p_value = 1-probchi(dev,df);
run;
proc print data=ex1_dev;
title1 " Deviance statistic and p-value";
run;

/* (6) 이차항 포함 */
data ex1_;
set ex1;
age2=age**2;
proc genmod data=ex1_;
model matings=age age2/dist=poisson link=log type3;
output out=out2 pred=predicted resdev=resid;
run;

/* Q2 */

/* (1) 물벼룩 재생 데이터 불러오기 */
data ex2;
input Cerio Conc Strain @@;
cards;
82 0 1 106 0 1 63 0 1 99 0 1 101 0 1 45 0.5 1
34 0.5 1 26 0.5 1 44 0.5 1 42 0.5 1 31 0.75 1
22 0.75 1 16 0.75 1 30 0.75 1 29 0.75 1 22 1 1
14 1 1 10 1 1 21 1 1 20 1 1 15 1.25 1 8 1.25 1 6
1.25 1 14 1.25 1 13 1.25 1 10 1.5 1 8 1.5 1 11 1.5 1
10 1.5 1 10 1.5 1 8 1.75 1 8 1.75 1 3 1.75 1
8 1.75 1 1 1.75 1 58 0 2 58 0 2 62 0 2 58 0 2 73 0 2
27 0.5 2 28 0.5 2 31 0.5 2 28 0.5 2 38 0.5 2
19 0.75 2 20 0.75 2 22 0.75 2 20 0.75 2 28 0.75 2
14 1 2 14 1 2 15 1 2 14 1 2 21 1 2
9 1.25 2 10 1.25 2 12 1.25 2 10 1.25 2 16 1.25 2
7 1.5 2 3 1.5 2 1 1.5 2 8 1.5 2 7 1.5 2
4 1.75 2 3 1.75 2 2 1.75 2 8 1.75 2 4 1.75 2
; run;

/* (2) 산점도 확인 */
proc gplot data=ex2;
plot cerio *conc=strain / haxis=axis2 vaxis=axis1;
axis1 major=(w=1 h=1) minor=(w=1 h=0.5)
label=(f=duplex h=3 C=black A=90 R=0 "Ceriodaphnia") value=(h=2);
axis2 major=(w=1 h=1) minor=(w=1 h=0.5)
label =(f=duplex h=3 C=black "Concentration") value=(h=2) ;
symbol1 v=circle c=blue i=none h=1;
symbol2 v=dot c=red i=none h=1;
title h=5 'Scatter plot ' h=3.5 ;
run; quit;

/* (3) 포아송 회귀모형 적합 */
proc genmod data=ex2;
model cerio = conc strain /dist=poisson link=log type3;
output out=out3 pred=predicted resdev=resid;
run;

/* (4) 추정된 모형 및 잔차 plot */
proc gplot data=out3;
plot predicted * conc = strain /haxis=axis2 vaxis=axis1;
axis1 major=(w=1 h=1) minor=(w=1 h=0.5)
label =(f=duplex h=3 C=black A=90 R=0 "Predicted Values") value=(h=2);
axis2 major=(w=1 h=1) minor=(w=1 h=0.5)
label =(f=duplex h=3 C=black "Concentration") value=(h=2) ;
symbol1 v=dot i=spline h=1;
symbol2 v=dot i=spline h=1;
title h=4 'Predicted value ';
run ; quit;
proc gplot data=out3;
plot resid * conc /haxis=axis2 vaxis=axis1 vref=0 ;
axis1 major=(w=1 h=1) minor=(w=1 h=0.5)
label =(f=duplex h=3 C=black A=90 R=0 "Residuals") value=(h=2);
axis2 major=(w=1 h=1) minor=(w=1 h=0.5)
label =(f=duplex h=3 C=black "Concentration") value=(h=2) ;
symbol i=none v=dot c=blue h=1 ;
title 'Residual Plot';
run ; quit;

/* (5) 모형의 Deviance를 이용하여 goodness of fit 검정 */
data ex2_dev;
dev = 86.3765;
df = 67;
p_value = 1-probchi(dev,df);
run;
proc print data=ex2_dev;
title1 " Deviance statistic and p-value";
run;
