/* 9장 : SQL procedure */

/* 1. PROC SQL : sas프로시저와 data step의 일부 기능 수행 가능. 강력한 데이터 처리 및 분석 도구  
       - 요약 통계량 산출/보고서 작성 
       - 데이터 검색, 갱신, 조합
       - 행/칼럼 추가, 삭제, 수정 */

/* 2. PROC SQL 기본 문법
proc sql options;
select 칼럼명
from 테이블명
where 검색 조건
group by 칼럼값별 독립적 분석
order by 순서화 ; 
quit; 
->총 세미콜론 3개

select * : 전체 칼럼 선택
select a,b,c : 콤마(,)로 구분
select A label='내용', B format=형식, 수식 as C from 테이블명 : ex) sum(A) as B from table

where name in ("Kim", "Dahee") : "kim"이나 "Dahee"를 포함한 행만 선택
where name like "KimDahee" : "KimDahee" 인 행만 선택

order by a b [desc] : a는 오름차순, b는 내림차순으로 정렬

group by, order by : sort 단계 선행 필요x. 그냥 by가 아니라 조금 다름. 역할은 비슷

proc sql ~~~;
run; : 없어도 실행가능
quit; : 있는게 좋음 */

/* 기본 예제 */
title1 '*** sqlug1: User guide chapter 1 examples***';
data employee;
input empnum empname $ empyears empcity $ 20-34
emptitle $ 36-45 empboss;
cards;
101 Herb 28 Ocean City president .
201 Betty 8 Ocean City manager 101
213 Joe 2 Virginia Beach salesrep 201
214 Jeff 1 Virginia Beach salesrep 201
215 Wanda 10 Ocean City salesrep 201
216 Fred 6 Ocean City salesrep 201
301 Sally 9 Wilmington manager 101
314 Marvin 5 Wilmington salesrep 301
318 Nick 1 Myrtle Beach salesrep 301
401 Chuck 12 Charleston manager 101
417 Sam 7 Charleston salesrep 401
;
run;
proc print data = employee;
run;
proc sql;
title2 "City and years of service";
select empname, empcity, empyears
from employee /* sas파일만 가능 */
where emptitle = "salesrep" ; /* 검색 조건 */
quit;

/* 여러단계를 하나의 sql로 표헌하기 */
proc sql;
title2 "city and years of service";
title3 "Computed with proc sql";
select empcity, sum(empyears) as totyears /* empyears의 합을  totyears라는 새로운 칼럼으로 */
from employee
where emptitle='salesrep'
group by empcity /* empcity값 별로 분류 */
order by totyears; /* totyears 오름차순 */
quit; 

title2 "city and years of service";
title3 "Computed with proc sql";
proc summary data = employee; /* from table employee */
where emptitle='salesrep'; /* where emptitle = 'salesrep' */
class empcity; /* group by empcity */
var empyears; /* sum("empyears") */
output out=sumyears sum=totyears; /* sum(empyears) as "totyears" */
run; /* 주어진 조건 하에 sum(A) as B를 proc summary 절차를 이용 */
proc sort data = employee;
by totyears; /* order by totyears */
run;
proc print data = sumyears noobs; /* proc sql은 print 절차까지 포함 */
var empcity totyears; /* select empcity, totyears */
where _type_=1; /* _type_변수는 class로 분류변수가 생기면 생기는 자동변수. _type_=0은 전체자료, _type_=1은 분류변수가 1개일때 그 변수 기준 */
run;

/* view의 생성 : view는 가상의 테이블로 실제 테이블과는 달리 자료를 포함하고 있지 않음.
 ->create view _viewname_ as ~~; */

proc sql;
title2 'Employees who reside in ocean city';
title3 " ";
create view ocity as
select empname, empcity, emptitle, empyears
from employee
where empcity='Ocean City';
proc print data = ocity; /* create문은 print안됨. 따로 proc print */
sum empyears; /* empyears의 합계도 출력 */
run;

/* 칼럼 예제 */
data paper;
input author$ section$ title$ time TIME5. duration; /* 입력형식 */
format time TIME5.; /* 출력형식->영구 fix in data step */
label title='Paper Title';
cards;
KIM TEST Plan 9:35 35
LEE TEST Start 8:30 20
PARK TEST Color 15:20 45
;
run;

title1 "  ";
proc sql;
select *
from paper; /* 모든 칼럼 출력 = proc print */

proc sql;
select author, title, time, duration, time + duration*60 as endtime 
from paper;
/* endtime은 출력형식을 부여안해서 디폴트인 초단위로 출력될거임. 분단위로 적혀있으니까 *60을 해서 초단위로 고쳐줌. sas는 시간을 초단위로 인식. */

proc sql;
select author, title, time, duration label='how long it takes', time + duration*60 as endtime format=time5.
from paper;
/* duration대신 라벨 출력. endtime 형식 time5.꼴로 지정. sas는 시간을 초단위로 인식함. 분단위로 인식하려면 *60해줘야함. */

proc sql;
select author, title, time, duration label = 'how long it takes', time + duration*60 format =time5.
from paper
where time < '12:00't; /* time은 시간형태임으로 '시간't 형태로 검색

/* table의 생성 : create문으로 출력 안 됨. 라이브러리 혹은 select * from 으로 확인 */

create table p2 like paper; /* paper의 칼럼 이름만 가지고 table 생성. 로우(관찰값) 없음. */

create table p3 as 
select *
from paper
where time > '12:00't; /* where 조건을 만족하는 로우를 포함한 table 생성 */

create table count(section CHAR(20), paper NUM); quit; /* 특정 칼럼을 가지는 table 생성 */

/* 관찰값 삽입하기 : 추가하는 칼럼명 개수와 values 값의 개수 동일해야함. 테이블에 존재하는 칼럼보다 추가하는 칼럼이 적으면 나머지 결측값. 
   insert into~values;
  create table~insert into~select~from
  create table~insert into~values */ 

proc sql;
insert into paper(author, title, time)
values('jost','Foreign','11:15't);
select * from paper; /* 관찰값 삽입한 paper 결과 output 출력 */

proc sql;
create table counts(section CHAR(20), papers NUM); /* 테이블 생성. 아직은 관찰값 없음 */
insert into counts /* 관찰값 넣을거임 */
select section, COUNT(*) from paper /* paper에서 section칼럼과 COUNT함수에 의해 카운트한 결과를 로우로 가짐 */
group by section; /* section 칼럼 값에 의해 그룹화 되어 있으므로 section 값이 같은 관찰값들의 수를 카운트 함 */
select * from counts; /* 결과 출력 */

proc sql;
create table counts(section CHAR(20), papers NUM);
insert into counts 
values('TESTING',3)
values('',1);
select * from counts; /* 직접 관찰값 집어 넣음 by insert into-values('','',''); */

/* 관찰값 삭제하기 : delete from~where ;*/

proc sql;
delete from counts
where section is null;
select * from counts;

proc sql;
delete from counts
where papers=(select min(papers) from counts); /* where 조건절에 select 문 사용. papers값이 가장 작은 관측 삭제 */
select * from counts;

/* 8장: 매크로 함수 */

/* 매크로 함수는 %로, 매크로 변수는 &로 사용 */

/* 매크로 변수
1. 자동 매크로 변수 : sysdate,sysdata9.sysday,systime,sysscp,sysver
2. 사용자 지정 매크로 변수 : %let으로 생성
-이미 존재하는 변수면 새로운 변수값으로 대체
-문자도 숫자로 저장 
-대소문자 구분해서 저장 
-따옴표도 변수로 저장
-앞뒤 공백은 삭제
-수식 계산안하고 그대로 저장 */

/* 매크로 변수 예제 */

data order_fact;
input customer_id @4 order_date DATE9.
@14 delivery_date DATE9. order_id order_type product_id
total_retail_price DOLLAR7.;
format order_date DATE9. delivery_date DATE9.;
cards;
63 11JAN2003 11JAN2003 1230058123 1 220101300017 $16.50
5 15Jan2003 19JAN2003 1230080101 2 230100500026 $247.50
45 20JAN2003 22JAN2003 1230106883 2 240600100080 $28.30
41 28JAN2003 28JAN2003 1230147441 1 240600100010 $32.00
;
run;
footnote1 "created &systime &sysday, &sysdate9";
footnote2 "on the sysscp system using release &sysver"; /* 문자열 안에서 매크로 변수 사용하려면 겹따옴표 써야함 */
proc print data = order_fact noobs;
run;

options symbolgen; /* 매크로 변수에 저장된 변수값 로그창 출력 */
options symbolgen mprint mlogic; /* mprint는 에러날 때 디버깅 용도. 어디에서 에러가 났는지 로그창에서 확인 가능 */

%put _automatic_; /* 자동매크로변수 정보 로그창 출력 */
%put _user_; /* 사용자지정매크로변수 정보 로그창 출력 */
%put _all_; /* 모든 매크로변수에 대한 정보 로그창 출력 */

/* 매크로 함수 */

/* proc plot(sgplot) */
data one;
do x=-3 to 3 by 0.1;
y=x**2;
output; /* do 때문에 run을 못 만나니까 output문장으로 중간에 출력 필요 */ 
end;
run;
proc plot data = one;
title "plot of y=x**2";
plot y*x;
run;

%macro draw(lower, upper, incr, func);
data one;
do x=&lower to &upper by &incr;
y=&func;
output;
end;
proc plot data = one;
title "plot of y=&func";
plot y*x;
run;
%mend draw;
%draw(lower=-3, upper=3, incr=0.1, func=x**2);
%draw(lower=0, upper=4, incr=0.05, func=exp(-x));

/* proc reg */
data one;
input y x @@;
datalines;
3 9 1 8 3 12
;
run;
data two;
input z x1 x2 @@;
datalines;
16 3 8 12 5 3 20 4 6 17  79
;
run;
proc reg data = one;
model y = x;
run;
quit;
proc reg data = two;
model z= x1 x2;
run;
quit;

%macro reg(dset, dep, indep);
proc reg data = &dset;
model &dep=&indep;
run;
quit;
%mend reg;
%reg(dset=one, dep=y, indep=x);
%reg(dset=two, dep=z, indep=x1 x2);

/* ttest */

data sideways;
input x1-x10 trt $;
cards;
4 6 5 7 5 7 6 4 3 5  trt1
6 5 5 8 7 9 7 8 6 7 trt2
;
run;
data ttest;
set sideways;
x= x1; output;
x= x2; output;
x= x3; output;
x= x4; output;
x= x5; output;
x= x6; output;
x= x7; output;
x= x8; output;
x= x9; output;
x= x10; output;
drop x1-x10;
run;
proc print data =ttest;
run;

%macro tr(num=);
%do j=1 %to &num;
x=x&j; output;
%end;
drop x1-x&num;
%mend tr;
data ttest;
set sideways;
%tr(num=10);
run;

proc ttest data = ttest; /* proc ttest를 위한 데이터셋 만들어서 ttest 실행. 데이터셋 만드는 과정에서 매크로 함수 이용 */
class trt;
var x;
run;

/* proc reg */
data data1;
input y x @@;
cards;
4 8 9 12 5 10
;
run;
data data2;
input z z1 z2 @@;
cards;
12 7 3 15 8 3 17 5 2 16 4 2 
;
run;
%macro reg(dset, dep, indep);
title1 " 회귀분석 ";
title2 " 반응변수 : &dep, 설명변수 : &indep ";
proc reg data = &dset;
model &dep=&indep;
run;
quit;
%mend reg;
%reg (dset=data1, dep=y, indep=x);
%reg (dset=data2, dep=z, indep=z1 z2);

/* proc means */

%macro simple(dset, var, stat);
proc means data = &dset &stat;
var &var;
run;
%mend simple;
%simple (dset=data2, var=z2, stat=MEAN STD N);
%simple (dset=data1, var=y, stat=MAX MIN N);

/* %macro subset */

data one;
input x1 x2 x3 y @@;
cards;
0.3 2 3 79 1.5 3 3 56 0.5 5 2 42 1.0 10 1 72
0.8 4 1 52 0.3 5 3 74 0.5 9 3 30 1.2 4 2 35
1.5 0 2 42 1.0 6 3 51 1.5 3 5 65 0.0 3 5 73
;
run;

%macro subset(var1, crit, ds_in, ds_out, compare);
data &ds_out;
set &ds_in;
if &var &compare &crit then output;
run;
title " <데이터셋명 : &ds_out> ";
proc print data=&ds_out;
run;
%mend subset;

%subset (var1=x1, crit=1, ds_in=one, ds_out=result1, compare=<);
%subset (var1=y, crit=75, ds_in=one, ds_out=result2, compare=>=);


/* 7-2장 */

/* informat 예제 
<$>informat<w>.<d>
1. $8. outdoors -> outdoors
2. 5. 12345 -> 12345
3. comma7. dollar7. $12,345 -> 12345
4. comma7. dollarx7. $12.345($12,345) -> 12345(12.345)
5. percent3. 15% -> 0.15
6. MMDDYY6./8./10 010160 -> 0
7. DDMMYY6.8.10. 31/12//60 -> 365
8. date7. 31DEC59 -> -1
9. date9. 31DEC1959 -> -1 8?

/* informat 예제 

1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%

=> input @1 cust_type4. @6 offer_date MMDDYY8. 
    @15 item $8. @24 discount percent3.;

이때 sas시스템 내에서 날짜를 특정 값으로 저장하고 있음.

1960년 1월 1일 = 0

ex) 2007년 3월 2일 
(2007-1960)*365.25 + 31 + 28 + 22 + 2 = xxxxx.xx
이런식으로 계산값 나오면 소수점 버리고 정수만 취해서 입력. */

data one;
input @1 cust_type 4. @6 offer_date MMDDYY8.
@15 item $8. @24 discount PERCENT3.;
format offer_date YYMMDD10.; /* data 단계에서 format 형식을 취하면 출력형식이 영구적으로 fix 됨 */
cards;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;

proc print data = one;
format offer_date9.; /* proc 단계에서 format 형식을 취하면 해당 프로시저 내에서만 일시적으로 영향 */
run;

/* proc transpose 절차 : 행과 열의 전치. 관측과 변수 바꾸는 절차
proc  transpose data = 
                            out =
                        name =  전치된 변수들의 변수명        
                  pre/suffix =  변수명 앞/뒤에 붙는 접사      ;
by 기준변수. 얘는 전치 안됨. 미리 정렬 필요 ;
var 디폴트는 숫자변수만 전치. 문자변수나 특정 전치 변수 지정할때 ;
id 변수값을 변수명으로 사용하고싶을 때 ;
run; */

data original;
input x y z @@;
cards;
12 19 14
21 15 19
33 27 82
14 32 99
;
run;
proc transpose data = original out=transposed;
run;
title 'original data';
proc print data = original;
run;
title 'transposed data';
proc print data = transposed;
run;

data old;
input subject time x @@;
cards;
1 2 12 1 4 15 1 7 19 2 2 17 2 7 14 3 2 21 3 4 15 3 7 18
;
run;
proc sort data =old;
by subject;
run;
proc transpose data = old out = new prefix = value; /* 변수에 접두사로 붙음. 여기서는 특히 ID 문장에서 지정한 변수값 앞에 붙음 */
by subject; /* by변수 자체는 전치되지 않음 */
id time; /* time 변수가 변수명으로 쓰임 */
run;
proc print data = new;
run;

data origin;
input employee_id qtr1-4 paid_by $20-40;
cards;
120265 . . . 25 Cash or Check
120267 15 15 15 15 Payroll Deduction
120269 20 20 20 20 Payroll Deduction
120270 20 10 5 . Cash or Check
120271 20 20 20 20 Payroll Deduction
run;
proc transpose data = origin out=trans;
run; /* var문장 없으므로 숫자만 전치. 문자변수도 전치시키려면 var문장 추가 */

proc sort data = origin;
by employee_id;
run;
proc transpose data= origin out=trans2;
by employee_id; /* by변수에 의해 sorting 되어 있어야 함 */
run;
proc print data = trans2 noobs;
run;
proc transpose data = origin out=trans3;
by employee_id;
var qtr1-qtr4;
run;
proc print data = trans3;
run;

/* 변수명 바꾸기 : out=data(rename=(col1=new_col)) 옵션 사용
 proc transpose data = origin out = rotate(rename=(col1=amount)) name = period;
 by employee_id;
 run; */

proc freq data = rotate; /* 빈도수 등을 보여주는 프로시저 */
tables period;
run; /* _name_은 변경했지만 디폴트 라벨(name of former variable)은 그대로 */

proc freq data = rotate;
where amount NE .;
tables period;
label period=' ';
run;

data q;
input a b c @@;
label a="customer ID";
label b="order_month" c="sale_amount";
cards;
5 5 478.00 5 6 126.80 5 9 52.50 5 12 33.80 10 3 32.60
10 4 250.80 10 5 79.80 10 6 12.20 10 7 163.29
;
run;
proc transpose data = q out = x;
run;
proc print data = x noobs;
run; /* 전치된 데이터 셋에는 label 옵션이 없어도 label 출력됨 */
proc transpose data=q out=y;
by a;
id b; /* 숫자변수는 "_변수값"이 변수명으로 들어감. */
run;

/* 7-1장 */

/* 주석 문장 */ 
* 주석문장 ;

/* options 문장 
number/nonumber : 페이지 번호
date/nodate : 날짜 출력 
ls : 64~256
pageno=n : 출력페이지 시작 번호
ps=n : 페이지 줄의 최대 개수. 보통 ps=60
errors=n : 디폴트 20
missing='chracter' : 숫자변수 결측값 출력 결정. 디폴트 (.).
center/nocenter : output창 출력될 때 정렬방식. put문장 출력에는 영향 x 
notes/nonotes : 오류메시지 log창 출력 관련 옵션. nonotes하면 작업 소요 시간 단축.
formdlim : 페이지 구분자 지정 옵션 */

proc options; run; /* 현재 시스템 설정사항 로그창 출력 */
options nonumber nodate ls=80 formdlim='-'; /* formdlim은 페이지 구분 옵션. 한글이 아닌 문자 1개 설정 가능 */
options number date ls=132 formdlim='';  /* 디폴트 */

/* run; : run문장을 만나야 비로소 그 전 단계 실행 */

/* title, footnote 문장 : 한번 지정되면 계속 인쇄 됨. */

/* endsas 문장 : 프로그램 실행이 끝남과 동시에 sas 시스템 종료 */

/* filename 문장 : 외부 아스키파일 읽어들이는 대명사 지정. 대명사는 라이브러리 규칙과 동일. 8글자. */

filename child '‘a:\family\children\eldest.txt'; /* 파일명까지 지정 */
data teens;
infile child; /* eldest.txt 파일을 teens로 저장 */
input sex age ;
run;

filename child 'a:\family\children';
data teens;
infile teens(eldest.txt); /* 경로명(파일명) */
input sex age;
run;

data teens;
infile 'a:\family\children\eldest.txt';
input sex age;
run;

filename child 'a:\family\children\eldest.txt';
libname myfolder 'c:\teenage';
data myfolder.teens;
infile child;
input sex age;
run;

/* %include 문장 : 외부 파일 그대로 읽어들일때 사용 */

data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
/* 다음과 같은 외부 sas프로그램 파일 plot.sas가 존재한다고 하자.
 proc plot ;
 plot y*x;
 quit; */

 data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include "E:\전산통계\실습\plot.sas"; /* 삽입 된거임 */

 filename myfolder "E:\전산통계\실습";
data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include myfolder(plot.sas); /* 확장자명 생략하면 .sas로 인식 */

  filename myfolder "E:\전산통계\실습\plot.sas";
  data scatter;
input x y @@;
cards;
 1 2 3 4 5 6 0 1 2 3
 ;
 run;
 %include myfolder;

 /* 잘못된 예제 : 데이터라인 뒤에 바로 삽입하면 문자열로 인식하므로 안 됨.*/
 data scatter ;
 input x y;
 datalines;
 %include "c:\work\data.txt";
 run; /* 오류!*/

 /* 쓰고싶으면 원래 자료에 datalines 문장을 추가해서 저장해서 통째로 삽입 */

 /* 출력전달시스템 ODS : sas 출력형태 지정 
 -listing : output창 텍스트 출력. 디폴트. 고정폭 글꼴
 -printer : 인쇄용 출력 . 변동폭 글꼴 
 -pdf : adobe 포맷. pdf 출력
 -html : 웹페이지 게시용 html 출력
 -rtf : 문서 편집기 삽입용 출력 */

 data ;
 input x $;
 cards;
 sung
 moon
;
run;

ods pdf file = '경로' ;
ods html file = '경로';
proc print;
run; /* 출력하고자하는 절차 */
ods pdf close;
ods html close;

/* by 문장 :1) 자료를 순서화하거나 2)변수 값에 따라 독립적 분석할 때 사용.
           sort 절차 -> 순서화
  그 외 모든 절차 -> 독립적 분석. sort 단계 선행 필수 */

DATA accident;
INPUT country $ city $ month number;
DATALINES;
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
RUN;
PROC PRINT DATA=accident;
RUN; 
PROC SORT DATA=accident; /* sort -> 순서화. country 기준으로 줄 세우고 city 줄세움 */
BY country city;
RUN;
PROC PRINT DATA=accident;
BY country; /* sort 이외의 프로시저. country 값 별로 독립적 출력 */
RUN;
PROC PRINT DATA=accident;
BY country city; /* sort 이외의 프로시저. country, city 값 별로 독립적 출력 */
RUN; 
PROC PRINT DATA=accident;
BY city;
RUN; /* city가 최우선 변수가 아니므로 오류 */

/* class : 분류변수 지정 
    model : 분석모형 지정.
  두 문장이 함께 쓰이면 무조건 class문장부터 써야함 */

/* id 문장 : obs 대신 사용자가 관측 확인용 변수 지정. obs 출력 안됨. */
proc print data= accident;
id country;
var _all_; /* id 변수가 다시 포함됐으므로 2번 출력 */
run;

/* label 문장 : 256자까지 지정 가능. 문장 여러개에 써도 되고 한개에 다 써도 됨. */

proc print label; /* 옵션 지정 */
run;

proc print split='*'; /* label 띄어쓰기 기준 지정 */
label numer="*a*b*c";
run;

/* output out= keyword= ; */

/* quit 문장 : plot, anova, glm, reg, sql 등 대화식 절차 마지막에 사용. */

/* where 문장 : 조건을 만족하는 관측 고르기. 
 2개 이상 쓰고 싶으면 where~; where also~; 혹은 where ~and~; */

/* 데이터 입력 응용사례 */

/* 일원분산분석 : 5종류의 사과나무 수확량  예제 */

data apple;
input variety $ yield;
cards;
A 13
A 19
A 39
?
E 25
E 31
E 30
;
run;
proc print ;
run;
data apple;
input variety $ yield @@;
cards;
A 13 B 27 C 40 D 17 E 36
A 19 B 31 C 44 D 28 E 32
A 39 B 36 C 41 D 41 E 34
A 38 B 29 C 37 D 45 E 29
A 22 B 45 C 36 D 15 E 25
A 25 B 32 C 38 D 13 E 31
A 10 B 44 C 35 D 20 E 30
;
run;
proc print;
run;
data apple;
do variety = 'A','B','C','D','E';
input yield @@;
output; /* do문은 반복되므로 중간에 output문장 필요 */
end;
cards;
13 27 40 17 36
19 31 44 28 32
39 36 41 41 34
38 29 37 45 29
22 45 36 15 25
25 32 38 13 31
10 44 35 20 30
;
run;

/* 라틴정방설계 : 4종류 휘발유에 대한 자동차 연비 비교. 운전기사와 자동차 모델 블록변수 */

data gasoline;
do driver 1 to 4;
 do model 1 to 4;
 input gas $ km @@;
 output;
 end;
end;
cards;
D 15.5 B 33.9 C 13.2 A 29.1
B 16.3 C 26.6 A 19.4 D 22.8
C 10.8 A 31.3 D 17.1 B 30.3
A 14.7 D 34.0 B 19.7 C 21.6
run;

/* 임의화블록설계 : 한 품종의 콩에대한 3가지 살충제 효과 비교. 땅을 블록화해서 토질에 따라 비교 */

data soybean;
do insecide= 1 to 3;
do block= 1 to 4;
input seedings @@;
output;
end;
end;
cards;
56 49 65 60
84 78 94 93
80 72 83 85
run;

/* 회귀분석 : 광고비가 매출액에 미치는 경향 분석. 로그에 대한 함수 */

data linear;
input sales ad;
logsales = log(sales);
cards;
2.5 1.0
2.6 1.6
2.7 2.5
5.0 3.0
5.3 4.0
9.1 4.6
14.8 5.0
17.5 5.7
23.0 6.0
28.0 7.0
run;

/* 회귀분석(반복측정) : 보관일에 따른 염소 잔류량 퍼센티지. 측정회수가 일정치 않음 유의 */

data chlorine;
infile datalines missover; /* 결측지 나와도 입력포인트 다음으로 넘어가지 않음 */
input elapsed chlorpct @;
output;
do until(chlorpct=.) /* 결측치가 나올때까지 반복 */;
input chlorpct @; /* 측정회수가 일정치 않으니까 */
if chlorpct=. then return; /* 결측치가 나오면 다시 처음으로 */
output; /* end만나기 전에 출력 */
end;
datalines;
8 0.49 0.49
12 0.46 0.46 0.45 0.43
16 0.44 0.43 0.43
20 0.42 0.42 0.43
24 0.42 0.40 0.40
28 0.41 0.40
32 0.41 0.40
36 0.41 0.38
40 0.39
run;





 






