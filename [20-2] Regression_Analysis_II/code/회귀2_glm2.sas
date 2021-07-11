/* 예제1 Warpbreaks */

/* 데이터 입력 */
data warpbreaks;
set "C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\warpbreaks.sas7bdat";
run; quit;
proc print; run;

/* 포아송회귀모형 적합 */
proc genmod data=warpbreaks;
class wool tension;
model breaks=wool tension/dist=poi;
run; quit;

/* goodness of fit 검정 by Deviance */
data dev_pval;
dev=210.3919;
df=50;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval;
title1 "Deviance statistic and p_value";
run; quit;

/* 유의확률 확인 결과, 더 복잡한 모형 적합 */
proc genmod data=warpbreaks;
class wool tension;
model breaks= wool | tension/dist=poi;
run; quit;

/* 다시 goodness of fit 검정 by Deviance */
data dev_pval2;
dev=182.3051;
df=48;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval2;
title1 "Deviance statistic and p_value";
run; quit;  

/* 음이항분포를 가정하고 모형 적합 */
proc genmod data=warpbreaks;
class wool tension;
model breaks=wool | tension/dist=negbin;
run; quit;

/* goodness of fit 검정 */
data dev_pval3;
dev=53.5064;
df=48;
p_value=1-probchi(dev,df);
run;

proc print data=dev_pval3;
title1 "Deviance statistic and p_value";
run; quit;  

/* 모수의 유의성 검정; 우도비 검정 */
proc genmod data = warpbreaks; 
class wool tension; 
model breaks = wool tension /type3 dist = poi; /* Full model */ 
output out = full_model resdev = full_dev; 
run; quit;

proc genmod data = warpbreaks; 
class wool tension; 
model breaks = / type3 dist = poi; /* Only 절편 model */ 
output out = int_model resdev = int_dev; 
run; quit;

data dev; 
merge full_model int_model; 
full_dev2 = full_dev**2; 
int_dev2 = int_dev**2; 
diff_dev = int_dev2 - full_dev2; /* Full 모델과 절편 모델의 차이 */
run; quit;
proc means data = dev sum; 
var diff_dev; 
output out = dev_out sum = sum; 
run; quit;

data lrt_pval; 
set dev_out; 
LRT = sum; 
df = 2; 
p_value = 1 - probchi(LRT,df); 
run;
proc print data=lrt_pval; 
title1 "LR test statistic and p-value"; 
run; quit;


/* 예제2 Bike */

/* 데이터 불러오기 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\bike.csv"
out=bike dbms=csv replace; getnames=yes;
run; quit;

/* 산점도와 히스토그램 */
proc sgplot data = bike; 
scatter X = dteday Y = cnt; /* 시간에 따른 대여 수 산점도 */
run; quit;

proc univariate data = bike; 
histogram cnt; /* 대여 수 히스토그램 */
run; quit;

/* 포아송회귀모형 */
proc genmod data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = Poi type3; 
run; quit;

/* 포아송회귀모형 + 변수선택법 */
proc hpgenselect data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = poisson; 
selection method = stepwise(choose = aicc); 
run; quit;

/* 다른 분포 하에서 모형 적합 */
proc genmod data = bike; 
class season yr mnth hr holiday weekday workingday weathersit; 
model cnt = season -- windspeed / dist = negbin; 
run; quit;

/* 음이항회귀모형 + 변수선택 */
proc hpgenselect data = bike; 
class season yr mnth hr holiday weekday workingday weathersit;
model cnt = season -- windspeed / dist = negativebinomial; 
selection method = lasso(choose = aic); 
run;

/* mnth 변수에 대해 더미변수 생성 후 모형선택 */
proc glmmod data = bike outdesign = design NOPRINT; 
class mnth; 
model cnt = season -- windspeed; 
run; quit;

proc hpgenselect data = design; 
class col2 col3 col4 col16 col17 col18 col19 col20; 
model cnt = col2 -- col24/ dist = negativebinomial; 
selection method = lasso(choose = bic); 
run; quit;

/* 다른 방법으로 더미변수 생성 후 모형선택 */
data bike3; 
array dummies(12) mnth1 - mnth12 (12*0); 
set bike; if mnth ne . then dummies(mnth) = 1; 
output; if mnth ne . then dummies(mnth) = 0; 
run; quit;

proc hpgenselect data = bike3(drop = weathersit); 
class season yr hr holiday weekday workingday; 
model cnt = mnth1 -- windspeed; 
selection method = stepwise(choose = bic); 
run; quit;
