/* delivery time data */
data delivery;
input time cases distance;
cards;
16.68  7  560
11.50  3 220
12.03  3  340
14.88  4  80
13.75  6  150
18.11  7  330
8.00  2  110
17.83  7  210
79.24  30 1460
21.50  5  605
40.33  16  688
21.00  10  215
13.50  4  255
19.75  6  462
24.00  9  448
29.00  10  776
15.35  6  200
19.00  7  132
9.50  3  36
35.10  17  770 
17.90  10  140
52.32  26  810
18.75  9  450 
19.83  8  635
10.75  4  150
;
run;
/* 영향관측값 확인 */
proc reg data = delivery;
model time = cases distance/ influence;
output out = t cookd=CooksD;
run; quit;
/* Cook'sD */
proc print data = t;
var CooksD;
run; 
