# import service
source('service/home.service.r')

basket <- read.csv("dataset/basket.csv")
View(basket)
# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  homeService(input, output, basket)
}