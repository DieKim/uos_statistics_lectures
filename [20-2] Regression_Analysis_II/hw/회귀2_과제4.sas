/* Q1 */

/* (1) 데이터 입력 */
data ex1;
	input gender bkpk other washno washyes @@;
	cards;
0 0 0 27 26 0 0 1 5 5 0 1 0 13 8 0 1 1 3 2
1 0 0 4 28 1 0 1 0 5 1 1 0 7 7 1 1 1 4 6
; run; 
data ex1;
	set ex1;
	tot = washno+washyes;
run;

/* (2) 모든 변수로 로지스틱 회귀분석 */
proc logistic data=ex1;
	model washyes/tot = gender bkpk other;
	output out=out1 p=p lower=lower upper=upper;
run; quit;
proc print data=out1; run;

/* (3) Others를 제외하고 로지스틱 회귀분석 */
proc logistic data=ex1;
	model washyes/tot = gender bkpk/lackfit;
	output out=out2 reschi=pearson resdev=deviance p=p;
run; quit;
proc print data=out2; run;

/* Q2 */

/* (1) 데이터 불러오기 */
proc import datafile="C:\Users\USER\Desktop\대학\3학년 2학기\회귀분석2\SAS\lenzing.xlsx"
	dbms=xlsx replace out=ex2; getnames=yes;
run; quit;
data ex2; 
	set ex2;
	p5= Pos5/Samp5;
	p6= Pos6/Samp6; 
run;
proc print data=ex2; run;

/* (2) 시계열도 */
proc sgplot data=ex2;
	series X=Week Y=p5;
run; quit;
proc sgplot data=ex2;
	series X=Week Y=Reduct5;
run; quit;
proc sgplot data=ex2;
	series X=Week Y=Proc5;
run; quit;

proc sgplot data=ex2;
	series X=Week Y=p6;
run; quit;
proc sgplot data=ex2;
	series X=Week Y=Reduct6;
run; quit;
proc sgplot data=ex2;
	series X=Week Y=Proc6;
run; quit;
proc sgplot data=ex2;
	series X=Week Y=Prod;
run; quit;

/* (3) 로지스틱 모형 적합 */
proc logistic data=ex2;
	model Pos5/Samp5 = Reduct5  Prod;
run; quit;
proc logistic data=ex2;
	model Pos5/Samp5 = Reduct5/lackfit aggregate scale=none; 
	output out=out1 reschi=pearson resdev=deviance p=p;
run; quit;
proc print; run;
proc sgplot data=out1;
	series X=week Y=pearson;
	series X=week Y=deviance;
run; quit;

proc logistic data=ex2;
	model Pos6/Samp6 = Reduct6  Proc6 Prod; 
run; quit;
proc logistic data=ex2;
	model Pos6/Samp6 = Reduct6/lackfit aggregate scale=none; 
	output out=out2 reschi=pearson resdev=deviance p=p;
run; quit;
proc print; run;
proc sgplot data=out2;
	series X=week Y=pearson;
	series X=week Y=deviance;
run; quit;
