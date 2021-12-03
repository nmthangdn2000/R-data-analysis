homeService <- function(input, output, dataset){
  # output$table_basket <- renderDataTable({
  #   datatable(
  #     dataset, 
  #     options = list(
  #       pageLength = 15, autoWidth = TRUE
  #     )
  #   )
  # })
  # Đơn hàng theo ngày
  
  output$revenue_chart_order <- renderPlot({
    
    dates <- dataset$Date
    as.Date(dataset$Date, "%m/%d/%Y")
    mydates <- as.Date(dates, "%m/%d/%Y")
    listDate <- unique(dates)
    totalOrder <- c()
    for (d in listDate) {
      item <- unique(dataset$Transaction[dataset$Date == d])
      totalOrder <- c(totalOrder, length(item))
      
    }
    
    data <- data.frame(listDate, totalOrder)
    colnames(data) <- c("Date", "Order")
    data <- head(data, 15)
    
    g <- ggplot(data=data, aes(x=Date, y=Order, group=1)) +
      geom_text(aes(label=Order), position=position_dodge(width=0.9), vjust=-0.25, size=5)+
      geom_smooth(
        method = "loess",
        se = FALSE,
        formula = 'y ~ x',
        span = 0.2,
        color = "green"
      ) +
      stat_smooth(
        se=FALSE, geom="area",
        method = 'loess', alpha=.2,
        span = 0.2,
        fill = "green"
      )
    g + theme(
      text = element_text(size=18),
      axis.text.x = element_text(angle = 45, vjust=0.5),
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
      plot.background=element_blank()
    )
  })
  
  
  # top 5 sản phẩm mua nhiều nhất
  output$revenue_chart_top_5 <- renderPlot({
    top5Price <- c()
    for (i in unique(dataset$Item)) {
      item <- dataset[dataset$Item == i,]
      total <- 0
      for (p in item$Price) {
        if(!is.na(p)) total <- total + p
      }
      top5Price <- c(top5Price, total)
      
    }
    top5 <- data.frame(unique(dataset$Item), top5Price)
    top5 <- top5[order(-top5$top5Price),]
    top5 <- head(top5, 5)
    print(top5$Item)
    colnames(top5) <- c("Item", "TotalPrice")
    
    data <- data.frame(Item=top5$Item, TotalPrice=top5$TotalPrice)
    
    gp <- ggplot(data=data, aes(x=Item, y=TotalPrice, fill=Item)) + 
      geom_bar(stat="identity", width=0.5)+
      geom_text(aes(label=paste( round(TotalPrice,digits=2), " EURO", sep="")), position=position_dodge(width=0.9), vjust=-0.25, size=5)
    gp + theme(
      text = element_text(size=18),
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
      plot.background=element_blank()
    )
  })
  
  # Tổng doanh thu theo tháng năm
  
  
  output$revenue_chart_total_revenue <- renderPlot({
    yearInput <- input$select_year
    print(yearInput)
    dates <- dataset$Date
    as.Date(dataset$Date, "%m/%d/%Y")
    mydates <- as.Date(dates, "%m/%d/%Y")

    dfDate <- data.frame(mydates)
    dfDate <- as_tbl_time(dfDate, index = mydates)
    dateFilter <- filter_time(dfDate, yearInput ~ yearInput)
    listDate <- unique(dateFilter$mydates)
    listMonth <- unique(format(as.POSIXct(listDate), "%m"))
    
    totalPrice <- c()
    for (i in listMonth) {
      # str_detect so sánh chuỗi, paste nối chuỗi
      dateData <- dataset[str_detect(dataset$Date, paste( i, yearInput, sep="/.*/")),]
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
      geom_text(aes(label=paste( round(TotalPrice,digits=2), " EURO", sep="")), position=position_dodge(width=0.9), vjust=-0.25, size=5)
    gp + theme(
      text = element_text(size=18),
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
      plot.background=element_blank()
    )
  })
}