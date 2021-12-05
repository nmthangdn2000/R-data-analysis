source('component/loader.r')
tableUI <- tabItem(
  "table",
  div(
    loader,
    div(
      class = "card__",
      style = "min-height: 600px",
      h3("Dataset"),
      div(
        style = "display: flex; justify-content: space-between;",
        uiOutput("filter_item"),
        uiOutput("filter_gender"),
        uiOutput("filter_payment"),
        uiOutput("filter_nationality"),
        uiOutput("filter_start_day"),
        uiOutput("filter_end_day")
      ),
      DT::dataTableOutput("dataTable")
    ) 
  )
)