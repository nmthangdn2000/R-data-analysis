revenueService <- function(input, output, dataset){
  output$orders_by_day_chart <- renderHighchart({
  totaltransactions <- data.frame(dayinweek = numeric(),
                                total = numeric())
  for(x in unique(dataset$dayinweek)){
    get <- unique(dataset$Transaction[dataset$dayinweek == x])
    trans <- data.frame(dayinweek = x, total = length(get))
    totaltransactions <- rbind(totaltransactions, trans)  
  }
  hchart(totaltransactions, hcaes(x=dayinweek,y=total, color = dayinweek), type="column"
           , showInLegend = TRUE, dataLabels = list(enabled = TRUE, format = '{point.y: f}')) %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(
        crosshairs = TRUE,
        backgroundColor = "#FCFFC5",
        shared = TRUE,
        borderWidth = 2,
        pointFormat = "<span style='color:{point.color}'>\u25CF</span> Total Orders: {point.y: f}<br>",
        headerFormat = "<b style = 'font-size: 20px; color: red'> {point.key} </b><br>"
      ) %>%
      hc_xAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_yAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_add_theme(hc_theme_elementary())
  })

  # top 5 sản phẩm mua nhiều nhất
  output$revenue_chart_top_5 <- renderHighchart({
    top5Price <- c()
    for (i in unique(dataset$Item)) {
      item <- dataset[dataset$Item == i,]
      total <- 0
      index <- 1
      for (p in item$Price) {
        if(!is.na(p)) total <- total + p*item[index,]$TotalNumber
        index <- index + 1
      }
      top5Price <- c(top5Price, total)
      
    }
    top5 <- data.frame(unique(dataset$Item), top5Price)
    top5 <- top5[order(-top5$top5Price),]
    top5 <- head(top5, 5)
    print(top5$Item)
    colnames(top5) <- c("Item", "TotalPrice")
    
    data <- data.frame(Item=top5$Item, TotalPrice=top5$TotalPrice)
    
    hchart(data, hcaes(x=Item,y=TotalPrice, color = TotalPrice), type="column"
           , showInLegend = TRUE, dataLabels = list(enabled = TRUE, format = '{point.y: .2f} $')) %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(
        crosshairs = TRUE,
        backgroundColor = "#FCFFC5",
        shared = TRUE,
        borderWidth = 2,
        pointFormat = "<span style='color:{point.color}'>\u25CF</span> TotalPrice: {point.y: .2f} $<br>",
        headerFormat = "<b style = 'font-size: 20px; color: red'> {point.key} </b><br>"
      ) %>%
      hc_xAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_yAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_add_theme(hc_theme_elementary())
    
    # gp <- ggplot(data=data, aes(x=Item, y=TotalPrice, fill=Item)) + 
    #   geom_bar(stat="identity", width=0.5)+
    #   geom_text(aes(label=paste( round(TotalPrice,digits=2), " EURO", sep="")), position=position_dodge(width=0.9), vjust=-0.25, size=5)
    # gp + theme(
    #   text = element_text(size=18),
    #   panel.background=element_blank(),
    #   panel.border=element_blank(),
    #   panel.grid.major=element_blank(),
    #   panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
    #   plot.background=element_blank()
    # )
  })
  
  # Tổng doanh thu theo tháng năm
  
  
  output$revenue_chart_total_revenue <- renderHighchart({
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
    
    hchart(df, hcaes(x=Month,y=TotalPrice, color = TotalPrice), type="column"
           , showInLegend = TRUE, dataLabels = list(enabled = TRUE, format = '{point.y: .2f} $')) %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(
        crosshairs = TRUE, backgroundColor = "#FCFFC5",
        shared = TRUE, borderWidth = 2,
        pointFormat = "<span style='color:{point.color}'>\u25CF</span> TotalPrice: {point.y: .2f} $<br>",
        headerFormat = "<b style = 'font-size: 20px; color: red'> {point.key} </b><br>" 
      ) %>%
      hc_xAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_yAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_add_theme(hc_theme_elementary())
    
    # gp <- ggplot(data=df, aes(x=Month, y=TotalPrice, fill=Month)) + 
    #   geom_bar(stat="identity", width=0.5)+
    #   geom_text(aes(label=paste( round(TotalPrice,digits=2), " EURO", sep="")), position=position_dodge(width=0.9), vjust=-0.25, size=5)
    # gp + theme(
    #   text = element_text(size=18),
    #   panel.background=element_blank(),
    #   panel.border=element_blank(),
    #   panel.grid.major=element_blank(),
    #   panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
    #   plot.background=element_blank()
    # )
  })
}