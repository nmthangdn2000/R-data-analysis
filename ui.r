# import tab
source('tab/tab1.r')

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
    menuItem("Tab1", tabName = "tab1", selected = TRUE),
    menuItem("Tab2", tabName = "tab2"),
    uiOutput('ui')
  )

)



# 1. c) Body -----------------------------------------------------------------
# 1. c) i. Display Layout (box, fluidRow, column) ------------------------------
# 1. c) ii. Outputs (text, table) ---------------------------------------------
# 1. c) iii. Widgets (checkbox, slider, numeric, radio, button) ----------------
# 1. c) iv. CSS formatting ----------------------------------------------------


body <- dashboardBody(
  tabItems(
    tab1,
    tabItem("tab2",
      "Widgets tab content"
    )
  )
)

# 1. d) This code generates the UI based on all the above elements --------
ui <- dashboardPage(header, sidebar, body)



