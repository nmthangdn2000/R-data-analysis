

homeService <- function(input, output, dataset){
  print(unique(dataset$Item))
  output$table_basket <- renderDataTable({
    datatable(
      dataset, 
      options = list(
        pageLength = 15, autoWidth = TRUE
      )
    )
  })
}