

tab1Service <- function(input, output, dataset){
  output$table_basket <- renderDataTable({
    datatable(
      dataset, 
      options = list(
        pageLength = 15, autoWidth = TRUE
      )
    )
  })
}