tab_raw_datasets <- tabItem(tabName = "raw_datasets", fluid = TRUE,
fluidRow(
                valueBox("Số thí sinh", nrow(kq_thpt_raw), color = "blue", width = 6, size = "small"),
                valueBox("Số tỉnh", nrow(list_tinh), color = "red", width = 5, size = "small"),
              ),
fluidRow(
                tabBox(color = "blue", width = 16,
                       collapsible = FALSE,
                       tabs = list(
                         list(menu = "Danh sách tỉnh", content = dataTableOutput("tinhTable")),
                         list(menu = "Điểm thi THPT QG", content = dataTableOutput("data_rawTable"))
                       )))
 )