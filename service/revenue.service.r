revenueService <- function(input, output, dataset){
  print(unique(dataset$Item))
  output$revenue_table_basket <- renderDataTable({
    datatable(
      dataset, 
      options = list(
        pageLength = 15, autoWidth = TRUE
      )
    )
  })
  str(dataset)
  output$revenue_chart <- renderPlotly({
    top5Price <- c()
    for (i in unique(dataset$Item)) {
      item <- dataset[dataset$Item == i,]
      total <- 0
      for (p in item$Price) {
        total <- total + p
      }
      top5Price <- c(top5Price, total)
      
    }
    top5 <- data.frame(unique(dataset$Item), top5Price)
    top5 <- top5[order(-top5$top5Price),]
    top5 <- head(top5, 5)
    print(top5$Item)
    colnames(top5) <- c("Item", "TotalPrice")
    df2 <- data.frame(Item=top5$Item,
                     TotalPrice=top5$TotalPrice)
    ggplot(data=df2, aes(x=Item, y=TotalPrice)) +
      geom_bar(stat="identity", width=0.5)
  })
}