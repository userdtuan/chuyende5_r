tab_database <- tabItem(tabName = "database",
            fluidRow(DT::dataTableOutput("moviesTable")))