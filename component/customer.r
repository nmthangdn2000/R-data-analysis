source('component/loader.r')
customer <- tabItem(
  "customer",
  div(
    div(
      class = "card__ card__order",
      style = "height:100%; width:100%; position: relative;",
      loader,
      div(
        style = "display: flex; justify-content: space-between;",
        h3('Trending Order By Gender'),
        div(
          class = "divSelect",
          style = "display: flex; justify-content: space-between; height: 20px",
        )
      ),
      # plotOutput("revenue_chart_order")
      highchartOutput("customer_chart_gender")
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
        h3('Proportion of Gender')
      ),
      highchartOutput("customer_chart_pie_gender")
    ),                 
    div(
      class = "card__",
      style = "height:100%; width:100%; flex: 0 0 49%;",
      loader,
      div(
        style = "display: flex; justify-content: space-between;",
        h3('Proportion of nationality'),
       
      ),
      highchartOutput("customer_chart_pie_nation")
    ), 
  ),
)