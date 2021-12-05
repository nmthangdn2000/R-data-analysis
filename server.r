library(tibbletime)
library(dplyr)
library(stringr)

# import service
source('service/home.service.r')
source('service/table.service.r')
source('service/predict.service.r')

basket <- read.csv("dataset/basket.csv")

# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  homeService(input, output, basket)
  tableService(input, output, basket)
  predictService(input, output ,basket)
}