basket <- read.csv("F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket2.csv")
str(basket)
summary(basket)
basket <- basket[complete.cases(basket), ]
any(is.na(basket))
set.seed(123)
unique(basket$Payment)
unique(basket$Nationality)
tagAge <- c()
for (i in basket$Age) {
  a <- 0
  if(i == 1) a <- sample.int(16, 21, replace = TRUE)
  else if(i == 2) a <- sample.int(18, 26, replace = TRUE)
  else a <- sample.int(24, 30, replace = TRUE)
  tagAge <- c(tagAge, a)
}
basket$Age <- tagAge

basketCluster <- kmeans(basket[, 5:8], 3, nstart = 20)

table(basketCluster$cluster, basket$Age)

plot(basket$TotalNumber, basket$Payment, col = basket$Age, pch = basketCluster$cluster)
