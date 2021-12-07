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
basket2 <- read.csv("F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket.csv")
unique(basket2$Payment)
str(basket2)
pairs(head(basket2, 1000))
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

basket2 <- read.csv("F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket.csv")
weekend <- basket2[basket2$weekday_weekend == "weekday",]
library(tibbletime)
weekend$Date <- as.Date(weekend$Date, "%m/%d/%Y")
mydates <- unique(weekend$Date)
mydates <- as.Date(mydates, "%m/%d/%Y")
dfDate <- data.frame(mydates)
dfDate <- as_tbl_time(dfDate, index = mydates)
dateFilter <- filter_time(dfDate, "2017" ~ "2017")
dateFilter

totalProduct <- c()
indexWeekend <- c()
index <- 1
for (data in dateFilter$mydates) {
  rows <- weekend[weekend$Date == data,]
  total <- 0
  for (d in rows$TotalNumber) {
    if(!is.na(d)) total <- total + d
  }
  totalProduct <- c(totalProduct, total)
  indexWeekend <- c(indexWeekend, index)
  index <- index + 1
}
# for (data in dateFilter$mydates) {
#   rows <- weekend[weekend$Date == data,]
#   total <- 0
#   for (d in rows$TotalNumber) {
#     if(!is.na(d)) total <- total + d
#   }
#   totalProduct <- c(totalProduct, total)
#   indexWeekend <- c(indexWeekend, index)
#   index <- index + 1
# }
indexWeekend
totalProduct

dataWeekend <- data.frame(weekend = indexWeekend, amout = totalProduct)
dataWeekend

weekend <- dataWeekend$weekend
amout <- dataWeekend$amout

hoiquy <- lm(amout ~ weekend)
# y = 1.56482 + 0.02239.x
# Estimate: Hệ số beta của mô hình hồi quy
# Std,Error: Độ lệch chuẩn của ước lượng hệ số beta tương ứng
# t-value = Estimate/Std.Error: Là giá trị t trong kiểm định
plot(amout ~ weekend, data=dataWeekend)
abline(hoiquy,col="red")

summary(hoiquy)
a <- data.frame(weekend = c(31,33,10))
predictData<- predict(hoiquy, a )
print(predictData)






