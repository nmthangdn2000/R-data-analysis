source('component/loader.r')

home <- tabItem("home",
   #  div(
   #    DT::dataTableOutput("table_basket"),style = "height:100%; width:100%"
   # )
   fluidRow(
     valueBox(418626.79, "Total Price", icon = icon("money-check-alt"), width = 3),
     
     # A static valueBox
     valueBox(94, "Products", icon = icon("box-open"), width = 3),
     
     # Dynamic valueBoxes
     valueBox(1853, "Customer", icon = icon("users"), width = 3),
     
     valueBox(9465, "Orders", icon = icon("shopping-cart"), width = 3)
   ),
   div(
     div(
       class = "card__ card__order",
       style = "height:100%; width:100%; position: relative;",
       loader,
       div(
         style = "display: flex; justify-content: space-between;",
         h3('Order by day'),
         div(
           class = "divSelect",
           style = "display: flex; justify-content: space-between; height: 20px",
           uiOutput("filter_home_start_day"),
           uiOutput("filter_home_end_day"),
           textInput("input_number_show", label = "Show", width = "50px", value = 15),
         )
       ),
       # plotOutput("revenue_chart_order")
       highchartOutput("revenue_chart_order")
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
             selectInput("select_product_home", NULL, c("Bread", "Scandinavian","Jam", "Tea", "Coffee", "Spanish Brunch"))
           ),
         ),
         highchartOutput("sentiment_chart")
       )
       
     )
   )
)