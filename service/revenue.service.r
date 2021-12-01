
revenueService <- function(input, output, dataset){
  str(dataset)
  # top 5 sản phẩm mua nhiều nhất
  output$revenue_chart_top_5 <- renderPlotly({
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
    
    a <- data.frame(Item=top5$Item, TotalPrice=c(0,0,0,0,0), frame=rep('a',5))
    b <- data.frame(Item=top5$Item, TotalPrice=top5$TotalPrice, frame=rep('b',5))
    data <- rbind(a,b) 
    
    gp <- ggplot(data=data, aes(x=Item, y=TotalPrice, fill=Item)) + 
      geom_bar(stat="identity", width=0.5)+
      transition_states(
        frame,
        transition_length = 2,
        state_length = 1
      ) +
      ease_aes('sine-in-out')
  })
  
  # Tổng doanh thu theo tháng năm
  dates <- dataset$Date
  print(dates)
  mydates <- as.Date(dates, "%d-%m-%Y")
  mydates <- unique(mydates[!is.na(mydates)])
  print(mydates)
  dfDate <- data.frame(mydates)
  dfDate <- as_tbl_time(dfDate, index = mydates)
  dateFilter <- filter_time(dfDate, '2016' ~ '2016')
  dfDate <- data.frame(dateFilter$mydates)
  View(dfDate)
  
  output$revenue_chart_total_revenue <- renderPlotly({
    
  })
}