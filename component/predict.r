source('component/loader.r')

predict <- tabItem("predict",
    div(
      loader,
      div(
        class = "card__ flex-container",
        div(
          div(
            style = "display: flex; justify-content: space-between;",
            h3('Predict Chart'),
            div(
              class = "divSelect",
              style = "display: flex; justify-content: space-between; width: 150px;margin-top: 15px; height: 20px",
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
            h3('Predict Payment'),
            div(
              class = "divSelect",
              style = "display: flex; justify-content: space-between; width: 150px;margin-top: 15px; height: 20px",
              selectInput("select_payment", NULL, c("CreditPay","CashPay","OnlineWalletPay"))
            )
          ),
          highchartOutput("payment_chart"),
        )
      )
    )
)