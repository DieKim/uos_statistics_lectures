/* 제7장-1 ppt */

proc options; /* 현재 시스템 옵션 로그창 출력 */
run;
options nonumber nodate ls=80 formdlim='-'; /* 날짜X, 줄 크기 80, '-'를 기준으로 페이지 구분 */

data first;
set old;
proc print; /* data단계는 수행이 되지만 출력은 안됨. run이 없으면 다음 단계를 만나야만 그 전단계 실행 */

title1'Project ? Core Institute of Statistics'; /* titlen -> n은 1~ 10까지 */
title3 'June 14, 2019'; /* LS 디폴트 최대 132자 */

title1'Project ? Core Institute of Statistics'; /* titlen -> n은 1~ 10까지 */
title3 'June 14, 2019'; /* LS 디폴트 최대 132자 */
title2 ; /* title3 지정 해제 */
/* footnoten = titlen */

/* filename : 외부 아스키 파일 불러들일 대명사 지정 */
/* FILENAME fileref(library 규칙, 8글자) '경로' ; */

filename child 'a:\family\children\eldest.txt'; /* 파일명까지 지정 */
data teens;
infile child;
input sex age;
run; /* child를 불러와 teens라는 데이터이름으로 저장 */

filename child 'a:\family\children';
data teens;
infile child(eldest.txt); /* 경로명(파일명.확장자명) */
input sex age;
run;

filename child 'a:\family\children\eldest.txt';
libname myfolder 'c:\teenage';
data myfolder.teens;
infile child;
input sex age;
run;

/* %include 문장 : 외부 파일을 그대로 불러와 sas 프로그램에 삽입 */
/* %include '경로' ' */

data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run; /* 여기에 외부 파일 삽입을 해보자 */

/* 1. 그냥 복사해서 넣기 */
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
PROC PLOT;
PLOT y*x;
QUIT;

/*2. %include 문장 사용 */
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include 'E:\전산통계\실습\plot.sas'; /* 확장자 명까지 기재 */

filename myfolder 'E:\전산통계\실습';
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include myfolder(plot.sas); /* .확장자명 생략시 .sas로 인식 */

filename myfolder 'E:\전산통계\실습\plot.sas';
data scatter;
input x y @@;
cards;
-2 -8 -1 -1 0 0 1 1 2 8
run;
%include myfolder;

/* 잘못 사용된 예제 */

data scatter;
input x y;
cards;
%include “c:\work\data.txt”;
run;
/* datalines 다음의 문자열은 무조건 자료로 간주하므로 잘못된 표현 */
/* %include 문장을 사용하고 싶으면 삽입할 자료에 datalines 문장을 넣고 불러와야함 */

data;
input x $;
datalines;
sung
moon
run;

/* ODS : 출력전달시스템. sas출력 형태 지정 */ 
ods pdf file = 'c:\전산통계\test.pdf'; /* pdf 저장경로 지정 */
ods html file = 'c:\전산통계\test.htm'; /* html 저장경로 지정 */
proc print; /* 출력하고 싶은 절차 */
run;
ods pdf close; /* 닫기 */
ods html close; /* 닫기 */

/* 제7장-2 ppt */

/* informat : 자료 입력 형식 */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
run;

/* 제7장-2 ppt */

/* informat : 자료 입력 형식 */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
format offer_date YYMMDD10.; /* data 단계에서 format 지정하면 영구적 fix */
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
run;

/* 제7장-2 ppt */

/* informat : 자료 입력 형식 */

data one;
input @1 coust_type 4. @6 offer_date MMDDYY8. @15 item $8. @24 discount percent3.;
datalines;
1040 12/02/07 Outdoors 15%
2020 10/07/07 Golf 7%
1030 09/22/07 Shoes 10%
1030 09/22/07 Clothes 10%
run;
proc print data = one;
format offer_date YYMMDD10.; /* proc 단계에서 사용하면 그 단계에서만 적용 */
run;

/* 데이터 구조 변경 : transpose */
/* proc transpose data = a
                              out = b
                             name = c
                           suf/prefix = d ;
     by ; 
     var ; <- 디폴트 숫자변수 
     id ;
     run;   */ 

data original;
input x y z @@;
cards; 
12 19 14
21 15 19
33 27 82
14 32 99
run;
proc transpose data = original out = transposed;
run;
title 'Original DATA';
proc print data = original;
run;
title 'Transposed Data';
proc print data = transposed;
run;

data old;
input subject time x @@;
cards;
1 2 12 1 4 15 1 7 19 2 2 17 2 7 14 3 2 21 3 4 15 3 7 18
run;
proc sort data = old;
by subject;
run;
proc transpose data = old out = new prefix = value; /* 새로운 변수명 접두사로 value 사용 */
by subject; /* subject 기준으로 전치. 기준 변수는 전치 안됨 */
id time; /* 새로운 변수명에 time변수 값이 들어감 */
run;
proc print data = old;
run;
proc print data = new;
run;

data origin;
input employee_id qtr1 qtr2 qtr3 qtr4 paid_by $ 20-40;
cards;
120265 . . . 25 Cash or Check
120267 15 15 15 15 Payroll Deduction
120269 20 20 20 20 Payroll Deduction
120270 20 10 5 . Cash or Check
120271 20 20 20 20 Payroll Deduction
run;
proc transpose data = origin out = trans; /* 문자변수는 전치 안됨 */
run;
proc print data = trans noobs;
run;
proc transpose data = origin out = trans2;
var _all_;
run;
proc print data = trans2 noobs;
run;

proc sort data = origin;
by employee_id; /* by 사용하려면 sort 단계 선행 필수 */
run;
proc transpose data = origin out = trans3;
by employee_id; /* by변수를 기준으로 전치됨. by변수는 전치 안됨 */
run;
proc print data = trans3;
run;

proc transpose data = origin out= trans4;
by employee_id;
var qtr1-qtr4; /* var문장에서 지정한 변수만 전치 */
run;
proc print data = trans4 noobs;
run;

proc transpose data = origin out = rotate2(rename=(col1=amount)) name = period; /* rename : 변수명 변경 옵션, name : 구 변수명 이름 */
by employee_id;
run;
proc print data = rotate2;
run;

proc freq data = rotate2; /* freq : 빈도수 등을 나타내는 프로시져 */
tables period; /* period 변수를 가지고 분석 */ 
run; /* _name_을 name 옵션으로 변경했지만 디폴트 label(Name of former variable)은 그대로 */

proc freq data = rotate2;
where amount ^= . ; /* amount가 결측이 아닌 것 중에서 freq */
tables period;
label period =''; /* _name_의 디폴트 라벨 제거 */
run;

data orion;
input customer_id order_month sale_amount @@;
label customer_id = "Coustomer ID";
cards;
5 5 478.00 5 6 126.80 5 9 52.50 5 12 33.80 10 3 32.60
10 4 250.80 10 5 79.80 10 6 12.20 10 7 163.29
run;
proc transpose data = orion out = annual_orders;
run;
proc print data = annual_orders noobs;
run;

proc sort data = orion;
by customer_id;
run;
proc transpose data = orion out = out;
by customer_id;
id order_month; /* 변수값을 새로운 변수명으로 사용 */
run;
proc print data = out;
run;










