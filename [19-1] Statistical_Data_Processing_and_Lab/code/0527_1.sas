/*자동변수 example*/
data;
	input a b;
	file print;
	put _all_;
cards;
10 20
1d 30
30 23
;
run;

proc contents data = sasuser.admit;
proc print data = sasuser.admit;
	var _all_;
/*_numeric_ _char_*/
run;

proc sort data = sasuser.admit out = admit;
	by sex;
run;

data sort_ex;
	set admit;
	by sex;
	if first.sex = 1 or last.sex = 1;
run;

/*missing example*/
data missing_set;
	input name $ sex;
cards;
nolboo 0
sabangee .
. 1
;
run;

data missing_set2;
	infile "C:\Users\hgkang\Desktop\Data set\missing_ex2.txt" missover;
	input a b c;
run;

/*Do loop example*/
data apple;
	infile "E:\통계자료 처리 및 실습\text file\apple.txt";
	do variety = "A", "B", "C", "D", "E";
		input yield @@;
			output;
	end;
run;

data gasoline;
	infile "E:\통계자료 처리 및 실습\text file\gasoline.txt";
	do driver = 1 to 4;
		do car = 1 to 4;
			input gas $ km @@;
			output;
		end;
	end;
run;

data linear;
	infile "E:\통계자료 처리 및 실습\text file\linear.txt";
	input sales sd @@;
	log_sales = log(sales);
run;

data chlorine;
	infile "E:\통계자료 처리 및 실습\text file\chlorine.txt" missover;
	input elapsed chlorpct @;
	output;
	do until(chlorpct = .);
		input chlorpct @;
		if chlorpct = . then delete;
		output;
	end;
run;

/*procedures options example*/
proc print data = sasuser.admit (obs = 10);
	var date weight height;
	format date yymmdd10.;
run;

proc means data = sasuser.admit n mean std;
	var weight height;
run;

proc print data = sasuer.admit;
	var _numeric_;
/*	var _char_;*/
run;

proc anova data = sasuser.admit;
	class actlevel;
	model weight = actlevel;
run;

proc means data = sasuser.admit maxdec = 2;
	class actlevel;
	var weight hegith;
run;

proc print data = sasuser.admit label split = "*";
	id name;
	var weight height;
	label name = "이름" weight = "몸무게 * 자료" height = "키 * 자료";
run;

proc reg data = sasuser.admit;
	model weight = height;
run;
quit;

proc anova data = sasuser.admit;
	class actlevel;
	model height = actlevel;
	means actlevel / hovtest duncan;
run;
quit;

proc means data = sasuser.admit maxdec = 1 n mean std p5 p95;
	var weight;
	output out = stat mean = we_mean std = we_std;
run;

proc means data = sasuer.admit ;
	var weight height;
	output out = stat mean =  std = / autoname;
run;

proc means data = sasuser.admit;
	var weight height;
	where sex = "F";
	where also actlevel = "LOW";
/*where sex = "F" and actlevel = "LOW";*/
run;

