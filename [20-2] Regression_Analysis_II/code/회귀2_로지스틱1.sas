/* 예제1 신생아 몸무게 데이터 */

/* 데이터 입력 */ 
data baby;
input bwght gage @@;
cards;
1 40 1 40 1 37 1 41 1 40 1 38 1 40 1 40 1 38 1 40 1 40 1 42 1 39
1 40 1 36 1 38 1 39 0 38 0 35 0 36 0 37 0 36 0 38 0 37
; run;
proc sort ; by descending bwght descending gage; run;
proc print; run;

/* 산점도 확인 */
proc gplot data=baby;
plot bwght * gage;
symbol v=dot i=none C=red;
run; quit;

/* 로지스틱 회귀; 기본 */
proc logistic data=baby;
model bwght=gage;
run; quit;

/* 로지스틱 회귀; 기준에 따라 */
proc logistic data=a descending;
model bwght=gage;
run;
proc logistic data=a ;
model bwght(descending)=gage;
run;
proc logistic data=a;
model bwght(event='1')=gage;
run;
proc logistic data=a;
model bwght(ref='0')=gage;
run;

/* 로지스틱 곡선 */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper;
run; quit;

proc sort; by gage; run; /* 오름차순 */
proc print; run;
proc gplot data=out;
plot (bwght p)*gage/overlay;
symbol1 v=star i=none C=red; /* 산점도 */
symbol2 v=circle i=join C=blue; /* 로지스틱 곡선 */
run; quit;

/* 예측확률과 신뢰구간 */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper/alpha=0.1; /* 90% 신뢰구간 */
run; quit;

proc sort; by gage; run;
proc gplot data=out;
plot (lower p upper)*gage/overlay;
symbol1 v=none i=spline C=blue; /* 신뢰하한 */
symbol2 v=none i=spline C=black; /* 예측확률(로지스틱 곡선) */
symbol3 v=none i=spline C=blue; /* 신뢰상한 */
run; quit;

/* 분류 by 로지스틱 */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out lower=lower p=p upper=upper;
run; quit;

data classfication;
set out;
if p>0.5 then Pr=1;
else Pr=0;
proc sort; by gage bwght;
proc print;
var gage bwght p Pr;
run;

proc freq;
tables bwght*Pr/nopercent norow nocol;
run; quit;

/* 적합결여; Lack of Fit by 호스머-렘쇼 검정 */
proc logistic data=baby;
model bwght(ref="0")=gage/lackfit;
run; quit;

/* 모형진단; 편차잔차, 피어슨잔차 */
proc logistic data=baby;
model bwght(ref="0")=gage;
output out=out reschi=pearson resdev=deviance p=p;
run; quit;
proc print; run;


/* 예제2 사형선고 데이터 */

/* 데이터 입력 */
data death;
input Aggrav Race$ DeathY DeathN @@;
sum=deathy+deathn;
percent=deathy/sum; 
cards;
1 White 2 60 1 Black 1 181 2 White 2 15 2 Black 1 21
3 White 6 7 3 Black 2 9 4 White 9 3 4 Black 2 4
5 White 9 0 5 Black 4 3 6 White 17 0 6 Black 4 0
; run;
proc print; run;

/* 인종별 사형선고 받을 확률의 그래프 확인 */
proc gplot data=death;
plot percent*aggrav=race; /* race별 확률 연결 */
symbol1 v=circle i=join C=blue;
symbol2 v=star i=join C=red;
run; quit;

/* 로지스틱 회귀모형 적합 */
proc logistic data=death;
class race(ref="Black");
model deathy/sum=race aggrav;
output out=out lower=lower p=p upper=upper;
run; quit; 

/* 예측곡선, 신뢰구간 확인 */
proc gplot data=out; /* 인종별  예측곡선 */
plot p*aggrav=race/overlay;
symbol1 v=none i=spline C=blue;
symbol2 v=none i=spline C=red;
run; quit;

proc gplot data=out; /* 신뢰구간 포함 */
plot (lower p upper)*aggrav/overlay;
symbol1 v=none i=spline C=black;
symbol2 v=none i=spline C=red;
symbol3 v=none i=spline C=black;
run; quit;

/* 적합결여 및 모형진단 */
proc logistic data=death;
class race(ref="Black");
model deathy/sum=race aggrav/lackfit;
output out=out p=p reschi=pearson resdev=deviance;
run; quit; 
proc print; run;
