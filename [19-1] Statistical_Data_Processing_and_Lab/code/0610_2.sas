data employee;
	infile "C:\Users\hgkang\Desktop\sql_set1.txt";
	input empnum empname $ empyears empcity &$15. emptitle $ empboss;
run;

proc sql;
	select empname, empcity, empyears
		from employee
		where emptitle = "salesrep";
quit;

proc sql;
	select empcity, sum(empyears) as totyears
		from employee
		group by empcity
		order by totyears;
quit;
