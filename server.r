library(tibbletime)
library(dplyr)
library(stringr)
library(broom)

# import service
source('service/home.service.r')
source('service/table.service.r')
source('service/predict.service.r')
source('service/revenue.service.r')

basket <- read.csv("dataset/basketnew.csv")
# data_groups <- basket %>%
#   group_by(Transaction) %>%
#   summarize(total = n()) %>%
#   mutate(OneItems = (total == 1),
#          TwoItems = (total == 2),
#          ThreeItems = (total == 3),
#          FourItems = (total == 4),
#   )
# pmt <- data.frame(Transaction = numeric(),
#                   CashPay = logical(),
#                   CreditPay = logical(),
#                   OnlineWalletPay = logical())
# 
# for(x in 1:max(basket$Transaction)) {
#   payment <- unique(basket$Payment[basket$Transaction == x])
#   if(length(payment) == 0) next
#   if(payment == "Cash"){
#     pmt[x,1] <- x
#     pmt[x,2] <-  TRUE
#     pmt[x,3] <- FALSE
#     pmt[x,4] <- FALSE
#   }
#   else if(payment == "Credit card"){
#     pmt[x,1] <- x
#     pmt[x,2] <- FALSE
#     pmt[x,3] <- TRUE
#     pmt[x,4] <- FALSE
#   }
#   else{
#     pmt[x,1] <- x
#     pmt[x,2] <- FALSE
#     pmt[x,3] <- FALSE
#     pmt[x,4] <- TRUE
#   }
# }
# 
# pmt <- na.omit(pmt)
# total <- merge(data_groups, pmt, by = "Transaction")
# write.csv(total,"F:/kì 1 năm 4/Chuyên đề/dashboard/dataset/basket3.csv", row.names = FALSE)
total <- read.csv("dataset/basket3.csv")
total <- total[-2]
total <- total[-1]
data.trans <- as(total, "transactions")
# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  homeService(input, output, basket)
  tableService(input, output, basket)
  predictService(input, output ,basket, data.trans)
  revenueService(input, output ,basket)
}