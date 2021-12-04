source('component/loader.r')

predict <- tabItem("predict",
    div(
        class = "flex-container",
        div(
            loader,
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
)