/* options example*/
options validvarname = any;

proc options;
run;

options nocenter;
proc print data = sasuser.admit;
run;
options center;

options nodate nonumber;
ods rtf file = "C:\Users\hgkang\Desktop\admit.rtf";
proc print data = sasuser.admit;
run;
ods rtf close;
options date number;

data tmp_dat;
	set sashelp.cars;
	new_var = model*1;
run;

options errors = 50;
data tmp_dat;
	set sashelp.cars;
	new_var = model*1;
run;
options errors = 20;

options missing = "*";
data tmp_dat;
	input a b;
	cards;
a 1
b 2
c 3
;
run;

proc print data = tmp_dat;
run;
options missing = "";

/*title, footnote example*/
title1 "Regression of weight on height";
proc reg data = sasuser.admit;
	model weight = height;
run;
quit;

title1 "Regression of height on weight";
proc reg data = sasuser.admit;
	model height = weight;
proc sgplot data = sasuser.admit;
	scatter x = weight y = height;
run;
quit;

title1 "proc print example";
title3 "2019-05-27";
proc print data = sasuser.admit;
run;

title1 "print example";
footnote1 "2019-05-27";
proc print data = sasuser.admit;
run;

title1 "";
footnote1 "";

/*filename example*/
filename ex "E:\통계자료 처리 및 실습\text file\apple.txt";
data apple;
	infile ex;
	do variety = "A", "B", "C", "D", "E";
		input yield @@;
			output;
	end;
run;

filename example "E:\통계자료 처리 및 실습\text file";
data apple;
	infile example(apple.txt);
	do variety = "A", "B", "C", "D", "E";
		input yield @@;
			output;
	end;
run;

/*%include example*/
data tmp_dat (keep = x y);
	set sasuser.admit;
	rename weight = x height = y;
run;

%include "C:\Users\hgkang\Desktop\sgplot_code.sas";
