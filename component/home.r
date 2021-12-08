source('component/loader.r')

home <- tabItem("home",
   #  div(
   #    DT::dataTableOutput("table_basket"),style = "height:100%; width:100%"
   # )
   fluidRow(
     valueBox(10 * 2, "Total Price", icon = icon("money-check-alt"), width = 3),
     
     # A static valueBox
     valueBox(10 * 2, "Products", icon = icon("box-open"), width = 3),
     
     # Dynamic valueBoxes
     valueBox(10 * 2, "Customer", icon = icon("users"), width = 3),
     
     valueBox(10 * 2, "Orders", icon = icon("shopping-cart"), width = 3)
   ),
   div(
     div(
       class = "card__",
       style = "height:100%; width:100%; position: relative;",
       loader,
       div(
         h3('Order by day')
       ),
       # plotOutput("revenue_chart_order")
       highchartOutput("revenue_chart_order")
     ),
   ),
   br(),
   div(
     style = "display: flex; justify-content: space-between;width: 100%",
     div(
       class = "card__",
       style = "height:100%; width:100%; flex: 0 0 49%; margin-right: 10px; position: relative;",
       loader,
       div(
         h3('Top 5 most purchased products')
       ),
       highchartOutput("revenue_chart_top_5")
     ),                 
     div(
       class = "card__",
       style = "height:100%; width:100%; flex: 0 0 49%;",
       loader,
       div(
         style = "display: flex; justify-content: space-between;",
         h3('Total revenue'),
         div(
           class = "divSelect",
           style = "display: flex; justify-content: space-between; width: 150px;margin-top: 15px; height: 20px",
           selectInput("select_year", NULL, c("2016", "2017"))
         )
       ),
       highchartOutput("revenue_chart_total_revenue")
     ), 
   ),
  br(),
  div(
    loader,
    div(
      class = "card__ flex-contianer",
      div(
        style = "display: flex, justify-content: space-between;",
        div(
          style = "display:flex; justify-content: space-between; flex-direction: row;",
          h3("Sentiment Analysis"),
          div(
            class = "divSelect",
            style = "display:flex; justify-content: space-between;flex; width: 150px; margin-top: 15px; height: 20px",
            selectInput("select_product", NULL, c("Bread", "Scandinavian","Jam", "Tea", "Coffee", "Spanish Brunch"))
          ),
        ),
        highchartOutput("sentiment_chart")
      )

    )
  )
)