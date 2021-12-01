
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
  
  
  output$revenue_chart_total_revenue <- renderPlotly({
    
    dates <- dataset$Date
    as.Date(dataset$Date, "%m/%d/%Y")
    mydates <- as.Date(dates, "%m/%d/%Y")
    
    # mydates <- unique(mydates[!is.na(mydates)])
    dfDate <- data.frame(mydates)
    dfDate <- as_tbl_time(dfDate, index = mydates)
    dateFilter <- filter_time(dfDate, '2017' ~ '2017')
    listDate <- unique(dateFilter$mydates)
    listMonth <- unique(format(as.POSIXct(listDate), "%m"))
    
    totalPrice <- c()
    for (i in listMonth) {
      # str_detect so sánh chuỗi, paste nối chuỗi
      dateData <- dataset[str_detect(dataset$Date, paste( i, "2017", sep="/.*/")),]
      total <- 0
      for (p in dateData$Price) {
        if(!is.na(p)) total <- total + p
      }
      print(total)
      totalPrice <- c(totalPrice, total)
    }
    
    df <- data.frame(listMonth, totalPrice)
    colnames(df) <- c("Month", "TotalPrice")

    gp <- ggplot(data=df, aes(x=Month, y=TotalPrice, fill=Month)) + 
      geom_bar(stat="identity", width=0.5)+
      transition_states(
        frame,
        transition_length = 2,
        state_length = 1
      ) +
      ease_aes('sine-in-out')
  })
}