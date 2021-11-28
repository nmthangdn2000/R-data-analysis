library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(flextable)
library(DT)

basket <- read.csv("dataset/basket.csv")

# 4. Create server that responds to user interaction ----------------------
server <- function(session, input, output) {
  output$table_basket <- renderDataTable({
    datatable(
      basket, 
      options = list(
        pageLength = 15, autoWidth = TRUE
      )
    )
  })
}