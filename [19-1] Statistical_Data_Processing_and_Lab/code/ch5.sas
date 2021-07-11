/* 제5장-4 ppt */

data test1;
input a x y @@;
select(a);
when(1) z = x+y;
when(2) z = x-y;
when(3) z = x*y;
when(4) z = x/y;
otherwise z = y/x; /* otherwise 문장 생략시 오류, otherwise만 작성시 a=5,6일 때 결측처리 */
end;
datalines; 
1 2 3 2 3 4 3 4 5 4 5 10 5 10 5 6 3 9 2 10 5
run;
 
data test2;
input a x y @@;
select(a+1);
when(1) do; /* 실행문 2개이상 이므로 do-end */
z = x+y;
zz = z*z;
end;
when(3) z= x*y;
otherwise; /* a+1이 1,3이 아니면 z 결측 */
end;
datalines;
0 1 2 1 2 3 2 3 4 5 4 3
run;

data test3;
input a b x y @@;
select(a);
when(1) do;
select(b);
when(-1) do;
c = x**3;
d = y**3;
end; /* do-end */
when(-2) c = x*x;
when(-3) d = y*y;
otherwise;
end; /* select-end */
end; /* do-end */
when(2) c = x*y;
when(3) d = x/y;
otherwise;
end; /* select-end */
datalines;
1 -1 1 2 1 -2 2 3 2 -1 3 4 3 -2 4 3 1 -3 3 4
run;

data namja;
set saram;
where sex = "male"; /* where - 원하는 관측만 읽기 */
run;

data namja; 
set saram;
if sex = "male"; /* if는 data단계에서만 사용가능. where이 더 효율적 */
run;

data metro; 
set saram;
where city in ('seoul', 'busan');
run;

data division; /* 분모가 0이면 나눗셈 안하는 프로그램 */
input x y @@;
if y=0 then goto noway; /* label 지정 - 변수명 짓는 규칙과 동일(32글자) */
z=x/y;
noway: q = x+y; /* label에는 콜론(:)으로 변수 이름과 구별 */
datalines;
1 2 2 0 2 1
run;

data division;
input x y @@;
if y=0 then goto noway;
z = x/y;
return; /* goto + return = data단계 처음으로 */
noway: q = x+y;
datalines;
1 2 2 0 2 1
run;

data division;
input x y @@;
if y = 0 then link modify;
z = x/y; c = 'ok';
return; /* link와 안만난 return은 data단계 처음으로 이동 */
modify: x = x+1; y = y+1; /* y=0이면 1을 더해서 0에서 탈출 */
return; /* data단계 맨 끝의 return은 생략해도 동일한 결과. link와 만난 return이므로 link문장 직후로 이동 */
datalines;
1 2 2 0 
run;

data division;
input x y @@;
if y=0 then return; /* y=0이면 data단계 처음으로. z값 결측 */
z = x/y;
datalines;
1 2 2 0 2 1
run;
	
/* 제5장-5 ppt */

proc sort data = a;
by descending x y; /* x는 내림차순, y는 올림차순(디폴트) */
run;
proc sort data = b;
by descending x y;
run;
data test;
merge a b; /* merge - 가로로 병합. 관측 기준 vs 단일 set - 세로로 합함. 변수 기준 */
by descending x y; /* 변수 x,y를 기준으로 병합. proc sort 단계 필수 */
run;

data phone; /* 동일 관측 삭제하는 프로그램 */
input name $ area $ number;
datalines;
Sung 02 4169679
Moon 02 7976155
Oh 0341 876322
KETEL 02 3122868
Moon 02 7976155
Sung 02 4169679
run;
proc sort data = phone;
by name; /* 동일 관측 삭제하려면 동일 관측이 이웃해 있어야함 */
run;
data phone;
set phone;
if oldname = name then delete; /* 첫번째 관측에서 oldname은 결측값 */
oldname = name ; /* 예를 들어 첫번째 관측에서 Sung이 oldname으로 저장됨. */
retain oldname; /* oldname 관측 기억. 바로 전 단계만 기억. 실행문이 아닌 선언문으로 위치 상관 없음. */
run;

proc sort nodupkey; /* data단계의 retain과 같은 역할. 동일 관측 제거 */
by name;
run;
proc sort nodup;
by name;
run;
proc sort noduplicates data = phone;
by name;
run;
proc print data = phone;
run;

data xequal0;
input x @@;
if x=0 then count + 1; /* count + 1 = count + (x=0) */
datalines;
0 4 0 9 0 5
run; /* x=0이 아닌 곳에서는 count 값 유지(count 초기값은 0) */

data xequal0;
input x @@;
count = 0;
if x=0 then count = count + 1;
datalines;
0 4 0 9 0 5
run; /*잘못된 코드. 관측 하나하나 생각해보면 count 값이 계속 0으로 변하니까 안됨. */
proc print data = xequal0;
run;

data phone;
input name $ area $ number $;
label area = "Area Code" number = "Phone Number"; /* label은 빈칸포함 최대 256자 */
cards;
Sung (02) 416-9679
Moon (032) 797-6155
run;
proc print; /* label 출력 x */
run;
proc print data = phone label; /* label 출력을 원할 시 옵션 */
run;

data; /* 숫자 변수 number의 관측 중 문자가 들어감. 오류-> 로그창에 자동변수 _error_=1 출력 */
input number code;
cards;
561105 1024511
270911 2025649
27a888 2307543
456983 1098324
run;
data; /* 오류 존재시 실행 중지 */
input number code;
if _error_ = 1 then stop;
cards;
561105 1024511
270911 2025649
27a888 2307543
456983 1098324
run;

data list;
input a b;
file print; /* data단계 출력창 출력, file문장과 put문장은 짝꿍 */
if _N_=1 then put @21 'a' @31 'b' @40 '_N_' / @19 25*'-';
put @20 a @30 b @41 _N_; /* put문장은 출력 형식 지정 */
cards;
100 200
23 345
776 15
run; /* _N_=1일때 if에서 지정한 형식 출력 + put 문장 출력형식 둘다 실행 */
data choose1;
set list;
file print;
if _N_=1 then put @21 'a' @31 'b' @40 'N' / @19 25*'-';
put @20 a @30 b @41 _N_;
if _N_=2 then delete;
run; /* put 문장이 먼저 실행돼서 관측 3개 다 존재 */
proc print data = choose1;
run; /* 2번째 관측 없음 */
data choose2;
set list;
file print;
if _N_=1 then put @21 'a' @31 'b' @40 'N' / @19 25*'-';
if _N_=2 then delete;
put @20 a @30 b @41 _N_;
run; /* 관측 제거부터 실행돼서 _N_=2 없음._N_ = 1, 3 만 존재 */
proc print data = choose2;
run; /* 2번째 관측 없음 */ 
/* 즉, file print의 출력과 proc print의 출력 차이가 있음. (put문장 기준으로 생각) */
/* 자동변수 _ERROR_과 _N_는 data 단계에만 존재. proc 단계에서 출력 안 됨 */

proc print data = one;
var _all_; /* data = one의 모든 변수 출력. 자동변수 제외 */
run;
data;
input a b;
file print;
put _all_; /* data단계에서 _all_은 무조건 put 문장과 함께 사용, 자동변수 출력 */
cards;
100 200
12d 300
300 234
run;

/* 분실값 입력 방법 
1. 자유/목록 -> 마침표(.)
2. 열,포맷 -> 빈칸 또는 마침표(.)
    분실값 출력 방법
1. 숫자 -> 마침표(.)   ---> options missing=' '를 통해 빈칸으로 출력 가능 
2. 문자 -> 빈칸  */

data a;
input name $ sex;
cards;
Nolboo 0
sabangee .
. 1
run;
proc print data = a;
run;
data b;
input name $ sex;
infile datalines missover; /* 분실값 처리 */
cards;
Nolboo 0
sabangee .
. 1
run;
proc print data = b;
run;
data;
input name $ 1-8 sex 10;
datalines;
Nolboo   0
sabangee .
         1 
run;
proc print;
run;

/* data단계 결측 제거 
if string = " " then delete
if num = . then delete */
/* 특정 숫자 결측 처리 
if response = 9 then response = .
if response = 99 then response = */
/* 특정 문자열 또는 특정 범위를 벗어나는 변수 결측 처리
if string = " I am null " then string = ""
if num > 100 then num =. */

/* 일원분산분석 : 한 과수원에서 5가지 사과 품종(A,B,C,D,E) 비교.. 
    각 품종별로 7그루의 12년생 사과나무에 대한 수확량을 산출. */
data apple;
input variety $ yield @@;
datalines;
A 13 B 27 C 40 D 17 E 36
A 19 B 31 C 44 D 28 E 32
A 39 B 36 C 41 D 41 E 34
A 38 B 29 C 37 D 45 E 29
A 22 B 45 C 36 D 15 E 25
A 25 B 32 C 38 D 13 E 31
A 10 B 44 C 35 D 20 E 30
run;
data apple;
do variety = "A", "B","C","D","E"; /* A->B->C->D->E->A->B->C... 반복 */
input yield @@; 
output; /* input 다음에 output 출력 */
end;
cards;
13 27 40 17 36
19 31 44 28 32
39 36 41 41 34
38 29 37 45 29
22 45 36 15 25
25 32 38 13 31
10 44 35 20 30
run;
proc print data = apple;
run;

/* 라틴정방설계 : 정유회사에서 4종류의 휘발유 A,B,C,D 에 대한 자동차 연비를 비교하려 함.
    연비는 운전기사와 자동차 모델에 따라 차이가 날 수 있으므로 운전기사와 자동차 모델을 블록변수로 잡고
    라틴정방실험을 설계함. */

data gasoline;
do driver=1 to 4; /* 운전기사 1에 대해서 자동차 모델 1,2,3,4 또 운전기사 2에 대해서 자동차 모델 1,2,3,4 반복 */
do car=1 to 4;
input gas $ km @@;
output; /* input 다음에 output 출력 */ 
end;
end;
cards;
D 15.5 B 33.9 C 13.2 A 29.1
B 16.3 C 26.6 A 19.4 D 22.8
C 10.8 A 31.3 D 17.1 B 30.3
A 14.7 D 34.0 B 19.7 C 21.6
run;
proc print data = gasoline;
run;

/* 임의화블록설계 : 한 품종의 콩에 대한 3가지 살충제의 효과 비교 분석. 토질에 따른 차이가 있을 수 있으므로
서로 다른 토질 4종류의 땅을 선택하고 각각을 3등분하여 100알씩 콩을 심고 살충제를 뿌린 뒤 싹이 나온 콩의 개수를 조사 */

data soybean;
do insecide=1 to 3;
do block=1 to 4; /* 서로 다른 4종류의 토질이 블록 변수 */
input seedings @@;
output; /* input 다음 output */
end;
end;
datalines;
56 49 65 60
84 78 94 93
80 72 83 85
run;

/* 회귀분석 : 광고비가 매출액에 끼치는 경향 분석을 위해 로그를 위한 매출액을 광고비의 함수로 놓고 회귀분석 */

data linear;
input sales ad;
logsales=LOG(sales);
datalines;
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

/* 회귀분석-반복측정 : 보관 기일에 따른 염소의 잔류랑 퍼센티지 측정. 경과 시간에 따른 염소의 감소추세 설명
    이때 자료에서 경과 시간에 대한 잔류 염소량의 측정 회수가 일정치 않음에 유의 */

data cholorine;
infile datalines missover; /* 측정횟수가 다르니까 */
input elapsed chlorpct @;
output;
do until(cholrpct=.);
input chlorpct @;
if chlorpct=. then return;
output;
end;
cards;
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
 




