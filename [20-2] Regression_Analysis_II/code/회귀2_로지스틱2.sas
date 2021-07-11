/* 예제1 Donner 데이터 */

/* 데이터 입력 */
data donner2;
set "C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\Donner2.sas7bdat";
run; quit;
proc print; run; 

/* 로지스틱 회귀; 생존여부(Surv)에 성별(gender)과 나이(age)의 영향  */
proc logistic data=donner2;
class gender(ref="0");
model surv(ref="0")=gender age;
output out=out p=p;
run; quit;

/* 대충 로지스틱 곡선 */
proc sort; by age surv gender; run;
proc gplot data=out;
plot p*age=gender;
symbol1 v=dot i=join c=blue;
symbol2 v=dot i=join c=blue;
run;

/* 로지스틱 회귀; gender=0 대비 1의 효과를 알기위한 코딩 */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender age/tech=newton;
run; quit;

/* 로지스틱 회귀; 변수선택법 중 stepwise, 반복법 NR */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender age/tech=newton selection=stepwise;
run; quit;

/* 로지스틱 회귀; 교호작용 추가 및 age에 따른 오즈비 구하기 */
proc logistic data=donner2;
class gender (ref="0");
model surv=gender | age/tech=newton;
oddsratio gender/at (age=10 20 30);
run; quit; 


/* 예제2 ingots 데이터 */

/* 데이터 입력 */
data ingots; 
input Heat Soak r n @@; 
datalines; 
7 1.0 0 10 14 1.0 0 31 27 1.0 1 56 51 1.0 3 13 
7 1.7 0 17 14 1.7 0 43 27 1.7 4 44 51 1.7 0 1 
7 2.2 0 7 14 2.2 2 33 27 2.2 0 21 51 2.2 0 1 
7 2.8 0 12 14 2.8 0 31 27 2.8 1 22 51 4.0 0 1 
7 4.0 0 9 14 4.0 0 19 27 4.0 1 16 
; run; quit;

/* 로지스틱 회귀 */
proc logistic data = ingots; 
model r / n = Heat Soak; 
run; quit;

/* 데이터 입력; 다른 방식으로 */
data ingots2; 
input Heat Soak NotReady Freq @@; 
datalines; 
7 1.0 0 10 14 1.0 0 31 14 4.0 0 19 27 2.2 0 21 51 1.0 1 3 
7 1.7 0 17 14 1.7 0 43 27 1.0 1 1 27 2.8 1 1 51 1.0 0 10 
7 2.2 0 7 14 2.2 1 2 27 1.0 0 55 27 2.8 0 21 51 1.7 0 1 
7 2.8 0 12 14 2.2 0 31 27 1.7 1 4 27 4.0 1 1 51 2.2 0 1 
7 4.0 0 9 14 2.8 0 31 27 1.7 0 40 27 4.0 0 15 51 4.0 0 1 
; run; quit;

/* 다시 로지스틱 회귀 */
proc logistic data=ingots2;
model notready=heat soak; freq freq;
run; quit;


/* 예제3 사형선고 데이터 */

/* 데이터 입력 */
data dp2;
set "C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\dp.sas7bdat";
tot = deathn + deathy;
run; quit;
proc print; quit;

/* 로지스틱 회귀 */
proc logistic data=dp2;
class race (ref="Black");
model deathy/tot = race aggrav; 
run; quit;

/* 인종별 예측확률 그래프 */
proc logistic data=dp2;
class race (ref="Black");
model deathy/tot = race aggrav;
effectplot / at(race=all) noobs;
run; quit;

/* 공분산행렬, 결정계수, 95% wald 신뢰구간 */
proc logistic data=dp2; 
class race(ref="Black");
model deathy/tot=race aggrav/covb rsquare clparm=wald;
run; quit;

/* 변수선택법; forward, backward, stepwise */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/selection=backward;
run; quit;

/* 적합결여; 호스머-렘쇼 검정 */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/lackfit;
run; quit;

/* 모수 추정을 위한 최적화 반복법 by NR */
proc logistic data=dp2;
class race(ref="Black");
model deathy/tot=race aggrav/tech=newton;
run; quit;

/* 누적오즈비 모델링 */
proc logistic data=dp2;
class race(ref="Black");
model deathy=race aggrav;
run; quit;


/* 예제4 흡연과 폐암 데이터 */

/* 데이터 입력 */
data smoke; 
input cancer smoke @@; 
cards; 
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 
0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 
0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 
1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 
0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 
0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 
; run; quit;

/* 분할표, 오즈비, 상대위험 */
proc freq data=smoke;
tables smoke*cancer/relrisk;
run; quit;

/* 로지스틱 회귀 */
proc logistic data=smoke;
class smoke;
model cancer=smoke;
run; quit;

/* 데이터 추가 수집 */
data smoke2;
input cancer smoke @@;
cards;
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 
0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 
0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 0 1 1 0 1 1 
0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 
1 1 0 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 1 
0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 
1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 
1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 
; run; quit;

/* 추가된 데이터의 분할표, 오즈비, 상대위험 */
proc freq data=smoke2;
tables smoke*cancer/relrisk;
run; quit;


/* 예제5 CLASS 데이터 */

/* 데이터 입력 */
data class;
set "C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\class.sas7bdat";
run; quit;

/* 로지스틱 회귀 by Lasso, 기준 AIC */
proc hpgenselect data=class;
model sex(event="남") = height weight age / dist = binary;
selection method = lasson (choose = AIC) details = all;
run; quit;

/* 로지스틱 회귀 by Lasso, 기준 cv */
proc hpgenselect data=class; 
model sex(event="남") = height weight age / dist=binary; 
selection method=lasso(choose=validate) details = all; 
partition fraction(validate = 0.1); 
run; quit;
