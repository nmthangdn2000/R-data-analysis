library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(flextable)
library(DT)
library(ggplot2)
library(plotly)
library(gganimate)
library(babynames)
library(hrbrthemes)
library(tidyverse)
library(readr)
library(dplyr)
library(highcharter)
library(arules)
library(arulesViz)
library(palmerpenguins)
library(highcharter)
library(knitr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)
library(lubridate)
theme_set(theme_bw(16))
theme_set(theme_classic())

# import tab
source('component/home.r')
source('component/table.r')
source('component/predict.r')
source('component/revenue.r')

# Layout/Table of Contents ------------------------------------------------
# 1. Create Header, Sidebar, Body --> UI
# 2. Create/import mathematical/formatting functions
# 3. Instantiate global variables
# 4. Create server that responds to user interaction
# 5. Deploy App
# -------------------------------------------------------------------------
# 1. a) Header ------------------------------------------------------------------
header <- dashboardHeader(
  title="Nguyễn Minh Thắng"
)



# 1. b) Sidebar --------------------------------------------------------------
sidebar <- dashboardSidebar(
  disable=FALSE,
  sidebarMenu(
    id = 'MenuTabs',
    menuItem("Home", tabName = "home", selected = TRUE),
    menuItem("Table", tabName = "table"),
    menuItem("Revenue", tabName = "revenue"),
    menuItem("Predict", tabName = "predict"),
    uiOutput('ui')
  )

)



# 1. c) Body -----------------------------------------------------------------
# 1. c) i. Display Layout (box, fluidRow, column) ------------------------------
# 1. c) ii. Outputs (text, table) ---------------------------------------------
# 1. c) iii. Widgets (checkbox, slider, numeric, radio, button) ----------------
# 1. c) iv. CSS formatting ----------------------------------------------------


body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/index.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/loader.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/chart.css"),
    
  ),
  tags$style(HTML('table.dataTable tr.selected td, table.dataTable td.selected {background-color: #caf7dc !important;}
                  .card__ table tr > td:last-child{
  white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    width: 79px;
    max-width: 95px;
}
                  ')),
  tabItems(
    home,
    tableUI,
    revenue,
    predict
  ),
  includeScript("./www/js/index.js")
)

# 1. d) This code generates the UI based on all the above elements --------
ui <- dashboardPage(header, sidebar, body)

