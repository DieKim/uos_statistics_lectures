/* 제6장 ppt */

proc print data = a; /* print 절차 호출. 자료 a 인쇄 */
run; 
proc means data = b n mean std; /* means 절차에서 n, mean, std 등은 옵션 */
run; /* meanas 절차를 호출하여 자료 b의 관측수(n), 평균(mean), 표준편차(std)계산 */

data one;
input x total @@;
format total dallar10.2;
datalines;
3 28982 5 2849 
run;
proc print data = one;
format total dollar10.2; /* 출력형식 지정 */
run;

proc print data = class;
var in_num name credit; /* 출력을 원하는 변수 지정 */
run;
proc means data = class;
var _numeric_; /* 단축용법 */
run;

data a;
input country $ city $ month number;
cards;
Korea Seoul 1 5024
France Paris 2 1200
Korea Seoul 2 4214
France Paris 3 2354
Korea Busan 3 1347
Korea Seoul 4 6635
Korea Busan 4 987
France Paris 4 3308
Korea Seoul 5 3375
Korea Busan 5 334
France Paris 5 893
run;
proc print data = a;
run; /* 기본 출력(1) */
proc sort data = a;
by country city;
run; /* country기준으로 city 정렬 */
proc print data = a;
by country;
run; /* 정렬된 변수 country에 대해서 출력(2). sort 단계 이외의 by문장이므로 변수값에 따른 독립적 분석.  */
proc print data = a;
by country city;
run; /* sort단계 이외의 by문장은 모두 기준변수에 독립적 분석,  출력(3) */
proc print data = a;
by city;
run; /* 최우선 기준변수가 city가 아니므로 오류. city 기준으로 sort 선행 수행 필요 */

data b;
input country $ city $ month number;
cards;
Korea Seoul 1 5024
France Paris 2 1200
Korea Seoul 2 4214
France Paris 3 2354
Korea Busan 3 1347
Korea Seoul 4 6635
Korea Busan 4 987
France Paris 4 3308
Korea Seoul 5 3375
Korea Busan 5 334
France Paris 5 893
run;
proc sort data = b out = sorted_b; /* by변수 기준으로 정렬한 결과를 새로운 데이터셋으로 저장 */
by country descending city; /* country 오름차순, city 내림차순 */
run;
proc print data = sorted_b;
run;

proc anova data = b; /* anova - 분산 분석 */
class city; /* class - 분석에 필요한 분류 변수, model 문장보다 선행되어야 함 */
model number = city; /* 종속변수 = 독립변수 꼴 */
run;
proc print data = b;
id country; /* obs 대신 country 기준 출력 */
var _all_ ; /* id변수가 중복 지정되면 2번 출력 */
run;

proc print data = b label; /* label 출력 시 옵션 지정 필요 */ 
id country;
var city number;
label number = "# of Car Accidents " country = "Country"; /* 빈칸포함 256자, 한글 128자 */
label city = "Big City"; /* label문장 여러개 써도 상관 없음. 한 문장에 몰아써도 상관없음. */
run;
proc print data = b split='*'; /* 띄어쓰기 기준. label 옵션 생략 가능 */
id country;
var city number;
label number='# of * Car * Accidents' country='Country' city='Big City';
run;

proc reg; /*회귀분석*/
model y = x1 x2;
run;
quit;
proc anova data = b; /*분산북석*/
class = city;
model number = city;
run;
quit;
options validvarname = any;
proc means data = b;
var number;
output out = auto mean=average std=표준편차; /* output 문장으로 out 데이터 셋 이름과 sas키워드 이름 지정 */
run;
proc print data = auto;
run; /* _TYPE_은 output 문장의 결과되는 sas 자료의 유형. 자동변수
            _FREQ_는 output 문장에 의해 새로운 변수로 출력된 keyword */

/* plot, anova, glm, reg 등 대화식 절차를 끝낼 땐 Quit 문장 */

proc print data = b;
where city = 'seoul';
run;
proc print data = b;
where month in (1,3,5);
run;
proc print data = b;
where number>3000 & city^='busan';
run;
proc print label;
var jobcode salary;
label salary = 'annual salary';
where jobcode = 'pilot2';
run;
proc means;
var salary;
where lastname = 'smith';
where also month = 1; /* where 문장 2개는 안됨. where also는 가능 */
run;
proc means;
var salary;
where lastname = 'smith' & month = 1; /* 혹은 and로 묶기 */

