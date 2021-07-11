/* Q1 */

/* DATA 입력 */
data ex1;
input x1 x2 y @@;
cards;
120.0 600 0.900 60.0 600 0.949 60.0 612 0.886 120.0 612 0.785 120.0 612 0.791
60.0 612 0.890 60.0 620 0.787 30.0 620 0.877 15.0 620 0.938 60.0 620 0.782
45.1 620 0.827 90.0 620 0.696 150.0 620 0.582 60.0 620 0.795 60.0 620 0.800
60.0 620 0.790 30.0 620 0.883 90.0 620 0.712 150.0 620 0.576 60.0 620 0.802
60.0 620 0.802 60.0 620 0.804 60.0 620 0.794 60.0 620 0.804 60.0 620 0.799
30.0 631 0.764 45.1 631 0.688 40.0 631 0.717 30.0 631 0.802 45.0 631 0.695
15.0 639 0.808 30.0 639 0.655 90.0 639 0.309 25.0 639 0.689 60.1 639 0.437
60.0 639 0.425 30.0 639 0.638 30.0 639 0.659
; run;
/*  비선형모형적합 */
proc nlin data=ex1 method=newton plots=(fit diagnostics);
	model y=exp(-theta1*x1*exp(-theta2*(1/x2-1/620)));
	parms theta1=0.01155 theta2=5000;
	output out = ex1_out p = pred r = resid;
run; quit;
/* 잔차그림 */
proc sgplot data = ex1_out;
scatter x=pred y=resid;
run; quit;

/* Q2 */

/* DATA 입력 */
data ex2;
input x1 x2 y @@;
cards;
1.0 1.0 0.126 2.0 1.0 0.219 1.0 2.0 0.076 
2.0 2.0 0.126 0.1 0.0 0.186 3.0 0.0 0.606
0.2 0.0 0.268 3.0 0.0 0.614 0.3 0.0 0.318
3.0 0.8 0.298 3.0 0.0 0.509 0.2 0.0 0.247 3.0 0.8 0.319
; run;
/* 비선형모형 적합 */ 
proc nlin data=ex2 method=newton plots=(fit diagnostics);
	model y=theta1*theta3*x1/(1+theta1*x1+theta2*x2);
	parms theta1=2.9 theta2 = 12.2 theta3=0.69;
    output out=ex2_out p=pred r =resid; 
run; quit;
/* 잔차그림 */
proc sgplot data = ex2_out;
scatter x=pred y=resid;
run; quit;
 

