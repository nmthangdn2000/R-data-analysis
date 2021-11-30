revenue <- tabItem(
  "revenue",
  div(
    class = "revenue-chart",
    style = "height:100%; width:100%",
    plotlyOutput("revenue_chart")
  ),                 
  div(
    DT::dataTableOutput("revenue_table_basket"),style = "height:100%; width:100%"
  )
)