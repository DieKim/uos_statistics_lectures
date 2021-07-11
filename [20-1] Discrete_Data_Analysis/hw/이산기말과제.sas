/* Q4.1 */

/* 데이터 입력 */
data crab;
input color spine  width  satell  weight;   
if satell>0 then y=1; if satell=0 then y=0;
cards;  
 2  3  28.3  8  3.05
 3  3  22.5  0  1.55
 1  1  26.0  9  2.30
 3  3  24.8  0  2.10
 3  3  26.0  4  2.60
 2  3  23.8  0  2.10
 1  1  26.5  0  2.35
 3  2  24.7  0  1.90
 2  1  23.7  0  1.95
 3  3  25.6  0  2.15
 3  3  24.3  0  2.15
 2  3  25.8  0  2.65
 2  3  28.2 11  3.05
 4  2  21.0  0  1.85
 2  1  26.0 14  2.30
 1  1  27.1  8  2.95
 2  3  25.2  1  2.00
 2  3  29.0  1  3.00
 4  3  24.7  0  2.20
 2  3  27.4  5  2.70
 2  2  23.2  4  1.95
 1  2  25.0  3  2.30
 2  1  22.5  1  1.60
 3  3  26.7  2  2.60
 4  3  25.8  3  2.00
 4  3  26.2  0  1.30
 2  3  28.7  3  3.15
 2  1  26.8  5  2.70
 4  3  27.5  0  2.60
 2  3  24.9  0  2.10
 1  1  29.3  4  3.20
 1  3  25.8  0  2.60
 2  2  25.7  0  2.00
 2  1  25.7  8  2.00
 2  1  26.7  5  2.70
 4  3  23.7  0  1.85
 2  3  26.8  0  2.65
 2  3  27.5  6  3.15
 4  3  23.4  0  1.90
 2  3  27.9  6  2.80
 3  3  27.5  3  3.10
 1  1  26.1  5  2.80
 1  1  27.7  6  2.50
 2  1  30.0  5  3.30
 3  1  28.5  9  3.25
 3  3  28.9  4  2.80
 2  3  28.2  6  2.60
 2  3  25.0  4  2.10
 2  3  28.5  3  3.00
 2  1  30.3  3  3.60
 4  3  24.7  5  2.10
 2  3  27.7  5  2.90
 1  1  27.4  6  2.70
 2  3  22.9  4  1.60
 2  1  25.7  5  2.00
 2  3  28.3 15  3.00
 2  3  27.2  3  2.70
 3  3  26.2  3  2.30
 2  1  27.8  0  2.75
 4  3  25.5  0  2.25
 3  3  27.1  0  2.55
 3  3  24.5  5  2.05
 3  1  27.0  3  2.45
 2  3  26.0  5  2.15
 2  3  28.0  1  2.80
 2  3  30.0  8  3.05
 2  3  29.0 10  3.20
 2  3  26.2  0  2.40
 2  1  26.5  0  1.30
 2  3  26.2  3  2.40
 3  3  25.6  7  2.80
 3  3  23.0  1  1.65
 3  3  23.0  0  1.80
 2  3  25.4  6  2.25
 3  3  24.2  0  1.90
 2  2  22.9  0  1.60
 3  2  26.0  3  2.20
 2  3  25.4  4  2.25
 3  3  25.7  0  1.200
 2  3  25.1  5  2.100
 3  2  24.5  0  2.250
 4  3  27.5  0  2.900
 3  3  23.1  0  1.650
 3  1  25.9  4  2.550
 2  3  25.8  0  2.300
 4  3  27.0  3  2.250
 2  3  28.5  0  3.050
 4  1  25.5  0  2.750
 4  3  23.5  0  1.900
 2  2  24.0  0  1.700
 2  1  29.7  5  3.850
 2  1  26.8  0  2.550
 4  3  26.7  0  2.450
 2  1  28.7  0  3.200
 3  3  23.1  0  1.550
 2  1  29.0  1  2.800
 3  3  25.5  0  2.250
 3  3  26.5  1  1.967
 3  3  24.5  1  2.200
 3  3  28.5  1  3.000
 2  3  28.2  1  2.867
 2  3  24.5  1  1.600
 2  3  27.5  1  2.550
 2  2  24.7  4  2.550
 2  1  25.2  1  2.000
 3  3  27.3  1  2.900
 2  3  26.3  1  2.400
 2  3  29.0  1  3.100
 2  3  25.3  2  1.900
 2  3  26.5  4  2.300
 2  3  27.8  3  3.250
 2  3  27.0  6  2.500
 3  3  25.7  0  2.100
 2  3  25.0  2  2.100
 2  3  31.9  2  3.325
 4  3  23.7  0  1.800
 4  3  29.3 12  3.225
 3  3  22.0  0  1.400
 2  3  25.0  5  2.400
 3  3  27.0  6  2.500
 3  3  23.8  6  1.800
 1  1  30.2  2  3.275
 3  3  26.2  0  2.225
 2  3  24.2  2  1.650
 2  3  27.4  3  2.900
 2  2  25.4  0  2.300
 3  3  28.4  3  3.200
 4  3  22.5  4  1.475
 2  3  26.2  2  2.025
 2  1  24.9  6  2.300
 1  2  24.5  6  1.950
 2  3  25.1  0  1.800
 2  1  28.0  4  2.900
 4  3  25.8 10  2.250
 2  3  27.9  7  3.050
 2  3  24.9  0  2.200
 2  1  28.4  5  3.100
 3  3  27.2  5  2.400
 2  2  25.0  6  2.250
 2  3  27.5  6  2.625
 2  1  33.5  7  5.200
 2  3  30.5  3  3.325
 3  3  29.0  3  2.925
 2  1  24.3  0  2.000
 2  3  25.8  0  2.400
 4  3  25.0  8  2.100
 2  1  31.7  4  3.725
 2  3  29.5  4  3.025
 3  3  24.0 10  1.900
 2  3  30.0  9  3.000
 2  3  27.6  4  2.850
 2  3  26.2  0  2.300
 2  1  23.1  0  2.000
 2  1  22.9  0  1.600
 4  3  24.5  0  1.900
 2  3  24.7  4  1.950
 2  3  28.3  0  3.200
 2  3  23.9  2  1.850
 3  3  23.8  0  1.800
 3  2  29.8  4  3.500
 2  3  26.5  4  2.350
 2  3  26.0  3  2.275
 2  3  28.2  8  3.050
 4  3  25.7  0  2.150
 2  3  26.5  7  2.750
 2  3  25.8  0  2.200
 3  3  24.1  0  1.800
 3  3  26.2  2  2.175
 3  3  26.1  3  2.750
 3  3  29.0  4  3.275
 1  1  28.0  0  2.625
 4  3  27.0  0  2.625
 2  2  24.5  0  2.000
; 
run;
/* 일반화선형모형 적합 */
proc genmod; 
model satell = weight / dist=poi link=log type1; 
run;
/* 최대우도추정에  의한 모형적합 */
proc genmod data = crab descending;
model y = weight / dist = bin link = identity;
run;
/* 로지스틱회귀모형 적합 */
proc genmod data = crab descending;
model y = weight / dist = bin link = probit;
run;

/* Q4.4 */
data crab1;
set study.crab;
if weight < 2; then wf = 0;
if weight < 2.25&2 =< weight then wf = 1;
if weight < 2.5&2.25 =< weight then wf = 2;
if weight < 2.75&2.5 =< weight then wf = 3;
if weight < 3&2.75 =< weight then wf = 4;
if 3=<weight ; then wf = 5;
keep satell weight;
run;

/* Q4.6 */
data train;
input count dist @@;
datalines;
3 281 6 276 4 268 2 265 4 264 1 267
7 265 3 267 5 260 6 231 1 249
run;

proc genmod data = train;
model  count=/dist = poi;
run;

proc sort data = crab1; by wf;  run;

proc means data = crab1;
by wf;
var satell;
output mean = mean out = crab2;
run;

proc genmod data = crab2; 
model mean = wf / dist = poi link = log pred residuals type1;
run;



/* Q4.6 */

/* 열차의 주행거리 data 입력 */
data ex6;
input year collision distance @@;
cards;
1970 3 281 1971 6 276
1972 4 268 1973 7 269
1974 6 281 1975 2 271
1976 2 265 1977 4 264 
1978 1 267 1979 7 265
1980 3 267 1981 5 260
1982 6 231 1983 1 249
;
run;
/* 일반화선형모형 적합 */
proc genmod data=ex6;
model collision=distance / dist=poi link=log type1; 
run;


/* Q5.1 */

/* 데이터 입력 */
data ex5_1;
input temperature damage;
cards;
66 0
70 1
69 0
68 0
67 0
72 0
73 0
70 0
57 1
63 1
70 1
78 0
67 0
53 1
67 0
75 0
70 0
81 0 
76 0
79 0
75 1
76 0
58 1
;
run;
/* 로지스틱회귀모형 적합 */
proc logistic descending;
model damage = temperature/covb lackfit;
run; quit;



/* Q5.2 */

/* 데이터 입력 */
data ex5_2;
input age y @@;
cards;
12 1 15 1 42 1 52 1 59 1
73 1 82 1 71 1 96 1 105 1
114 1 120 1 124  1 128 1 130 1
139 1 139 1 157 1 1 0 1 0
2 0 8 0 11 0 18 0  22 0 
31 0 37 0 61 0 72 0 81 0
97 0 112 0 118 0 127  0 131 0
140 0 151 0 159 0 177 0 206 0
;
run;
proc sgplot data = ex5_2;
scatter x = age y = y;
run;


/* 로지스틱회귀모형 적합 */
proc logistic descending plots=(effect);
model y = age/covb lackfit;
run; quit;

/* 로짓모형 적합 */
proc logistic descending plots=(effect);
model y = age age*age/covb lackfit;
run; quit;

data ex5_2;
set ex5_2;
agesq = age++2;
run;

proc genmod data = ex5_2 descending;
model y = agesq age/dist = bin link = logit type3;
output p = pred out = fit;
run;

data a;
set ex5_2;
set fit;
fit = pred>0.5;
run;

proc sgplot data = a;
scatter x = age y = y / group = fit;
run;


/* Q5.3 */
data ex5_3;
input smoke yes no @@;
tot = yes+no;
cards;
0 90 346 7.5 57 91
19.5 65 48 30 40 18
run;

proc genmod data = ex5_3 ;
model yes/tot = smoke / dist = bin link = logit obstats type3;
run;


/* 데이터 입력 */
data ex5_3;
input smoke count y @@;
cards;
0 90 1 7.5 57 1
19.5 65 1 30 40 1
0 346 0 7.5 91 0
19.5 48 0 30 18 0
;
run; 
/* 로지스틱회귀모형 적합 */
proc logistic data=ex5_3 order=data;
weight count;
class smoke/param=ref ref=first;
model  y = smoke/influence;
run; quit;


/* Q5.4 */

data crab;
set crab;
if satell > 0 then y = 1; else y = 0; run;

proc genmod data = crab descending;
model y = weight/dist = bin link = logit type3;
output pred = fit out = fit;
run;

data aa; set crab fit; run;

proc sort data = aa; by weight; run;

proc sgplot data = aa;
scatter x = weight y = y;
series x = weight y = fit;
run;

/* 로지스틱회귀모형 적합 */
proc logistic descending;
model y = weight/covb lackfit;
run; quit;


/* Q5.5 */
data ex5_5;
input coffee smoking y;
cards;
; 

data ex5_5;
input smoke coffee yes no @@;
tot = yes + no;
cards;
0 0 66 123 0 1.5 141 179 0 3.5 113 106 0 5.5 129 80
12 0 30 52 12 1.5 59 45 12 3.5 63 65 12 5.5 102 58
30 0 15 12 30 1.5 53 22 30 3.5 55 16 30 5.5 118 44
40 0 36 13 40 1.5 69 25 40 3.5 119 30 40 5.5 373 85
run;
proc genmod data = ex5_5 descending;
class smoke coffee;
model yes/tot = smoke coffee/dist = bin link = logit type3;
run;




/* Q5.6 */

/* 로지스틱회귀모형 적합 */
proc logistic descending;
model y = weight width/covb lackfit;
run; quit;
/* 교호작용 고려 */
proc logistic descending;
model y = weight width weight*width/covb lackfit;
run; quit;
/* or? */
proc genmod;
model y = weight width weight*width/dist=bin link=logit type3;
run; quit;


proc genmod data = crab descending;
model y =/dist=bin link=logit; run;
