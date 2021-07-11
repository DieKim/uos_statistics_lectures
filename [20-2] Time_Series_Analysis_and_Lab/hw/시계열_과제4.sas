/** EXAMPLE 4.1 **/
data food;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt'; input food @@;
  date=intnx('month','1jan80'd,_n_-1); /* food.txt; 월별 자료 */
  format date monyy.; t+1; /* t+1; 인덱스 */
  mon=month(date);
     if mon=1 then i1=1; else i1=0;
     if mon=2 then i2=1; else i2=0;
     if mon=3 then i3=1; else i3=0;
     if mon=4 then i4=1; else i4=0;
     if mon=5 then i5=1; else i5=0;
     if mon=6 then i6=1; else i6=0;
     if mon=7 then i7=1; else i7=0;
     if mon=8 then i8=1; else i8=0;
     if mon=9 then i9=1; else i9=0;
     if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;
     if mon=12 then i12=1; else i12=0; run;
/** food 자료에 선형추세모형 적합하기 **/
proc reg data=food ;
  model food= t/dw; /* dw; DW 통계량 옵션 */
  output out=trendata p=trend ;
  id date; run;
data adtrdata; 
  set trendata; 
  adjtrend=food/trend; run; /* adjtrend; 추세 제거 */
/** food 자료에 자기회귀오차모형 적합하기 **/
proc autoreg data=adtrdata;
  model adjtrend=i1-i12/noint nlag=13 dwprob backstep; 
  output out=seasdata p=seasonal; run;
data all; 
  set seasdata; 
  keep date food trend seasonal irregular fitted;
  irregular=adjtrend/seasonal;
  fitted=trend*seasonal; run;
proc print data=all; 
  var date food trend seasonal irregular fitted; run;
proc arima data=all; 
  identify var= irregular nlag=12; run; 
/** [그림 4-1]; 추세성분 by 추세모형에 의한 분해법 cf 원시계열 **/ 
proc sgplot data=all;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); /* 원시계열 */
  series x=date y=trend/ lineattrs=(pattern=2 color=black); run; /* 추세성분 */
/** [그림 4-2]; 계절성분 by 추세모형에 의한 분해법 **/ 
proc sgplot data=all;
  series x=date y=seasonal; run; /* 계절성분 */ 
/** [그림 4-3]; 불규칙성분 by 추세모형에 의한 분해법  **/ 
proc sgplot data=all;
  series x=date y=irregular; /* 불규칙성분 */
  refline 1.0/ axis=y; run;
/** [그림 4-4]; 예측 by 추세모형에 의한 분해법 **/ 
proc sgplot data=all;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); /* 원시계열 */
  series x=date y=fitted/ lineattrs=(pattern=2  color=black); run; /* 모형적합 */

/** EXAMPLE 4.3 **/
data food;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt'; input food @@;
  date=intnx('month','1jan80'd,_n_-1);
  format date monyy.; t+1;
  mon=month(date); run;
/** expand 절차를 이용하여 가법모형의 구성 성분들을 추정하기 **/
proc expand data=food out=food2; /* 분해 by 이동평균법 */
  convert food=tc/transformout=(cda_tc 12);
  convert food=s/transformout=(cda_s 12);  
  convert food=i/transformout=(cda_i 12);
  convert food=sa/transformout=(cda_sa 12); run;
/** [그림 4-7] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* 원시계열 */
  series x=date y=tc/ lineattrs=(pattern=2 color=blue); /* 추세*순환성분 */ 
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [그림 4-8] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* 원시계열 */
  series x=date y=s/ lineattrs=(pattern=2 color=blue); /* 계절성분 */
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [그림 4-9] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* 원시계열 */
  series x=date y=i/ lineattrs=(pattern=2 color=blue); /* 불규칙성분 */
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [그림 4-10] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* 원시계열 */
  series x=date y=sa/ lineattrs=(pattern=2 color=blue); /* 계절조정 */
  xaxis values=('1jan80'd to '1jan92'd by year); run;

/**  EXAMPLE 4.4  **/
data food;
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\food.txt';
  input food @@;
  date=intnx('month','1jan80'd,_n_-1);
  format date monyy.; t+1;
  mon=month(date); run;
/** X12 절차에서 X11 방법에 의해 여러 가지 성분들을 산출하기 **/
proc X12 data=food seasons=12 start=jan1980;
  var food;
  x11; /* X-12 ARIMA 중 X11에 의한 계절조정 */
  output out=foodout a1 d10 d11 d12 d13;  run;
/** <표 4-7> **/
proc print data=foodout; run;
/** [그림 4-11]~[그림 4-14] 그리기 **/
data foodout; set foodout(rename=(_date_=date food_a1=food food_d10=d10 
  food_d11=d11 food_d12=d12 food_d13=d13 ));
  label food=" "  d10=" "  d11=" "  d12=" "  d13=" " ; run;
/** [그림 4-11] **/ 
title "Final seasonal factors";
proc sgplot data=foodout;
  series x=date y=d10; run;
/** [그림 4-12] **/ 
title "Original time series vs Seasonally adjusted series";
proc sgplot data=foodout;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); 
  series x=date y=d11/ lineattrs=(pattern=2 color=black); run;
/** [그림 4-13] **/ 
title "Original time series vs Trend cycle";
proc sgplot data=foodout;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); 
  series x=date y=d12/ lineattrs=(pattern=2 color=black); run;
/** [그림 4-14] **/ 
title "Irregular component";
proc sgplot data=foodout;
  series x=date y=d13; 
  refline 1.0/ axis=y; run;
proc arima data=foodout; /* 자기상관계수 확인 */
  identify var=d13 nlag=24; run; quit;
