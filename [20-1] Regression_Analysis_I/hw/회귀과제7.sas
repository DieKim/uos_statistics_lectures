/* 12-(b) */
PROC REG data = water;
model USAGE = TEMP PROD DAYS PAYR HOUR;
r1: test TEMP = DAYS = HOUR = 0;
RUN;
QUIT;

/* 13-(b) */
PROC REG data = sales;
model y = x1 x2 x3 x4;
RUN;
QUIT;

/* 13-(c) */
PROC REG data = sales;
model y = x1 x2 x3 x4;
r1:  test x4 = 0; /* (i) */
r2:  test x3  = x4 = 0; /* (ii) */
r3:  test x2 = x3; /* (iii) */
r4:  test x1 = x2 = x3 = x4; /* (iv) */
RUN;
QUIT; 

/* 13-(d) */
PROC REG data = sales;
model y = x1 x2 x3;
RUN;
QUIT;

/* 13-(e) */
DATA x;
input x1 x2 x3;
cards;
3.0 45 10
;
RUN;

DATA sales_;
set sales x;
RUN;

PROC REG data = sales_;
model y = x1 x2 x3 /cli; 
RUN; 
QUIT;
