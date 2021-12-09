source('component/loader.r')

predict <- tabItem("predict",
     div(
       loader,
       div(
         class = "card__ flex-container",
         div(
           div(
             style = "display: flex; justify-content: space-between;",
             h3('Linear regression'),
             div(
               class = "divSelect",
               style = "display: flex; justify-content: space-between;margin-top: 15px; height: 20px",
               selectInput("select_week_linear", NULL, c("weekday","weekend")),
               selectInput("select_year_linear", NULL, c(2016, 2017))
             )
           ),
           div(
             style = "display: flex; justify-content: space-between; ",
             div(
               style = "flex: 0 0 68%",
               highchartOutput("predict_chart_linear")
             ),
             div(
               style = "flex: 0 0 30%",
               div(style = "font-weight: bold", "Coefficient of determination: "), textOutput('txt_acc'),
               textInput("input_week_linear", label = "Weeks", placeholder = "Enter number week"),
               actionButton("btn_predict_linear", "Predice"),
               tableOutput('table_predict_linear'),
             )
           )
         )
       )
     ),
     br(),
    div(
      loader,
      div(
        class = "card__ flex-container",
        div(
          div(
            style = "display: flex; justify-content: space-between;",
            h3('Relationship between products'),
            div(
              class = "divSelect",
              style = "display: flex; justify-content: space-between; margin-top: 15px; height: 20px",
              selectInput("select_product", NULL, c("Spanish Brunch", "Bread", "Coffee", "Cake", "Juice"))
            )
          ),
          highchartOutput("predict_chart"),
        )
      )
    ),
    br(),
    div(
      loader,
      div(
        class = "card__ flex-container",
        div(
          div(
            style = "display: flex; justify-content: space-between;",
            h3('Relationship between payment and quantity of product'),
            div(
              class = "divSelect",
              style = "display: flex; justify-content: space-between; margin-top: 15px; height: 20px",
              selectInput("select_payment", NULL, c("CreditPay","CashPay","OnlineWalletPay"))
            )
          ),
          highchartOutput("payment_chart"),
        )
      )
    )
)