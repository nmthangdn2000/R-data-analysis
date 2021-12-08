customerService <- function(input, output ,basket) {
  output$customer_chart_gender <- renderHighchart({
    items <- unique(basket$Item)
    male <- c()
    feMale <- c()
    for (d in items) {
      rows <- basket[basket$Item == d,]
      male <- c(male, nrow(subset(rows, Gender=="Male"))) 
      feMale <- c(feMale, nrow(subset(rows, Gender=="female"))) 
    }
    
    df <- data.frame(items, male, feMale)
    View(df)
    
    df <- head(df, 10)
    
    highchart() %>% 
      hc_chart(type = "column") %>%
      hc_plotOptions(column = list(stacking = "normal")) %>%
      hc_xAxis(categories = df$items) %>%
      hc_add_series(name="Male",
                    data = df$male,
                    stack = "Assets") %>%
      hc_add_series(name="Female",
                    data = df$feMale,
                    stack = "Liabilities") %>%
      hc_add_theme(hc_theme_elementary())
  })
  
  output$customer_chart_pie_gender <- renderHighchart({
    male <- nrow(subset(basket, Gender=="Male"))
    feMale <- nrow(subset(basket, Gender=="female"))
    name <- c("male", "female")
    gender <- c(male, feMale)
    
    df <- data.frame(name, gender)
    
    hchart(df, type = "pie", hcaes(x = name, y = gender, color = name),
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}'))
  })
  
  output$customer_chart_pie_nation <- renderHighchart({
    vn <- nrow(subset(basket, Nationality=="Vietnamese"))
    am <- nrow(subset(basket, Nationality=="American"))
    ge <- nrow(subset(basket, Nationality=="Germany"))
    ko <- nrow(subset(basket, Nationality=="Korean"))
    name <- c("Vietnamese", "American","Germany","Korean")
    scale <- c(vn, am, ge, ko)
    
    df <- data.frame(name, scale)
    
    hchart(df, type = "pie", hcaes(x = name, y = scale, color = name),
           datalabels = list(enabled = TRUE, format = '{point.name} : {point.percentage:.1f}'))
  })
}