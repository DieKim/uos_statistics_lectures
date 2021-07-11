options validvarname = any;
libname dataset "D:\통계자료 처리 및 실습\Data set";

/* select example*/
data select_ex1;
	set sasuser.admit;
	select;
		when (age<= 30) class_age = "30대 미만";
		when (age> 30 and age<= 40) class_age = "30대";
		otherwise class_age = "30대 초과";
	end;
run;

data select_ex2;
	set sasuser.admit;
	select (sex);
		when ('M') hw = height + weight;
		when ('F') hw = height - weight;
	end;
run;

data select_ex3;
	input a x y @@;
	select (a + 1);
		when (1) do;
			z = x + y;
			zz = z*z;
			end;
		when (3) z = x*y;
		otherwise;
	end;
datalines;
0 1 2 1 2 3 2 3 4 5 4 3
;
run;

/*Where example*/
data namja;
	set sasuser.admit;
	where sex = "M";
run;

data sub_admit;
	set sasuser.admit;
/*	where actlevel in ("HIGH", "LOW");*/
	where actlevel = "HIGH" or actlevel = "LOW";
run;

/*data dataset.name_set;*/
/*	infile cards dsd;*/
/*	input name $ @@;*/
/*	cards;*/
/*diana, diane, dianna, dianthus, dyan*/
/*;*/
/*run;*/

data sub_name_set;
	set dataset.name_set;
/*	where name like "d_an";*/
	where name like "d_an%";
run;

proc print data = sub_name_set;
run;

/* goto, link, return example*/
data division;
input x y @@;
	if y = 0 then goto noway;
		z=x/y;
		return;
	noway: 
		q=x+y; 
cards;
1 2 2 0 2 1
;
run;

data division;
input x y @@;
	if y = 0 then do;
		z=x/y;
		q=x+y; 
	end;
	else do;
		q=x+y; 
	end;
cards;
1 2 2 0 2 1
;
run;

data division;
Input x y @@;
	if y = 0 then link modify;
		z = x/y; 
		c = "ok";
	return;
	modify: 
		x = x + 1; 
		y = y + 1;
	return; 
cards;
1 2 2 0
;
run;

data division;
input x y @@;
if y = 0 then return;
	z = x/y;
cards;
1 2 2 0 2 1
;
run;

proc print data = division;
run;

/* retain example */
/*data dataset.phone;*/
/*	input name $ area $ number;*/
/*cards;*/
/*Sung 02 4169679*/
/*Moon 02 7976155*/
/*Oh 0341 876322*/
/*KETEL 02 3122868*/
/*Moon 02 7976156*/
/*Sung 02 4169679*/
/*;*/
/*run;*/

proc sort data = dataset.phone out = phone;
	by name;
run;

data phone;
	set phone;
	by name;
	retain oldname;
	if oldname = name then delete;
		oldname = name;
run;

proc print data = phone;
run;

/* proc sort option */
proc sort data = dataset.phone out = nodup_phone nodup;
	by name;
run;

proc print data = nodup_phone;
run;

proc sort data = dataset.phone out = nodupkey_phone nodupkey;
	by name;
run;

proc print data = nodupkey_phone;
run;

/* 누적합 계산 */
data x_count0;
	retain count 0;
	input x @@;
	if x = 0 then 
		count = count + 1;
cards;
0 4 0 9 0 5
;
run;

proc print data = x_count0;
run;

data age_count;
	set sasuser.admit;
/*	if age < 40 then count+1;*/
	count + (age < 40);
run;

proc print data = age_count;
run;

/* label example */
data phone;
	set dataset.phone;
	label name = "이름" area = "Area Code" number = "폰넘버";
run;

proc print data = phone;
proc contents data = phone;
run;

/* automatic variable example */
data auto_one;
	input number code;
/*	if _error_ then stop;*/
	if _error_ then abort;
	cards;
270 202
27a 230
456 109
;
run;

data auto_two;
	set sasuser.admit;
/*	obs_num = _n_;*/
	if _n_ >= 10 then delete;
run;

proc print data = auto_two;
run;

data one_set;
	var1 = 0.985;
	var2 = 0.587;
run;

data auto_three;
	if _n_ = 1 then set one_set;
/*	set one_set;*/
	set sasuser.admit;
/*	set one_set sasuser.admit;*/
run;
