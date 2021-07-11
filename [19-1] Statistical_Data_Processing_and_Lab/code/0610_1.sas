%put &sysdate &sysdate9;
%put &sysday &systime;
%put &sysscp &sysver;

data order_fact;
	infile "C:\Users\hgkang\Desktop\macro_set1.txt";
	input customer_id order_date :date9. delivery_date :date9. order_id order_type product_id total_retail_price :dollar7.;
run;

footnote1 "Created &systime &sysday &sysdate9";
footnote2 "on the &sysscp System Using Release &sysver";
proc print data = order_fact noobs;
run;
footnote1 " ";

options symbolgen;

%let year = 2006;
%let city = Dallas, TX;
%let fname =    Marie   ;
%let name = '   marie Budson   ';
%let total = 10+2;

%put &year &city &fname &name &total;

%put _automatic_;
%put _user_;
%put _all_;

%macro draw(lower, upper, incr, func);
data one;
	do x = &lower to &upper by &incr;
		y = &func;
		output;
	end;
run;


proc sgplot data = one;
	title "Plot of Y = &func";
	scatter x = x y = y;
run;
quit;
%mend draw;

%draw(lower = -3, upper = 3, incr = 0.1, func = x**2);
%draw(lower = 0, upper = 4, incr = 0.05, func = exp(-x));

data one;
	input y x @@;
	cards;
3 9 1 8 3 12
;
run;

data two;
	input z x1 x2 @@;
	cards;
16 3 8 12 5 3 20 4 6 17 7 9
;
run;

options symbolgen mprint mlogic;
%macro reg(dep, indep, dataset);
	title1 "회귀분석";
	title2 "반응변수: &dep, 설명변수: &indep";
	proc reg data = &dataset;
		model &dep = &indep;
	run;
	quit;
%mend reg;

%reg(dep = y, indep = x, dataset = one);
%reg(dep = z, indep = x1 x2, dataset = two);

data sideways;
	input x1-x10 trt $;
	cards;
4 6 5 7 5 7 6 4 3 5 trt1
6 5 5 8 7 6 7 8 6 7 trt2
;
run;

proc transpose data = sideways out = test(drop = _name_);
	var _numeric_;
	by trt;
run;

%macro tr(num);
	%do j = 1 %to &num;
		x = x&j;
		output;
	%end;
	drop x1-x&num;
%mend tr;

data ttest;
	set sideways;
	%tr(num = 10);
run;

proc ttest data = ttest;
	class trt;
	var x;
run;

%macro simple(dset, var, stat);
	proc means data = &dset &stat;
		title1 "Proc Means with statistics : &stat";
		title2 "Response Variable = &var";
		var &var;
	run;
%mend simple;

%simple(sasuser.admit, weight height, mean std);
%simple(sashelp.cars, invoice Horsepower, max min n);

%macro subset(var1, crit, ds_in, ds_out, compare);
	data &ds_out;
		set &ds_in;
		if &var1 &compare &crit then output;
	run;

	title "<데이터셋명 : &ds_out>";
	proc print data = &ds_out;
	run;
%mend subset;

data one;
	infile "C:\Users\hgkang\Desktop\macro_set2.txt";
	input x1 x2 x3 y @@;
run;

%subset(x1, 1, one, result1, <);
%subset(y, 75, one, result2, >=);
