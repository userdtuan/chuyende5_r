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
fluidRow(
  column(width = 4,
           # Add the first text input field
           numericInput("mon_1", "Nhập điểm Lý:", value = hoiquy_dat$Li[1])
    ),
    column(width = 4,
           # Add the second text input field
           numericInput("mon_2", "Nhập điểm Hoá:", value = hoiquy_dat$Hoa[1])
    ),
    column(width = 4,
           # Add the third text input field
           numericInput("mon_3", "Nhập điểm Sinh:", value = hoiquy_dat$Sinh[1])
    ),
    column(width = 4,
           # Add the fourth text input field
           numericInput("mon_4", "Nhập điểm Sử:", value = hoiquy_dat$Su[1])
    ),
    column(width = 4,
           # Add the first text input field
           numericInput("mon_5", "Nhập điểm Địa:", value = hoiquy_dat$Dia[1])
    ),
    column(width = 4,
           # Add the second text input field
           numericInput("mon_6", "Nhập điểm GDCD:", value = hoiquy_dat$GDCD[1])
    ),
    column(width = 4,
           # Add the third text input field
           numericInput("mon_7", "Nhập điểm Văn:", value = hoiquy_dat$Van[1])
    ),
    column(width = 4,
           # Add the fourth text input field
           numericInput("mon_8", "Nhập điểm Ngoại Ngữ:", value = hoiquy_dat$Ngoai_ngu[1]),
    ),
    column(width = 10,
           # Add the fourth text input field
           actionButton("predict", "Dự đoán điểm Toán"),
    ),
    column(width = 10,
           # Add the fourth text input field
           textOutput("predict_toan")
    )
)
    )