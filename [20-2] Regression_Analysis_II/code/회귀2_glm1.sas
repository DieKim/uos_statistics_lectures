/* 예제1 에이즈로 인한 사망자 수 데이터 */

/* 데이터 입력 */
data a;
input month count @@;
lmonth = log(month);
cards;
1 0 2 1 3 2 4 3 5 1 6 4 7 9
8 18 9 23 10 31 11 20 12 25 13 37 14 45
; run;

/* 산점도 확인 */
proc gplot data=a;
plot count*month;
symbol v=dot i=none C=red;
run; quit;

/* 선형회귀모형 적합 */
proc genmod data=a;
model count=month/link=id dist=normal;
run; quit;

proc gplot data=a;
plot count*month;
symbol v=dot i=r;
run; quit;

/* 포아송선형회귀모형 적합 */
proc genmod data=a;
model count=month/dist=poisson link=id obstats;
output out=b pred=fitted upper=upper lower=lower;
run; quit;

proc gplot data=b;
plot count*month=1 fitted*month=2/overlay;
symbol1 c=blue v=dot i=none;
symbol2 c=red v=none i=join;
run; quit;

/* 포아송회귀모형 적합 */
proc genmod data=a;
model count=month/dist=poisson link=log;
output out=b pred=fitted upper=upper lower=lower;
run; quit;

proc gplot data=b;
plot count*month=1 fitted*month=2/overlay;
symbol1 c=blue v=dot i=none;
symbol2 c=red v=none i=join;
run; quit;

/* x의 로그변환 for 과산포 해결 */
data d;
set a;
if count > 0;
lcount = log(count);
run;

proc gplot data=d;
plot lcount * lmonth/overlay;
symbol1 c=blue v=dot i=none;
run ; quit;

/* x의 로그변환 후 포아송회귀모형 */
proc genmod data=d;
model count=lmonth/dist=poisson link=log;
output out=c pred=fitted upper=upper lower=lower;
run; quit;

proc gplot data=c;
plot count*month=1 fitted*month=2/overlay;
symbol1 c=blue v=dot i=none;
symbol2 c=red v=none i=join;
run; quit;


/* 예제2 아프리카 코끼리 짝짓기 데이터 */

/* 데이터 입력 및 산점도 */
data a;
input age matings @@;
cards;
27 0 28 1 28 1 28 1 28 3 29 0 29 0 29 0 29 2 29 2 29 2 30 1
32 2 33 4 33 3 33 3 33 3 33 2 34 1 34 1 34 2 34 3 36 5 36 6
37 1 37 1 37 6 38 2 39 1 41 3 42 4 43 0 43 2 43 3 43 4 43 9
44 3 45 5 47 7 48 2 52 9
; run;

proc gplot ;
plot matings * age;
symbol v=circle c=blue;
run ;quit;

/* 선형회귀모형 적합 */
proc reg data=a;
model matings=age;
plot matings *age;
plot rstudent. * age;
plot rstudent. * obs.;
run; quit;

/* 포아송회귀모형 적합 */
proc genmod data=a;
model matings=age/dist=poission link=log type3;
output out=c pred=predicted resdev=resid;
run; quit;

proc gplot data=c;
plot (matings predicted)*age/overlay;
symbol1 v=dot i=none;
symbol2 v=dot i=spline;
run; quit;

proc gplot data=c;
plot resid*age/vref=0;
symbol1 v=dot i=none;
run ; quit;

/* 이차항 추가 */
data b;
set a;
age2=age**2;

proc genmod data=b;
model matings=age age2/dist=poisson link=log type3;
run;


/* 예제3 물벼룩 재생 데이터 */

/* 데이터 입력 및 산점도 확인 */
data a;
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
proc print; run;

proc gplot data=a;
plot cerio*conc=strain/overlay;
symbol1 v=circle c=blue i=none;
symbol2 v=dot c=red i=none;
run; quit;

/* 선형회귀모형 적합 */
proc reg data=a;
model cerio = conc strain ;
output out=b p=pred r=resid;
plot cerio * conc = strain; /* or proc gplot으로 가능 */
run;
proc gplot data=b;
plot resid *conc/vref=0;
symbol1 v=circle c=blue i=none;
run ; quit ;

/* log(y) 변환 후 선형회귀모형 적합 */
data f;
set a;
l_cerio= log(cerio);
run;

proc reg data=f ;
model l_cerio = conc strain ;
output out=g p=pred r=resid;
plot ( l_cerio pred) * conc;
run;

proc gplot data=g;
plot resid * conc /vref=0;
symbol v=dot i=none;
run; quit;

/* 포아송회귀모형 적합 */
proc genmod data=a;
class strain/param=ref;
model cerio = conc strain /dist=poisson link=log type3;
output out=d pred=predicted resdev=resid;
run ;

proc gplot data=d;
plot predicted * conc = strain;
symbol1 v=dot i=spline h=1;
symbol2 v=dot i=spline h=1;
run ; quit;

proc gplot data=d;
plot resid * conc /vref=0;
symbol i=none v=dot c=blue;
run ; quit;
