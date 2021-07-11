###Q1.
x1 = c(560, 540, 520, 580, 520, 620, 660, 630, 550, 550, 600, 537) #GMAT
y1 = c(3.20, 3.44, 3.70, 3.10, 3.00, 4.00, 3.38, 3.83, 2.67, 2.75, 2.33, 3.75) #GPA

#1-(a). 산점도를 그려라
plot(x1, y1, xlab="GMAT", ylab="GPA", main="Scatter Plot of Q1")

#1-(b). 다음을 계산하라(n=12)
q1_1 = round(sum(x1), digit=2) 
q1_1
q2_1 = round(sum(y1), digit=2)
q2_1 
q3_1 = round(sum(x1^2), digit=2) 
q3_1
q4_1 = round(sum(x1*y1), digit=2) 
q4_1
q5_1 = round(sum((x1-mean(x1))^2), digit=2) 
q5_1
q6_1 = round(sum((x1-mean(x1))*(y1-mean(y1))) ,digit=2)
q6_1
q7_1 = round(q6_1/q5_1, digit=2)
q7_1
q8_1 = round(mean(y1)-q7_1*mean(x1) ,digit=2)
q8_1
q9_1 = round(sum(y1-(q8_1+q7_1*x1)) ,digit=2)
q9_1
q10_1 = round(sum((y1-(q8_1+q7_1*x1))*x1), digit=2)
q10_1
q11_1 = round(sum((y1-(q8_1+q7_1*x1))*(q8_1+q7_1*x1)), digit=2)
q11_1
q12_1 = round(sum((y1-(q8_1+q7_1*x1))^2)/(12-2), digit=2)
q12_1

###Q2.
x2 = c(65,63,47,54,60,44,59,64,51,49,57,56,63,41,43) #Age
y2 = c(164,220,133,146,162,144,166,152,140,145,135,150,170,122,120) #SBP

#2-(a). 산점도를 그려라
plot(x2,y2,xlab="Age",ylab="SBP",main="Scatter Plot of Q2")

#2-(b). 다음을 계산하라(n=15)
q1_2 = round(sum(x2), digit=2) 
q1_2
q2_2 = round(sum(y2), digit=2)
q2_2 
q3_2 = round(sum(x2^2), digit=2) 
q3_2
q4_2 = round(sum(x2*y2), digit=2) 
q4_2
q5_2 = round(sum((x2-mean(x2))^2), digit=2) 
q5_2
q6_2 = round(sum((x2-mean(x2))*(y2-mean(y2))) ,digit=2)
q6_2
q7_2 = round(q6_2/q5_2, digit=2)
q7_2
q8_2 = round(mean(y2)-q7_2*mean(x2) ,digit=2)
q8_2
q9_2 = round(sum(y2-(q8_2+q7_2*x2)) ,digit=2)
q9_2
q10_2 = round(sum((y2-(q8_2+q7_2*x2))*x2), digit=2)
q10_2
q11_2 = round(sum((y2-(q8_2+q7_2*x2))*(q8_2+q7_2*x2)), digit=2)
q11_2
q12_2 = round(sum((y2-(q8_2+q7_2*x2))^2)/(15-2), digit=2)
q12_2
 
