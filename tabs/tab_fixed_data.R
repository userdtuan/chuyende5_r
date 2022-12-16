tab_fixed_data <- tabItem(tabName = "fixed_data", fluid = TRUE,
fluidRow(box(title = "Dữ liệu đã xử lý",
                width = 16,
                color = "blue",withSpinner(dataTableOutput("fixedData"), type = 1)))
 )