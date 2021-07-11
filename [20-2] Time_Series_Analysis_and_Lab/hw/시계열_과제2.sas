/** EXAMPLE 2.2 : 지시함수를 이용한 계절모형 적합 **/ 
data dept;
  infile  'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\depart.txt'; input dept @@;
  lndept=log(dept); t+1; 
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;
     if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;
     if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;
     if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;
     if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;
     if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;
     if mon=12 then i12=1; else i12=0; run; 
proc sgplot; /* 그림 2-9 */
  series x=date y=dept / markers markerattrs=(symbol=dot); run;
  proc sgplot; /* 그림 2-10 */
  series x=date y=lndept / markers markerattrs=(symbol=dot); run;
proc reg; /* 절편이 없는 선형계절추세모형 적합 with 12개의 지시함수 */
  model lndept=t i1-i12/noint dw;
  output out=deptout r=residual; run; 
proc sgplot data=deptout; /* 잔차의 시계열도 */
  series x=date  y=residual / markers  markerattrs=(symbol=circlefilled);
  refline  0 / axis=y; run;
proc arima data=deptout; identify var=residual; run; /* 잔차의 자기상관계수 */ 

/** EXAMPLE 2.4 : 자기회귀오차모형 적합 **/
proc autoreg data=dept; /* 자기회귀오차모형 적합 */
  model lndept=t i1-i12/ noint backstep nlag=13  dwprob;
  output out=out1 r=residual; run;
proc sgplot data=out1; /* 잔차의 시계열도 */
  series x=date y=residual / markers markerattrs=(symbol=dot);
  refline  0 / axis=y; run;

 /*  추세모형 예측 */
 /* trendata set에 있는 20개 시계열 자료에 대해 마지막 시점으로부터 12시점 
   미래 예측을 하기 위해 마지막 시점 이후 12개 자료를 결측값으로 처리하였다 */
data trendata;
  input z @@; t+1;
datalines;
  23 25 27 34 38 47 49 39 57 59 63 64 69 78 73 89 83 84 86 92
  . . . . . . . . . .  .  . ; run;
proc reg;
  model z=t/ dw;
  output out=out1 p=zhat r=ehat l95=lci95 u95=uci95; run;
proc print; run;
proc sgplot data=out1;
  band x=t Upper=uci95 Lower=lci95 / legendlabel="95% Confidence limits";
  series x=t y=z / legendlabel="actual";  
  scatter x=t y=zhat / markerattrs=(symbol=dot) legendlabel="forecast"; 
  refline  20/ axis=x ;
  yaxis label="Z"; run;
