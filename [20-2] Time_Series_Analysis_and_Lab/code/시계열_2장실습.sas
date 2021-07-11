/* 2장 추세모형 */

/* 예제1 추세성분을 가지는 모형 적합 */

/* (1) 데이터 불러오기; population.txt */
data pop;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\population.txt';
  input pop@@;
  pop=round(pop/10000); /* 단위 조정 */
  lnpop=log(pop); /* 분산상수화; 로그변환을 통해 이분산성 해소 */
  t+1; t2=t*t; year=1959+t; /* 연도별 자료; 1960~1995 */ 
run; 

/* (2) 시계열도 확인; 선형추세 or 2차추세 */
proc sgplot data=pop;
  series x=year y=pop / markers  markerattrs=(symbol=asterisk);
  xaxis values=(1960 to 1995 by 5); run;

/* (3) 선형추세모형 적합 */
proc reg data=pop; 
  model pop=t / dw; /* 선형추세모형 */
  output out=out1 p=pred1 r=residual1; run;
proc sgplot data=out1; /* 잔차의 시계열도; 2차 추세 감지 */
  series x=year  y=residual1/ markers  markerattrs=(symbol=square);
  xaxis values=(1960 to 1995 by 5); 
  refline  0 / axis=y; run;

/* (4) 2차추세모형 적합 */
proc reg data=pop; 
  model pop=t t2/ dw; /* 2차추세모형 */
  output out=out2 p=pred2 r=residual2; run; 
proc sgplot data=out2;  /* 모형적합 확인; 잘 적합된 듯하다 */
  series x=year y=pop/ markers markerattrs=(symbol=circle); /* 원시계열 */
  scatter x=year y=pred2 / markerattrs=(symbol=plus); /* 적합값 */
  xaxis values=(1960 to 1995 by 5); 
  yaxis label="pop"; run;
proc sgplot data=out2; /* 잔차의 시계열도; 양의 상관관계 + 이분산성 감지 */ 
  series x=year  y=residual2/ lineattrs=(pattern=1 color=black thickness=1) 
         markers  markerattrs=(symbol=star color=black size=5);
  xaxis values=(1960 to 1995 by 5); 				 
  refline  0 / axis=y;  run;

/* (5) 로그변환된 자료에 2차추세모형 적합; for 이분산성 해소 */
proc reg data=pop;
  model lnpop=t t2/ dw;
  output out=out3 r=residual3; run;
proc sgplot data=out3; /* 잔차의 시계열도; 이분산성은 해소되었으나 여전히 상관관계 존재 */
  series x=year y=residual3  / lineattrs=(pattern=1 color=black thickness=1) 
         markers  markerattrs=(symbol=diamondfilled color=black size=5);
  xaxis values=(1960 to 1995 by 5); 
  refline  0 / axis=y; run;

/* 예제2 추세+계절성분을 가지는 모형 적합 */

/* (1) 데이터 불러오기; depart.txt */
data dept;
  infile  'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\depart.txt'; input dept @@;
  lndept=log(dept); t+1;  /* 로그변환; 이분산성 존재 */
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;  if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;  if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;  if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;  if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;  if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0; 
run; 

/* (2) 시계열도 확인; 선형추세+계절+이분산성 */
proc sgplot;
  series x=date y=dept / markers markerattrs=(symbol=dot); run;
proc sgplot; /* 로그변환으로 이분산성 해소 */
  series x=date y=lndept / markers markerattrs=(symbol=dot); run;

/* (3) 로그변환된 자료에 계절형 지시함수를 사용한 모형 적합 */
proc reg; 
  model lndept=t i1-i12/noint dw; /* 절편이 없는 모형; full rank X */
  output out=deptout r=residual; run; 
proc sgplot data=deptout; /* 잔차의 시계열도; 상관관계 존재 */
  series x=date  y=residual / markers  markerattrs=(symbol=circlefilled);
  refline  0 / axis=y; run;
proc arima data=deptout; identify var=residual; run; /* 오차항의 자기상관계수; 꽤 크다 */
proc univariate data=deptout; var residual; run; /* 잔차의 기술통계량 확인 */

/* 예제3 비선형모형 적합 */

/* (1) 데이터불러오기; catv.txt */
data catv;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\catv.txt'; input catv @@;
  t+1; year=1969+t; k=70000000; /* 연도별 자료; 1970~1993 */
  lncatv=log(k/catv -1); /* 로그변환 for 비선형모형의 선형화 */
run;

/* (2) 시계열도 확인; S-curve */
proc sgplot; /* S-curve 모양의 비선형곡선 확인 -> 선형화 by 로그변환 */
  series x=year y=catv  / markers markerattrs=(symbol=asterisk); 
  xaxis values=(1970 to 1995 by 5); run;
proc sgplot; /* 로그변환 후 선형에 가까워짐 */
  series x=year y=lncatv  / markers markerattrs=(symbol=asterisk);
  xaxis values=(1970 to 1995 by 5); 
  yaxis values=(-2 to 3 by 1); run;

/* (3) 선형추세모형 적합; 로그변환에 적합 후 원래대로 돌려놓고 해석 */
proc reg data=catv ;
  model lncatv=year/ dw; /* 로그변환 후 적합 */
  output out=out1 pred=p; run; 
data out1; set out1; /* 로그변환으로 얻은 값을 다시 돌려놓아야 함 */
  p1=k/(exp(p)+1); /* 원래 모형에 맞게 변환 후 해석 */
  residual=catv-p1; run;
proc sgplot; /* 관측값과 예측값의 시계열도 */
  series x=year y=catv  / lineattrs=(pattern=1 color=black) /* 원시계열 */
         markers markerattrs=(symbol=circlefilled color=black)
         legendlabel="catv"; 
  series x=year y=p1  / lineattrs=(pattern=2 color=blue) /* 적합값 */
         markers  markerattrs=(symbol=starfilled color=blue)
         legendlabel="forecast"; 
  xaxis values=(1970 to 1995 by 5); run; 
  proc sgplot data=out1; /* 잔차의 시계열도; 자기상관 존재 */
  series x=year y=residual/ markers markerattrs=(symbol=circlefilled);
  xaxis values=(1970 to 1995 by 5);
  yaxis values=(-4000000 to 3000000 by 1000000);
  refline  0 / axis=y; run;

/* (4) 비선형모형 적합; 로그변환없이 비선형모형자체에 적합 */
proc nlin data=catv method=gauss noitprint;
  parms k=70000000 b0=2 b1=0; /* 초기값 설정 중요 */
  temp=exp(b0+b1*t);
  model catv=k/(1+temp); /* 이미 주어진 비선형 모형 */
  output out=tvout p=pred r=residual; run;  
proc sgplot; /* 관측값과 예측값의 시계열도 */
	series x=year y=catv;
	series x=year y=pred; run;
proc sgplot; /* 잔차의 시계열도; 여전히 상관관계 존재 */
	series x=year y=residual; 
    refline  0 / axis=y; run;

/* 예제4 자기회귀오차모형 적합 */

/* (1) 데이터 불러오기; depart.txt */
data dept;
  infile  'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\depart.txt'; input dept @@;
  lndept=log(dept); t+1;  /* 로그변환; 이분산성 존재 */
  date=intnx('month','1JAN84'D,_n_-1);  format date Monyy.;
     mon=month(date);
     if mon=1  then i1=1;  else i1=0;  if mon=2  then i2=1;  else i2=0;
     if mon=3  then i3=1;  else i3=0;  if mon=4  then i4=1;  else i4=0;
     if mon=5  then i5=1;  else i5=0;  if mon=6  then i6=1;  else i6=0;
     if mon=7  then i7=1;  else i7=0;  if mon=8  then i8=1;  else i8=0;
     if mon=9  then i9=1;  else i9=0;  if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;  if mon=12 then i12=1; else i12=0; 
run; 

/* (2) 자기회귀오차모형 적합; 오차의 자기상관성 해소 */
proc autoreg data=dept; /* backstep으로 시차 결정; 시차 1, 3 */
  model lndept=t i1-i12/ noint backstep nlag=13  dwprob;
  output out=out1 r=residual; run;
proc sgplot data=out1; /* 잔차의 시계열도; 자기상관 해소 */
  series x=date y=residual / markers markerattrs=(symbol=dot);
  refline  0 / axis=y; run;
