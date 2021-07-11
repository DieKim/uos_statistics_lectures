/* Q7.2 */

/* (1) 데이터 입력 및 로그변환 */
data depart;
   infile 'C:\Users\USER\Desktop\depart.txt'; 
   input z @@;
   date=intnx('month','1jan84'd,_n_-1);  
   format date Monyy.; 
run; 

data lndepart; 
   set depart; 
   logz=log(z); /* 로그변환 */ 
run;

/* (2) 계절차분 및 시계열도 */
data depart; 
   set lndepart; 
   dif1_12=dif12(logz); /* 계절차분 */
run;
proc sgplot; 
   series x=date y=dif1_12 ; 
   xaxis values=('1jan85'd to '1jan89'd by year) 
   label="date"; yaxis label="∇12 ln Zt";  
run; quit;

/* (3) 1차추세 제거 후 시계열도 */
data depart; 
   set lndepart; 
   dif1_12=dif12(logz); /* 계절차분 */
   dif1=dif(dif1_12); /* 1차 차분 */
run;
proc sgplot; 
   series x=date y=dif1 ; 
   xaxis values=('1jan85'd to '1jan89'd by year) 
   label="date"; yaxis label="∇12∇ ln Zt"; 
   refline 0/ axis=y; 
run; quit;

/* 예 7-4 */
 data depart; 
   set lndepart; 
   dif1=dif(logz); /* 1차 차분 */  
   dif1_12=dif12(dif1); /* 계절차분 */
run;
  proc sgplot; 
   series x=date y=dif1_12 ; 
	xaxis values=('1jan85'd to '1jan89'd by year) label="date"; 
    yaxis label="∇∇12 ln Zt";  
   refline 0 / axis=y;  
run; quit; 

