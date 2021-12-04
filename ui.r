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
library(palmerpenguins)
library(highcharter)
theme_set(theme_bw(16))
theme_set(theme_classic())

# import tab
source('component/home.r')
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
    menuItem("Revenue", tabName = "revenue"),
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
    tags$link(rel = "stylesheet", type = "text/css", href = "css/chart.css")
  ),
  tabItems(
    home,
    revenue
  ),
  includeScript("./www/js/index.js")
)

# 1. d) This code generates the UI based on all the above elements --------
ui <- dashboardPage(header, sidebar, body)

