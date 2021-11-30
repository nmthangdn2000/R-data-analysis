# import service
source('service/tab1.service.r')

basket <- read.csv("dataset/basket.csv")

# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  homeService(input, output, basket)
}