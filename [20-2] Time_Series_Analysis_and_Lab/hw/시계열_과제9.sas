/* 예8-6 */

/* 데이터 불러오기 */
data gas;
   infile "C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\gas.txt";
   input gas co2 @@; time+1; run;

/* 자료의 시계열도 */
proc sgplot data=gas;
   series x=time y=gas ; xaxis label="time"; yaxis label="gas"; run;

/* 모형식별, 모수추정, 잔차분석 */
proc arima;
   identify var=gas nlag=24; run;
   estimate p=3 method=cls plot; run;
   estimate p=3 method=ml noint plot; run;
   forecast lead=0 out=res; run; quit;

/* 잔차의 시계열도 */
data res; set res; time=_n_; run; 
proc sgplot;
   series x=time y=residual ; xaxis label="time"; 
   yaxis label="residual"; refline 0 / axis=y; run;

/* 잔차의 상관분석 */
proc arima; identify var=residual nlag=24; run; quit;

/* 과대적합 */
proc arima data=gas;
   identify var=gas nlag=24 noprint; run;
   estimate p=4; run; /* AR(4) */
   estimate p=3 q=1; run;  /* ARMA(3,1) */
   estimate p=3 q=1 noint plot; run; /* 모평균 제외 */
run; quit; 
