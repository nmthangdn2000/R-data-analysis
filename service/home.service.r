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
  output$sentiment_chart <- renderHighchart({
    select_product <- input$select_product
    if(length(select_product)== 0) select_product = "Bread"

    
    containItem <- dataset %>% filter(grepl(select_product, Item))
    Comments <- iconv(head(containItem$Comment,100))
    sentiment <- get_nrc_sentiment(Comments)
    sentimentforchart <- data.frame(expression = character(),
                                count = numeric())
    for(x in 1:10) {
      held <- data.frame(expression = name[x], count = sum(sentiment[,x]))
        sentimentforchart <- rbind(sentimentforchart, held)
    }

    hchart(sentimentforchart, hcaes(x=expression,y=count, color = expression), type="column"
       , showInLegend = TRUE, dataLabels = list(enabled = TRUE, format = '{point.y: f}')) %>%
    hc_exporting(enabled = TRUE) %>% 
    hc_tooltip(
      crosshairs = TRUE,
      backgroundColor = "#FCFFC5",
      shared = TRUE,
      borderWidth = 2,
      pointFormat = "<span style='color:{point.color}'>\u25CF</span> Count: {point.y: f}<br>",
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
  
  output$revenue_chart_order <- renderHighchart({
    
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
    
    hchart(data, hcaes(x=Date,y=Order),type="area",color="#43dc80", fillOpacity = 0.3) %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(
        crosshairs = TRUE, backgroundColor = "#FCFFC5",
        shared = TRUE, borderWidth = 2,
        pointFormat = "<span style='color:{point.color}'>\u25CF</span> Order: {point.y: .2f} $<br>",
        headerFormat = "<b style = 'font-size: 20px; color: red'> {point.key} </b><br>"         
      ) %>%
      hc_xAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"), rotation = -45)
      )%>%
      hc_yAxis(
        title = list(style = list(fontSize = "16px", fontWeight = "600")), 
        labels = list(style = list(fontSize = "12px", fontWeight = "600"))
      )%>%
      hc_add_theme(hc_theme_elementary())
    
    # g <- ggplot(data=data, aes(x=Date, y=Order, group=1)) +
    #   geom_text(aes(label=Order), position=position_dodge(width=0.9), vjust=-0.25, size=5)+
    #   geom_smooth(
    #     method = "loess",
    #     se = FALSE,
    #     formula = 'y ~ x',
    #     span = 0.2,
    #     color = "green"
    #   ) +
    #   stat_smooth(
    #     se=FALSE, geom="area",
    #     method = 'loess', alpha=.2,
    #     span = 0.2,
    #     fill = "green"
    #   )
    # g + theme(
    #   text = element_text(size=18),
    #   axis.text.x = element_text(angle = 45, vjust=0.5),
    #   panel.background=element_blank(),
    #   panel.border=element_blank(),
    #   panel.grid.major=element_blank(),
    #   panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
    #   plot.background=element_blank()
    # )
  })
  
  
  # top 5 sản phẩm mua nhiều nhất
  output$revenue_chart_top_5 <- renderHighchart({
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
           , showInLegend = TRUE, dataLabels = list(enabled = TRUE, format = '{point.y: .2f} euro')) %>%
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