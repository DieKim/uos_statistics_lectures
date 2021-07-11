/* Q2-3 */
data ex2_3;
input Symptom $ Drug $ Count@@; 
cards;
a Y 105 a N 8
b Y 12   b N 2
c Y 18   c N 19
d Y 47   d N 52
e Y 0     e N 13
;
run;

proc freq order = data; 
weight Count;
tables Symptom*Drug/chisq expected nocol norow nopercent;
run;
quit;

data data1;
input symptom $ medicine $ count @@;
cards;
schizophrenia              Y  105  schizophrenia              N 8
aggressive_behaviour  Y  12    aggressive_behaviour N 2
;

proc freq order = data; 
weight count;
tables symptom*medicine/ chisq expected nocol norow nopercent crosslist(stdres);
run;

data data2;
input symptom $ medicine $ count @@;
cards;
nerve_unrest                Y  18    nerve_unrest                N 19
lack_of_personality       Y  47    lack_of_personality      N 52
;

proc freq order = data; 
weight count;
tables symptom*medicine/ chisq expected nocol norow nopercent crosslist(stdres);
run;

data data3;
input symptom $ medicine $ count @@;
cards;
s_a    Y  117     s_a     N 10
n_l     Y  65       n_l      N 71
s        Y  0        s         N 13
;

proc freq order = data; 
weight count;
tables symptom*medicine/ chisq expected nocol norow nopercent crosslist(stdres);
run;

/* Q2-4 */
data ex2_4;
input Education $ Income $ Count @@;
cards;
a   L   9     a    M  11    a   H    9
b   L  44    b    M  52    b   H   41
c   L  13    c    M  23    c   H   12
d   L  10    d    M  22    d   H   27
;

proc freq order = data; 
weight Count;
tables Education*Income/ chisq expected nocol norow nopercent;
run;

proc freq order = data; 
weight Count;
tables  Education*Income/chisq cmh1 trend;
run;
quit;

/* Q3-3*/
data ex3_3;
input Hospital $ Medicine $ Response $ Count @@;
cards;
1 A S 6   1 A F 4
1 B S 2   1 B F 8
2 A S 4   2 A F 3
2 B S 1   2 B F 5
3 A S 5   3 A F 3
3 B S 3   3 B F 6
;
run;

proc freq order = data;
weight count;
tables Hospital*Medicine*Response/cmh;
run;
