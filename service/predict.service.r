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
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}')) %>%
      hc_title(text = "Percentage of predicting product")
    
    
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
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}')) %>%
      hc_title(text = "Proportion Of Payment")
    
  })
}