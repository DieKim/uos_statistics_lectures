/**  EXAMPLE 3.1 : Simple Exponential Smoothing  **/

/**  data단계; mindex.txt 데이터 불러오기  **/
data mindex;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\mindex.txt'; input  mindex @@;
  date=intnx('month','1jan86'd,_n_-1);
  format date monyy.; run;
/**  weight값과 SSE를 이용한 [그림 3-2] 그리기  **/
data sse; 
  input w sse @@;
datalines;
    0.1   1460.371    0.2   1012.6626   0.3   779.00814   0.4   648.75022
    0.5   570.4980    0.6   521.570      0.7   491.440     0.8   475.1534
    0.81  474.1885    0.82  473.3390    0.83  472.6044    0.84  471.9842
    0.85  471.4781    0.86  471.0859    0.87  470.8079    0.88  470.6749
    0.89  470.5947    0.90  470.661     0.91  470.842     0.92  471.1406   
    0.93  471.5567    0.94  472.0919    0.95  472.7475    0.96  473.525
    0.97  474.4263    0.98  475.4532    0.99  476.6078
  ; run;
/**  [그림 3-2]  **/
proc sgplot data=sse;
  series x=w y=sse;
  xaxis values=(0.7 to 1.0 by 0.05);  
  yaxis values=(470 to 500 by 5); run;
/**  <표 3-1>  **/
proc print; var w sse; run;  

/**  w=0.89를 이용한 단순지수평활법  **/
proc forecast data=mindex
  interval=month method=expo out=out1 outest=est1
  weight=0.89 trend=1 lead=6 outfull outresid; 
  id date; var mindex; run; 
/** <표 3-2>  **/
proc print data=est1; run; 
proc print data=out1; run; 
/**  [그림 3-1]  **/
proc sgplot data=out1;
  series x=date y=mindex / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01may94'd / axis=x;
  yaxis values=(0 to 30 by 5); run; 
/**  [그림 3-4]  **/ 
data out11; set out1;  
  if _type_='RESIDUAL'; error=mindex; run;
proc sgplot data=out11;
  series x=date  y=error;
  refline  0 / axis=y; 
  yaxis values=(-6 to 5 by 1);run;
/**  <표 3-3>  **/ 
proc arima data=out11; identify var=error; run; 
proc univariate data=out11; var error; run; 

/**  w=0.2를 이용한 단순지수평활법  **/
proc forecast data=mindex
  interval=month method=expo out=out2 outest=est2
  weight=0.2 trend=1 lead=6 outfull outresid ; 
  id date; var mindex; run;  
/**  <표 3-2>  **/
proc print data=est1; run; 
proc print data=out2; run;  
/**  [그림 3-3]  **/
proc sgplot data=out2;
  series x=date y=mindex / group=_type_;
  where _type_^= 'RESIDUAL';
  refline '01may94'd / axis=x;
  yaxis values=(0 to 30 by 5); run; 
/**  [그림 3-5]  **/ 
data out22; set out2;  
  if _type_='RESIDUAL'; error=mindex; run;
proc sgplot data=out22;
  series x=date y=error;
  refline  0 / axis=y ; 
  yaxis values=(-9 to 7 by 1); run;
/**  <표 3-3>  **/  
proc arima data=out22; identify var=error; run; 
proc univariate data=out22; var error; run; 
