/* 1장 시계열자료 */

/* (1)  불규칙성분으로 구성된 시계열 */
data fig1_1;
  do t=1 to 100;
    z=5000+20*rannor(1234); /* Zt=5000+오차, 오차~N(0, 20) */
    output;
  end; run;
data fig1_1;
  set fig1_1;
  date=intnx('month', '1jan80'd,_n_-1); /* 월별 시간 변수 생성 */
  format date monyy.; run;
proc sgplot; /* 시계열도; 불규칙성분 */
  series x=date y=z;
  refline 5000/ axis=y; run;

  /* (2) 추세성분을 갖는 시계열 */
  data fig1_2;
  do t=1 to 100;
    x=0.5*t; /* 결정모형 */
    z=0.5*t+rannor(1234); /* Zt = 0.5 + t + 오차, 오차~N(0,1) */
    output;
  end; run;
data fig1_2; set fig1_2;
  date=intnx('month', '1jan80'd,_n_-1);
  format date monyy.; run;
proc sgplot; 
  series x=date y=z/ lineattrs=(color=blue); /* 확률모형; 확률오차항 O */
  series x=date y=x/ lineattrs=(color=red); /* 결정모형; 확률오차항 X */
  reg x=date y=z; /* 추세선; 결정모형이랑 같을 듯? */
run;

/* (3) 계절성분을 갖는 시계열 */
data fig1_3;
  do t=1 to 120;
    a=rannor(2483); /* 확률오차 */
    z=10+3*sin((2*3.14*t)/12)+0.8*a; /* 계절성분 by 삼각함수 */
    output;
  end; run;
data fig1_3; set fig1_3;
  date=intnx('month', '1jan85'd,_n_-1);
  format date monyy.; run;
proc sgplot; /* 시계열도; 계절성분 확인 */
  series x=date y=z; run;

/* (4) 추세성분+계절성분을 갖는 시계열 */
data fig1_4; /* depart.txt */
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\depart.txt';
  input z @@;
  logz=log(z); /* 이분산성 -> 로그변환 */
  date=intnx('month', '1jan84'd,_n_-1);
  format date monyy.;
  x=2.701573+0.000409*date; run; 
proc sgplot;
  series x=date y=logz/ lineattrs=(color=blue); /* 로그변환된 시계열 */
  series x=date y=x/ lineattrs=(color=black); /* 예측값(=적합값, 추정값); 선형추세 */
run;

/* (5) 추세성분+계절성분+이분산성을 갖는 시계열 (-> 로그변환) */
data fig1_5; /* koreapass.txt */
  infile 'C:\Users\USER\Desktop\대학\3학년 2학기\시계열분석및실습\강의자료\제5판 시계열분석 data\koreapass.txt';
  input z @@;
  date=intnx('month','1jan81'd,_n_-1);
  format date monyy.; run;
proc sgplot;
  series x=date y=z; run;

/* (6) 추세선이 2개인 시계열 (-> 평활법) */
data fig1_6;
  do t=1 to 120;
    a=rannor(4321);
    if t le 60 then x=0.5*t; /* 추세 1 */
    else x=2*(t-46); /* 추세 2 */
    z=x+a; output;
  end; run;
data fig1_6;
  set fig1_6;
  date=intnx('month','1jan85'd,_n_-1);
  format date monyy.; run;
proc sgplot; /* 시계열도; 추세선 2개 확인 */
  series x=date y=z; 
  refline '1jan90'd/ axis=x; run;
