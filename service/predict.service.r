predictService <- function(input, output, dataset, data.trans) {
  # productInput <- input$select_product
  
  output$predict_chart <- renderHighchart({
    productSelect <- input$select_product
    print(productSelect)
    trans <- as(split(dataset[,"Item"], dataset[,"Transaction"]), "transactions")
    top_rules <- apriori(trans, parameter = list(supp = .001, conf = .1, minlen = 2), appearance = list(default = 'rhs', lhs = productSelect))
    top_rules_confidence <- sort(top_rules, by = "confidence", decreasing = T)
    
    df = data.frame(
      lhs = labels(lhs(top_rules_confidence)),
      name = labels(rhs(top_rules_confidence)),
      top_rules_confidence@quality
    )
    df$name <- substr(df$name,2,nchar(df$name)-1)
    df$lhs <- substr(df$lhs,2,nchar(df$lhs)-1)
    df$confidence <- df$confidence * 100
    
    hchart(df, type = "pie", hcaes(x = name, y = confidence, color = name),
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}'))
    
    
    # gp <- ggplot(data=df, aes(x=name, y=confidence, fill=name)) +
    #   geom_bar(stat="identity", width=1)
    # gp + theme(
    #   text = element_text(size=18),
    #   panel.background=element_blank(),
    #   panel.border=element_blank(),
    #   panel.grid.major=element_blank(),
    #   panel.grid.major.y = element_line(color = "grey", size = 0.2, linetype = "dashed"),
    #   plot.background=element_blank()
    # )
  })
  
  output$payment_chart <- renderHighchart({
    options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))
    paymentString <- input$select_payment
    rules.one.feature <- apriori (data = data.trans, 
                                  parameter = list(supp = 0.01, conf = 0.1, minlen = 2, maxlen = 2), 
                                  appearance = list(default ="lhs", rhs = paymentString), 
                                  control = list(verbose = FALSE))
    
    rules.one.lift <- sort(rules.one.feature, by="lift", decreasing = T)
    df = data.frame(
      name = labels(lhs(rules.one.lift)),
      rhs = labels(rhs(rules.one.lift)),
      rules.one.lift@quality
    )
    df$name <- substr(df$name,2,nchar(df$name)-1)
    print(nchar(paymentString))
    df$rhs <- substr(df$rhs,2,nchar(paymentString)-1)
    df$confidence <- df$confidence * 100
    
    hchart(df, type = "bar", hcaes(x = name, y = confidence, color = name),
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}'))
    
  })
  
  output$predict_chart_linear <- renderHighchart({
    filterYear <- input$select_year_linear
    
    weekend <- dataset[dataset$weekday_weekend == "weekday",]
    weekend$Date <- as.Date(weekend$Date, "%m/%d/%Y")
    mydates <- unique(weekend$Date)
    mydates <- as.Date(mydates, "%m/%d/%Y")
    dfDate <- data.frame(mydates)
    dfDate <- as_tbl_time(dfDate, index = mydates)
    dateFilter <- filter_time(dfDate, filterYear ~ filterYear)
    
    totalProduct <- c()
    indexWeekend <- c()
    index <- 1
    for (data in dateFilter$mydates) {
      rows <- weekend[weekend$Date == data,]
      total <- 0
      for (d in rows$TotalNumber) {
        if(!is.na(d)) total <- total + d
      }
      totalProduct <- c(totalProduct, total)
      indexWeekend <- c(indexWeekend, index)
      index <- index + 1
    }
    
    dataWeekend <- data.frame(weekend = indexWeekend, amout = totalProduct)
    
    weekend <- dataWeekend$weekend
    amout <- dataWeekend$amout
    
    modelLinear <<- lm(amout ~ weekend)
    modelToChart <- augment(lm(amout ~ weekend))
    # y = 1.56482 + 0.02239.x
    # Estimate: Hệ số beta của mô hình hồi quy
    # Std,Error: Độ lệch chuẩn của ước lượng hệ số beta tương ứng
    # t-value = Estimate/Std.Error: Là giá trị t trong kiểm định
    # plot(amout ~ weekend, data=dataWeekend)
    # abline(hoiquy,col="red")
    highchart() %>%
      hc_add_series(modelToChart, "scatter", hcaes(weekend,amout)) %>% 
      hc_add_series(modelToChart, "line", hcaes(x = weekend, y = .fitted))
    # 
    # summary(modelLinear)
  })

  observeEvent(input$btn_predict_linear, {
    print(summary(modelLinear))
    weeks <- input$input_week_linear
    if(weeks == "") output$txt_acc <- renderText("aaaa")
    else {
      output$txt_acc <- renderText("aaaa")

      listWeek <- strsplit(weeks, split = ",", fixed = TRUE)
      list <- c()
      for (i in listWeek) {
        list <- c(list, as.integer(i))
      }
      
      print(list)
      a <- data.frame(weekend = list)
      predictData <- predict(modelLinear, a )

      df <- data.frame(week = list, amout=predictData)
      df <- data.frame(names = row.names(df), df)
      
      output$table_predict_linear <- renderTable(df)
    }
    
  })
}