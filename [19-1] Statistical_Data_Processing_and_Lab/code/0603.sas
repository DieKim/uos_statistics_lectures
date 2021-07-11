/*%include example*/
data tmp_dat (keep = x y);
	set sasuser.admit;
	rename weight = x height = y;
run;

%include "C:\Users\hgkang\Desktop\sgplot_code.sas";

data one;
	infile "C:\Users\hgkang\Desktop\raw_data.txt";
	input cust_type :4. offer_date :mmddyy8. item :$8. discout :percent3.;
run;

proc contents data = one;
run;

data one;
	set one;
	format offer_date date9.;
run;

proc print data = one;
proc contents data = one;
run;

proc print data = one;
	format offer_date yymmdd10.;
run;

/*proc transpose*/
data original;
	input x y z @@;
cards;
12 19 14
21 15 19
33 27 82
14 32 99
;
run;

proc transpose data = original out = transposed;
run;

data old;
input subject time x @@;
cards;
1 2 12 1 4 15 1 7 19 2 2 17 2 7 14 3 2 21 3 4 15 3 7 18
;
run;

proc sort data = old;
	by subject;
run;

proc transpose data = old out = new prefix = value;
	by subject;
	id time;
run;

data origin;
	input employee_id qtr1 qtr2 qtr3 qtr4 paid_by $50.;
cards;
120265 . . . 25 Cash or Check
120267 15 15 15 15 Payroll Deduction
120269 20 20 20 20 Payroll Deduction
120270 20 10 5 . Cash or Check
120271 20 20 20 20 Payroll Deduction
;
run;

proc transpose data = origin out = trans;
	var _all_;
run;

proc sort data = origin;
	by employee_id;
run;

proc transpose data = origin out = trans2;
	by employee_id;
run;

proc transpose data = origin out = trans3;
	by employee_id;
	var qtr1 - qtr3;
run;

proc transpose data = origin out = rotate2(rename = (col1 = amount)) name = period;
	by employee_id;
run;

proc transpose data = origin out = rotate2(where = (col1 ne .)) name = period;
	by employee_id;
run;

proc print data = rotate2 noobs label;
run;

data orion;
	input customer_id order_month sale_amount @@;
cards;
5 5 478.00 5 6 126.80 5 9 52.50 5 12 33.80 10 3 32.60
10 4 250.80 10 5 79.80 10 6 12.20 10 7 163.29
;
run;

proc transpose data = orion out = annual_orders;
run;

proc sort data = orion;
	by customer_id;
run;

proc transpose data = orion out = annual_orders prefix = month;
	by customer_id;
	id order_month;
run;
