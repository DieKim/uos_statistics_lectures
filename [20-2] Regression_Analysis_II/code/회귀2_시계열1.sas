/* 예제1 1차 자기상관오차를 갖는 모형 - AR(1) */

/* (1) 데이터 입력 */
data ex1;
	ul=0; /* 1. ul; 오차항(t-1) */
	phi=0.6; /* 2. phi= -1.5, -1, -0.6, -0.3, 0, 0.3, 0.6, 1, 1.5 */
	do time=10 to 50; /* 3. time */
		u = phi*ul + 2*rannor(12345); /* 4. u; 오차항(t) */
		y0 = 10+0.5*time; /* 5. y0; 결정모형(오차항x) */
		y=y0+u; /* 6. y; 확률모형(오차항o) */
		if time>0 then output;
			ul=u; 
	end;
run;
proc print; run;

/* (2) 1차자기상관을 갖는 모형 확인 */
/* y*time=1; 확률요소(오차항)를 넣으면 상관관계 발생 확인 가능 */
/* y0*time=2; 확률요소(오차항)이 없으면 상관관계 없는 직선의 그래프 */
proc gplot data=ex1;
	plot y * time=1 y0*time=2/ haxis=axis1 vaxis=axis2 overlay legend=legend;
	axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
	axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
	symbol1 c=blue v=dot h=1 i=join ;
	symbol2 c=red v=star h=1 i=join;
	title h=4 "First-order Autoregressive model : phi=0.6";
run ; quit;

/* 예제2 2차 자기상관오차를 갖는 모형 - AR(2) */ 

/* (1) 2차자기상관이 존재하는 데이터 생성 */
data ex2;
	ul = 0; ull = 0; 
	do time = -10 to 36;
		u = + 1.3 * ul - .5 * ull + 2*rannor(12346);
		y = 10 + .5 * time + u;
		if time > 0 then output;
			ull = ul; ul = u;
	end;
run;
proc print; run;

/* (2) 그래프로 자기상관관계가 있음을 확인 */
proc sgplot data=ex2 noautolegend;
series x=time y=y /markers ;/* 산점도 */
reg x=time y=y/ lineattrs=(color=black); /* 추세선 */
title ’Autocorrelated Time Series’;
run; quit;

/* (3) 일반최소제곱법(OLSE)을 이용해 추정 */
proc autoreg data=ex2;
model y=time; /* 오차의 자기상관 무시 */
run; quit;

/* (4) 자기상관오차 모형(AR)으로 적합 */
proc autoreg data=ex2;
model y=time / nlag=2 method=ml; /* AR(2), 회귀계수 추정 by ML */
output out=ex2_out1 p=yhat pm=trendhat;
run ;quit;
proc sgplot data=ex2_out1;
scatter x=time y=y / markerattrs=(color=blue); /* 실제 데이터 산점도 */
series x=time y=yhat / lineattrs=(color=blue); /* 추정된 회귀직선 */
series x=time y=trendhat / lineattrs=(color=black); /* 오차항 무시했을 때 추세선인 듯? */
title ’Predictions for Autocorrelation Model’;
run; quit;

/* (5) 예측을 위해 시점 t=37~40의 관측값이 빈 데이터 추가 */
data ex2_new;
	y = . ; /* y값 비었음 */
	do time = 37 to 40; /* 시점  t=37~40 추가 */
		output; 
	end;
run;
data ex2_update;
merge ex2 ex2_new;
by time; /* 시간을 기준으로 데이터 합치기 */
run;
proc print; run;

/* (6) 다시 AR(2) 모형에 적합해서 예측값 구하기 */
proc autoreg data=ex2_update;
model y = time / nlag=2 method=ml;
output out=p p=yhat pm=ytrend lcl=lcl ucl=ucl; /* 예측의 상한(ucl) 하한(lcl) */
run; quit;
proc print; run;
proc sgplot data=p;
band x=time upper=ucl lower=lcl; /* 예측의 신뢰구간 */
scatter x=time y=y; /* 실제 데이터의 산점도 */
series x=time y=yhat; /* 예측값을 포함한 추정값 */
series x=time y=ytrend / lineattrs=(color=black); /* 추세선=회귀직선 */
title ’Forecasting Autocorrelated Time Series’;
run; quit;

/* (7) DW검정 for 오차항의 자기상관성 유무 확인 */
proc autoreg data=ex2;
model y = time / dw=4 dwprob; /* 4-시차까지의 자기상관유무 검정 */
run; quit;

/* 예제3 광고액과 판매액 데이터 */
/* 광고액(x)에 따른  판매액(y)을 나타낸 시계열데이터 */

/* (1) 월별 광고액과 판매액 데이터 입력 */
data ex3;
input month Sales Adver@@;
cards;
1 12 15 2 20.5 16 3 21 18
4 15.5 27 5 15.3 21 6 23.5 49
7 24.5 21 8 21.3 22 9 23.5 28
10 28 36 11 24 40 12 15.5 3
13 17.3 21 14 25.3 29 15 25 62
16 36.5 65 17 36.5 46 18 29.6 44
19 30.5 33 20 28 62 21 26 22
22 21.5 12 23 19.7 24 24 19 3
25 16 5 26 20.7 14 27 26.5 36
28 30.6 40 29 32.3 49 30 29.5 7
31 28.3 52 32 31.3 65 33 32.2 17
34 26.4 5 35 23.4 17 36 16.4 1
; run;
proc print; run;

/* (2) 시계열데이터임을 확인하기 + 산점도로 관계 확인 by proc gplot */
/* cf. plot을 꾸미고 싶을 때 사용; 근데 굳이?
proc gplot data=ex3; 시간에 따른 판매액(y) 변화 -> 시계열데이터 
plot sales * month / vaxis=axis1 haxis=axis2 ; 
axis1 major=(w=2 h=1) minor=(w=1 h=0.5) label =(f=duplex h=3 C=black A=90 R=0 "Sales") value=(h=2) ;
axis2 major=(w=2 h=1) minor=(w=1 h=0.5) label =(f=duplex h=3 C=black "Month") value=(h=2) ;
title f=duplex h=4 c=Black 'Sales in Time Series';
symbol i=join c=red v=dot h=1;
run; quit; */
proc gplot data=ex3; /* 시간에 따른 판매액(y) 변화 -> 시계열데이터 */
plot sales * month ; /* plot y축*x축 */
title 'Sales in Time Series';
run; quit;
proc gplot data=ex3; /* 시간에 따른 광고액(x) 변화 -> 시계열데이터 */
plot adver*month; 
title 'Adver in Time Series' ;
run; quit;
proc gplot data=ex3; /* 광고액(x)과 판매액(y) -> 시계열데이터 */
plot (sales adver)*month;
title " Sales and Adver in Time Series " ;
run; quit;
proc gplot data=ex3; /* 광고액(x)과 판매액(y)의 산점도 -> 선형에 가까움 */ 
plot sales * adver;
title 'Sales v.s. Adver';
symbol i=none;
run; quit;

/* (3) 일단 선형모형에 적합해보기 */
proc reg data=ex3;
model sales= adver/dw; /* D통계량 출력; 1차자기상관 검정통계량 */
output out=ex3_reg1  r=resid;
run ;
proc gplot data=ex3_reg1;
plot resid * month/vref=0; /* 그냥 잔차는 좀 커서 보기 힘든 듯? */
run; quit;
proc reg data=ex3;
model sales= adver;
output out=ex3_reg2 student=s_resid; /* 스튜던트 잔차 저장 */
run; quit;
proc gplot data=ex3_reg2;
plot s_resid * month/vref=0; /* 시간(month)에 따른 잔차를 보고 자기상관성 확인 */
symbol i=join;
run; quit;

/* (4) 자기상관성을 확인했으니 시계열모형에 적합 */
proc autoreg data=ex3; /* 제일 먼저 dw검정으로 자기상관오차 차수 확인 */
model sales= adver/dw=4 dwprob;
run; quit;
proc autoreg data=ex3 ; /* dw검정 후, AR(1) 모형으로 먼저 적합해보기 */
model sales= adver /nlag=1 method =ml dwprob ;
run; quit;
proc autoreg data=ex3 ; /* 이어서 AR(2) 모형으로도 적합해보고 비교하기 */
model sales= adver /nlag=2 method =ml dwprob ;
run; quit;

/* (5) AR(1)을 이용한 모형으로 결정 후 결과 확인 */
proc autoreg data=ex3 ; 
model sales= adver /nlag=1 method =ml ;
output out=ex3_auto p=yhat pm=trendhat;
run; quit;
proc print data=ex3_auto; run; /* proc autoreg 결과 확인 */
proc sort data=ex3_auto; by adver; run; /* 정렬 by 광고액 */
proc gplot data=ex3_auto;
plot sales * adver=1 yhat *adver=2 trendhat * adver=3 / haxis=axis1 vaxis=axis2 overlay legend=legend;
axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
symbol1 c=blue v=dot h=1 i=none ;
symbol2 c=red v=star h=1 i=none;
symbol3 c=black v=star h=1 i=join;
title h=4 "Sales v.s Advertisement";
run ; quit;
proc sort data=ex3_auto; by month; run; /* 정렬 by 시간 */
proc gplot data=ex3_auto;
plot sales * month=1 yhat *month=2 trendhat * month=3 / haxis=axis1 vaxis=axis2 overlay legend=legend;
axis1 w=4 major=(w=3) minor=none label=(h=3) value=(h=2);
axis2 w=4 major=(w=2) minor=none label=(A=90 R=0 h=3) value=(h=2);
symbol1 c=blue v=dot h=1 i=join ;
symbol2 c=red v=star h=1 i=join;
symbol3 c=black v=star h=1 i=join;
title h=4 "Prediction of Sales";
run ; quit;
