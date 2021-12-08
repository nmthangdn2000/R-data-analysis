source('component/loader.r')

revenue <- tabItem("revenue",
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
  ) 
)