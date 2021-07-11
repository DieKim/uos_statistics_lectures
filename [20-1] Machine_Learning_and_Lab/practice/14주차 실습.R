### Chapter 11 ###

install.packages("arules")
library(arules)

## Example 1

# convert transactions into a list
a_list = list( #5명의 고객이 구매한 아이템 list
  c("a","b","c"),
  c("a","b"),
  c("a","b","d"),
  c("c","e"),
  c("a","b","d","e")
)

# set transaction names
names(a_list) = paste("Tr",c(1:5), sep = "")
a_list #거래에 이름 붙히기

# coerce into transactions
trans = as(a_list, "transactions") #변환

# analyze transactions
summary(trans) #요약; 여러가지 통계량 확인
image(trans) #이미지; 

## Example 2

# create transactions from a matrix
a_matrix = matrix( #5명의 고객이 구매한 아이템 matrix
  c(1,1,1,0,0,
    1,1,0,0,0,
    1,1,0,1,0,
    0,0,1,0,1,
    1,1,0,1,1), ncol = 5, byrow=T)

# set dim names
dimnames(a_matrix) =  list( #이름 부여
  c("a","b","c","d","e"),
  paste("Tr",c(1:5), sep = ""))
a_matrix #확인 

# coerce into transactions
trans2 =  as(a_matrix, "transactions") #변환
trans2
image(trans2)
#list가 편하긴 함 

## Example 3

# create transactions from data.frame 
a_data.frame = data.frame( #5명의 고객이 구매한 아이템 dataframe
  age = as.factor(c(6,8,7,6,9,5)),
  grade = as.factor(c(1,3,1,1,4,1)))

# note: all attributes have to be factors
a_data.frame

# coerce into transactions
trans3 = as(a_data.frame, "transactions") #변환
image(trans3) #각각의 사람을 transactuion으로 본 것

## Exmaple 4

# create from data.frame with NA
a_df = sample(c(LETTERS[1:5], NA),10,TRUE) #결측치 추가
a_df = data.frame(X = a_df, Y = sample(a_df))
a_df 

trans3 = as(a_df, "transactions") #NA값이 있는 변환 
trans3
as(trans3, "data.frame") #역변환; transaction->data.frame

## Adult data

?Adult
data(Adult)
str(Adult)

# association rules with support >= 0.5 &, confidence >= 0.9
rules = apriori(Adult, #최소 지지도 50%, 최소 신뢰도 90% 
                parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
summary(rules) #52개의 rules에 대한 summary

# association rules with support >= 0.4 
rules = apriori(Adult, parameter = list(support = 0.4)) #최소지지도 40%; 169개의 rules

# association rules having "sex" on RHS with support >=0.4 & lift >= 1.3
rules.sub = subset(rules, subset = rhs %pin% "sex" & lift > 1.3) #성별이 결과로써 오는 rules 찾기
inspect(rules.sub) #inspect; 찾은 rules을 보여줌 

## Titanic data: example from http://www.rdatamining.com 

load("titanic.raw.rdata")
head(titanic.raw)

# rules with rhs containing "Survived" only
rules = apriori(titanic.raw, parameter = list(minlen=2, supp=0.005, conf=0.8), #낮은 지지도; 규칙을 찾기 위해서
                appearance = list(rhs=c("Survived=No", "Survived=Yes"), default="lhs")) #survive=YES
rules.sorted = sort(rules, by="lift") #lift 기준으로 sorting
inspect(rules.sorted) #12개의 찾은 규칙 확인; 2등석 아이 생존 등

# find redundant rules
subset.matrix = as.matrix(is.subset(rules.sorted, rules.sorted)) #for 중복 규칙 제거
subset.matrix[lower.tri(subset.matrix, diag=T)] = NA
redundant = colSums(subset.matrix, na.rm=T) >= 1 #중복된 규칙을 날림
which(redundant) 

# remove redundant rules
rules.pruned = rules.sorted[!redundant]
inspect(rules.pruned) #중복 제거 후 8개의 규칙 확인

# visualization
library(arulesViz) #시각화 패키지
plot(rules) #디폴트 plot 
plot(rules, method="graph", control=list(type="items")) #method='graph'
plot(rules, method="paracoord", control=list(reorder=TRUE)) #method='paracoord'

## 추가 예제 

# Jester online recommender system사에서 1999년 4월에서 2003년 5월 중
# 100개의 상품에 대하여 5000명이 평점을 매김
# 평점 -10 ~ 10

library(recommenderlab)
?Jester5k
data(Jester5k)
head(as(Jester5k, "matrix"))

# 모형 적합
# method:    UBCF(고객 중심), IBCF(상품 중심)
# type:     ratings(평점 추정), topNList(상품 추천)

r = Recommender(Jester5k[1:1000], method="UBCF") #앞의 1000개로 고객 중심 Recommender
pr = predict(r, Jester5k[1001:1002], type="ratings") #예측 by ratings
as(pr, "matrix") 

# 상품 추천
ptype = predict(r, Jester5k[1001:1002], n=5) #1001번째 고객에게 5개의 상품 추천 
as(ptype, "list")

