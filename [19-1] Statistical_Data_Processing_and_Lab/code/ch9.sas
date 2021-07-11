/* 제9장 ppt */

/* SQL : 구조적 질의 언어, sas 프로시저뿐만 아니라 data단계 일부 수행도 가능  
    1. 요약 통계량 산출/보고서 작성
    2. 칼럼 추가, 삭제, 수정 
    3. table, view 생성 
    4. 데이터 검색, 조합, 갱신 */

/* 기본 용법 
   proc sql options;
   select - 칼럼 선택/쉼표(,)로 구분/*는 모든 칼럼 선택 
   from - 테이블 선택
   where - 행 선택. 검색 조건
   group by - 지정한 칼럼 값별로 결과.
   order by colmn [desc]; - 순서 정렬
   quit; */

/* 예제 */

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
/* 왜 출력이 안 되지? */
proc sql ;
title2 'CITY AND YEARS OF SERVICE';
select empname, empcity, empyears /* select 문 지정 순서대로 출력 */
from employee 
where emptitle='salesrep'; /*검색 조건*/
quit;

proc sql ;
title2 'CITY AND YEARS OF SERVICE';
title3 'Computed with PROC SQL';
select empcity, sum(empyears) as totyears /* sum(A) as B : A의 합을 B라는 새로운 칼럼으로 만듦 */
from employee
where emptitle='salesrep'
group by empcity; /*empcity 값별로 독립적 분류*/
order by totyears; /*totyears의 오름차순으로 정렬*/
quit;

/* <시험> PROC SQL을 다른 문장들로 표현하기 */

title2 'CITY AND YEARS OF SERVICE';
title3 'Computed with PROC SUMMARY, SORT AND PRINT'; /* proc sql = proc summary, sort and print */
proc summary data=employee; /* sum 프로시져 */
where  emptitle='salesrep'; /* 특정 관측만 */
class empcity; /* empcity를 분류변수로 */
var empyears; /* 변수 emyears를 더하자 */
output out=sumyears sum=totyears; /* 그 결과를 sumyears라 하고 sum은 totyears로 이름 변경 */
run;
proc sort data=sumyears; 
by totyears; /* totyears를 기준으로 오름차순 정렬 */
run;
proc print data=sumyears noobs;
var empcity totyears;
where _type_ = 1 ; /* _type_=0은 전체자료를 의미 */
run;

/* create문 <-create로 생성한다고 출력되지 않음. 
   1. create view name as    ; - view는 가상의 테이블로 실제 테이블과는 달리 자료를 포함하고 있지 않음 
   2. create table name as   ; */

/* view의 생성 */
proc sql ;
title2 'EMPLOYEES WHO RESIDE IN OCEAN CITY';
title3 " ";
create view ocity as 
select empname, empcity, emptitle, empyears /* 이 칼럼들을 골라서 view 생성. 테이블과는 달리 자료 포함 안함. */
from employee
where empcity='Ocean City';
proc print data=ocity; /* create문은 결과 출력 안하므로 proc print로 확인 */
sum empyears; /* 합계 따로 출력 */
run;

/* 칼럼의 선택 
    select a, b label = '내용', c format = 형식, 수식 as new from table;
   칼럼명 대신에 내용을 붙이거나, 칼럼의 형식 지정하거나 새로운 칼럼을 생성할 때 사용 */

data paper;
input author$1-8 section$9-16 title$17-43 @45 time TIME5. @52 duration;
format time TIME5.;  
label title='Paper Title';
cards;
Tom Testing Automated Product Testing 9:00 35
Jerry Testing Involving Users 9:50 30
Nick Testing Plan to test, test to plan 10:30 20
Peter Info SysArtificial intelligence 9:30 45
Paul Info SysQuery Languages 10:30 40
Lewis Info SysQuery Optimisers 15:30 25
Jonas Users Starting a Local User Group 14:30 35
Jim Users Keeping power users happy 15:15 20
Janet Users keeping everyone informed 15:45 30
Marti GraphicsMulti-dimensional graphics 16:30 35
Marge GraphicsMake your own point! 15:10 35
Mike GraphicsMaking do without color 15:50 15
Jane GraphicsPrimary colors, use em! 16:15 15
Jost Foreign Languages Issues 11:15 .
;
run;

title2 'papers to be presented';
proc sql ;
select *
from paper; /* proc print와 동일한 결과 */

title2 'how long will it take?';
proc sql;
select author, title, time, duration, time + duration*60 as endtime /* endtime 초단위. *60해서 초단위로 고쳐줌 */
from paper;

title2 'How long will it take?';
proc sql ;
select author, title, time, duration label='How Long it Takes', /* 라벨 지정 */
time + duration*60 as endtime FORMAT=TIME5. /* 포맷 지정으로 시간 단위로 출력 */
from paper;


title2 'Papers presented in the morning';
proc sql ;
select author, title, time, duration label='How Long it Takes',
time + duration*60 as endtime FORMAT=TIME5.
from paper
where time < '12:00't; /* time은 시간 포맷이므로 '12:00'로 묶고 t를 붙여야 비교 수식 가능 */

/* table 생성 */     

/* create table은 테이블 생성만하고 출력하진 않음.
 1) 라이브러리를 통해 확인하거나 
2) select * from 생성 테이블 이름 ; 를 마지막에 추가하면 출력창에 출력 됨. */

create table p2 like paper; /* paper 테이블의 칼럼이름만 가지고 테이블을 생성하는데 로우(관측)가 포함  안됨. */

create table p3 as select * from paper
where time > '12:00't; /* paper 테이블의 칼럼을 가지고 테이블을 생성하는데 로우(관측)가 포함됨. 또한 출력도 됨 */

create table count(section CHAR(20), paper NUM);  /* 특정 칼럼을 가지는 테이블 생성. 칼럼 이름의 형식도 지정 */

/* 관찰값 추가하기 */

proc sql;
insert into paper(author, title, time) /* 테이블 paper에 3가지 칼럼 추가 */
values(‘jost’, ‘Foreign Language lssues’, ‘11:15’t); /* 추가된 칼럼에 대한 값 추가 */
title2 ‘After inserting jost’;
select * from paper; /* 전체 출력 */

proc sql;
create table counts(section CHAR(20), papers NUM); /* 특정 칼럼을 가지는 테이블 생성 */
insert into counts /* 추가하는 칼럼은 없음 */
select section, COUNT(*) from paper /* COUNT 함수에 의해 카운트한 결과를 취함.*/
group by section; /* section에 대해 그룹화되어 있으므로 section값이 같은 관찰값들의 수를 카운트 */
title2 ‘Papers counted by section’;
select * from counts;

proc sql;
create table counts(section CHAR(20), papers NUM);
insert into counts 
values(‘Graphics’, 4)
values(‘Info Sys’, 3)
values(‘Testing’, 2)
values(‘Users’, 3)
values(‘’, 1); /* 관측 5개 추가 */
title2 ‘Before Deleting FROM Counts’;
select * from counts;

/* 관찰값 삭제하기 */

proc sql;
delete from counts
where section IS null;
title2 ‘After Deleting WHERE section is null’;
select * from counts;

proc sql;
delete from counts
where papers=(SELECT MIN(papers) from counts); /* counts 테이블에서 papers 값이 가장 작은 관찰값 삭제 */
title2 ‘After Deleting section with fewest papers’;
select * from counts;

/* <PROC SQL> 
   1. 기본 문법
   2. 여러 단계 <=> 하나의 SQL
   3. 칼럼의 생성
   4. view의 생성
   5. table의 생성
   6. 관찰값 삽입
   7. 관찰값 삭제 */





