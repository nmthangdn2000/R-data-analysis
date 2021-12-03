# basket <- read.csv("F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket.csv")
# str(basket)
# 
# items <- c()
# gender <- ifelse(basket$Gender == "Male",1,0)
# period_day <- ifelse(basket$period_day == "morning",1,0)
# 
# weekday_weekend <- c()
# Nationality <- c()
# Payment <- c()
# 
# for(i in basket$Item){
#   item <- which(unique(basket$Item) == i)
#   items <- c(items, item)
# }
# for(i in basket$weekday_weekend){
#   item <- which(unique(basket$weekday_weekend) == i)
#   weekday_weekend <- c(weekday_weekend, item)
# }
# for(i in basket$Nationality){
#   item <- which(unique(basket$Nationality) == i)
#   Nationality <- c(Nationality, item)
# }
# for(i in basket$Payment){
#   item <- which(unique(basket$Payment) == i)
#   Payment <- c(Payment, item)
# }
# 
# basket$Gender <- gender
# basket$Item <- items
# basket$period_day <- period_day
# basket$weekday_weekend <- weekday_weekend
# basket$Nationality <- Nationality
# basket$Payment <- Payment
# 
# basket$Time <- NULL
# basket$Date <- NULL
# 
# View(basket)
# write.csv(basket,"F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket2.csv", row.names = FALSE)
basket2 <- read.csv("F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket2.csv")

# install.packages("caTools")
library(caTools)
#  chia bộ dữ liệu 
set.seed(100)
split = sample.split(basket2$Gender, SplitRatio = 0.65)

train = subset(basket2, split == TRUE)
test = subset(basket2, split == FALSE)
train <- na.omit(train)
test <- na.omit(test)

model = glm(Gender ~., data = train, family = binomial)
summary(model)

predictTrain = predict(model, type = "response", newdata = train)
summary(predictTrain)

predictTest = predict(model, type = "response", newdata = test)
table(test$Gender, predictTest > 0.5)

# độ chính xác của mô hình
(505+5282)/nrow(test)

# độ chính xác của mô hình cở sở
(505+871)/nrow(test)

# install.packages("ROCR")
library(ROCR)

ROCRpred = prediction(predictTest, test$Gender)
ROCRperf = performance(ROCRpred, "tpr", "fpr")

plot(ROCRperf)
plot(ROCRperf, colorize=TRUE)
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

as.numeric(performance(ROCRpred, "auc")@y.values)




