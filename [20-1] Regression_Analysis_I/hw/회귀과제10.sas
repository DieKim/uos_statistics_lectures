/* p155 data */
data pizza;
input month$ ads cost sales @@;
cards;
Jan 11 14.0 49.4  Feb  8 11.8 47.5  Mar 11 15.7 52.6  Apr 14 15.5 49.3
May 17 19.5 61.1  Jun 15 16.8 53.2  Jul 12 12.8 47.4  Aug 10 13.6 49.4
Sep 17 18.2 62.0  Oct 11 16.0 47.9  Nov  8 13.0 47.3  Dec 18 20.0 61.5
Jan 12 15.1 54.2  Feb 10 14.2 44.7  Mar 13 17.3 53.6  Apr 12 15.9 55.4
;
run;

/* p157 table */
proc reg data = pizza;
x1_only: model sales = ads/vif;
x2_only: model sales = cost/vif;
x1_x2: model sales = ads cost/vif; 
run;


