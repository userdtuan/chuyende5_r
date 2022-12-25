tab_hoi_quy <- tabItem(tabName = "hoi_quy",
fluidRow(
              column(
                width = 7,
                box(title = "Plot",
                    title_side = "top left",
                    withSpinner(plotOutput("hoiquy2_bieudo"), type = 1)
                ),
                box(title = "Parameters",
                    title_side = "top left",
                    selectInput("bien_x",
                                label = h3("X"),
                                choices = numericData,
                                selected = numericData[[1]]
                    ),
                    selectInput("bien_y",
                                label = h3("Y"),
                                choices = numericData,
                                selected = numericData[[2]]
                    ),
                    textOutput("value"),
                    actionButton("apply", "Thực hiện")
                )
              ),
              column(width = 8,
                     box(title = "Two Value Summary",
                     withSpinner(verbatimTextOutput("hoiquy2_summary"), type = 1)
                     )
              )
              ,
              column(width = 16,
                     box(title = "Stepwise Regression",
                     titlePanel("Ranking"),
                     withSpinner(verbatimTextOutput("ranking"), type = 1),
                     titlePanel("Forward Stepwise Selection"),
                     withSpinner(verbatimTextOutput("forw"), type = 1),
                     titlePanel("Backward Stepwise Selection"),
                     withSpinner(verbatimTextOutput("backw"), type = 1),
                     titlePanel("Both Stepwise Selection"),
                     withSpinner(verbatimTextOutput("bothw"), type = 1),
                     )
              ),
            ),
box(title = "Dự đoán",
                width = 16,
                color = "blue",
                selectInput(inputId =  "hoiquy_choose", choices = c('Forward','Backward','Both','Multi'),
                                label = "Chọn mô hình", selected = "Forward"),
                                textOutput("test_hoiquy"),
                withSpinner(DT::dataTableOutput("tb_after_predict")),
                ),
    )