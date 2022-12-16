tab_histogram <- tabItem(tabName = "histogram",
box(title = "Phân bố theo tỉnh",
                width = 16,
                color = "blue",
                withSpinner( plotlyOutput("phan_bo_theo_tinh"), type = 1)
                ),
tabBox(color = "red", width = 5, height = 7, title = "Bảng thống kê",
                       tabs = list(
                         list(menu = "theo tỉnh", content = withSpinner(dataTableOutput("tb_phan_bo_theo_tinh"), type = 1)),
                         list(menu = "theo ngôn ngữ", content = withSpinner(dataTableOutput("tb_phan_bo_theo_ngoai_ngu"), type = 1))
                       )),
box(title = "Biểu đồ phân bố theo ngôn ngữ",
                width = 6,
                color = "blue",
                     loadEChartsLibrary(),
                     tags$div(id = "ngoai_ngu", style = "width:100%;height:400px;"),
                    deliverChart(div_id = "ngoai_ngu")
            ),
box(title = "Biểu đồ phân bố theo khối thi",
                width = 5,
                color = "blue",
                     loadEChartsLibrary(),
                     tags$div(id = "pie_khoithi", style = "width:100%;height:400px;"),
                    deliverChart(div_id = "pie_khoithi")
            )
        )
