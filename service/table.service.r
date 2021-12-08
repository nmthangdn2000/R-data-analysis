
tableService <- function(input, output, dataset){
  str(dataset)
  dataset$dayinweek <- NULL
  colnames(dataset)[1] <- "Trans..."
  colnames(dataset)[6] <- "Quatity"
  colnames(dataset)[4] <- "week_day_end"
  nationality <- unique(dataset$Nationality)
  print(match("American", nationality))
  
  gicon <- function(x) as.character(icon(x))
  output$dataTable = DT::renderDataTable({
    
    filterItem <- input$filter_item
    filterGender <- input$filter_gender
    filterPayment <- input$filter_payment
    filterNationality <- input$filter_nationality
    filterStartDay <- input$filter_start_day
    filterEndDay <- input$filter_end_day
    
    print(length(filterItem))
    if(filterItem != "All") dataset <- dataset[dataset$Item == filterItem,]
    if(filterGender != "All") dataset <- dataset[dataset$Gender == filterGender,]
    if(filterPayment != "All") dataset <- dataset[dataset$Payment == filterPayment,]
    if(filterNationality != "All") dataset <- dataset[dataset$Nationality == filterNationality,]
    if(filterEndDay != "All" && filterStartDay != "All") {
      dataset$Date <- as.Date(dataset$Date, "%m/%d/%Y")
      filterEndDay <- as.Date(filterEndDay, "%m/%d/%Y")
      filterStartDay <- as.Date(filterStartDay, "%m/%d/%Y")
      dataset <- as_tbl_time(dataset, index = Date)
      dataset <- filter_time(dataset, filterStartDay ~ filterEndDay)
    }

    
    
    keyNationality <- c(
      "<img src='http://flagpedia.net/data/flags/mini/vn.png'></img>", 
      "<img src='http://flagpedia.net/data/flags/mini/us.png'></img>", 
      "<img src='http://flagpedia.net/data/flags/mini/de.png'></img>", 
      "<img src='http://flagpedia.net/data/flags/mini/kr.png'></img>"
    )
    flag <- c()
    for (i in dataset$Nationality) {
      a <- keyNationality[match(i, nationality)]
      flag <- c(flag, a)
    }
    dataset$Nationality <- paste(flag, dataset$Nationality, sep="  ")
    
    dataset$Gender <- ifelse(
      dataset$Gender == "Male", paste(gicon("male"), " Male", sep="  "), paste(gicon("female"), " Female", sep="  ")
    )
    DT::datatable(dataset, escape = FALSE)
  })
  
  outputFilters <- function(id) {
    value <- "a"
    label <- "b"
    list <- c()
    idUi <- paste("filter", tolower(id), sep="_")
    
    if(id == "Start_day") {
      value <- dataset$Date[1]
      label <- "Start Day"
    }
    else if(id == "End_day") {
      value <- dataset$Date[length(dataset$Date)]
      label <- "End Day"
    }
    else {
      value <- id
      label <- id
      list <- c("All", unique(dataset[[id]]))
    }
    
    print(value)
    print(label)
    
    if(id == "Start_day" || id == "End_day") {
      id = "Date"
      list <- c(unique(dataset[[id]]))
    }
    
    output[[idUi]] <- renderUI({
      selectInput(
        idUi, 
        label = label,
        choices = as.list(list),
        selected = value
      )
    })
  }
  
  filerTag <- c("Item", "Gender", "Payment", "Nationality", "Start_day", "End_day")
  for (i in filerTag) {
    outputFilters(i)
  }
}