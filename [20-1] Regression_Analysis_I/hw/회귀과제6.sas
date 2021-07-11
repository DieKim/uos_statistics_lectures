/* 12-(a) */
DATA water1;
set water;
input index@@;
cards;
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
;
RUN;
QUIT;

PROC REG data = water1;
model USAGE = TEMP PROD DAYS PAYR HOUR INDEX;
RUN;
QUIT;

/* 13-(a) */
PROC REG data = sales;
model y = x1 x2 x3 x4;
RUN;
QUIT;

