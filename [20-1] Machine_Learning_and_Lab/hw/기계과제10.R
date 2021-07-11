### Q1 ###
#arules 패키지의 Groceries 데이터에 대하여 연관규칙을 탐색하시오.

# 데이터 탐색
set.seed(1)
library(arules)
?Groceries
data(Groceries)
str(Groceries)

# 연관규칙 with support >= 0.002 & confidence >= 0.80
rules = apriori(Groceries, parameter = list(supp = 0.002, conf = 0.80, target = "rules"))
summary(rules) 
rules.sorted = sort(rules, by="lift") 
inspect(rules.sorted)

# 중복 규칙 제거
subset.matrix = as.matrix(is.subset(rules.sorted, rules.sorted))
subset.matrix[lower.tri(subset.matrix, diag = T)] = NA
redundant = colSums(subset.matrix, na.rm = T) >= 1
rules.pruned = rules.sorted[!redundant]
inspect(rules.pruned)

# visualization
library(arulesViz)
plot(rules.pruned) #디폴트 plot 
plot(rules.pruned, method="graph", control=list(type="items")) #method='graph'
plot(rules.pruned, method="paracoord", control=list(reorder=TRUE)) #method='paracoord'

### Q2 ###
# recommenderlab의 MovieLense 데이터에서 1-500번 사용자에 대하여 
# 고객 중심 협업필터링으로 모형을 세우고,
# 501~502번째 사용자에게 추천할 품목 5개를 찾으시오.

set.seed(1)
library(recommenderlab)
data(MovieLense)
r = Recommender(MovieLense[1:500], method="UBCF") #1-500번 사용자에 대하여 고객 중심 Recommender
ptype = predict(r, MovieLense[501:502], type='topNList', n=5) #501-502번째 고객에게 5개의 상품 추천 
as(ptype, "list")

