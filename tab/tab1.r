tab1 <- tabItem("tab1",
    div(
      p("Dashboard tab content"),
      DT::dataTableOutput("table_basket"),style = "height:100%;"
   )
)