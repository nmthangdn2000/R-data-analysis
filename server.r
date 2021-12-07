library(tibbletime)
library(dplyr)
library(stringr)

# import service
source('service/home.service.r')
source('service/table.service.r')
source('service/predict.service.r')

basket <- read.csv("dataset/basket.csv")

data_groups <- basket %>% 
  group_by(Transaction) %>%
  summarize(total = n()) %>%
  mutate(OneItems = (total == 1),
         TwoItems = (total == 2),
         ThreeItems = (total == 3),
         FourItems = (total == 4),
  )
pmt <- data.frame(Transaction = numeric(),
                  CashPay = logical(),
                  CreditPay = logical(),
                  OnlineWalletPay = logical())

for(x in 1:max(basket$Transaction)) {
  payment <- unique(basket$Payment[basket$Transaction == x])
  if(length(payment) == 0) next 
  if(payment == "Cash"){
    pmt[x,1] <- x
    pmt[x,2] <-  TRUE
    pmt[x,3] <- FALSE
    pmt[x,4] <- FALSE
  }
  else if(payment == "Credit card"){
    pmt[x,1] <- x
    pmt[x,2] <- FALSE
    pmt[x,3] <- TRUE
    pmt[x,4] <- FALSE
  }
  else{
    pmt[x,1] <- x
    pmt[x,2] <- FALSE
    pmt[x,3] <- FALSE
    pmt[x,4] <- TRUE
  }
}

pmt <- na.omit(pmt)
total <- merge(data_groups, pmt, by = "Transaction")

total <- total[-2]
total <- total[-1]


data.trans <- as(total, "transactions")
print(data.trans)

# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  homeService(input, output, basket)
  tableService(input, output, basket)
  predictService(input, output ,basket, data.trans)
}