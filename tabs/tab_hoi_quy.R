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
                     box(title = "Summary",
                     withSpinner(verbatimTextOutput("hoiquy2_summary"), type = 1)
                     )
              )
              ,
              column(width = 16,
                     box(title = "Summary",
                     withSpinner(verbatimTextOutput("forw"), type = 1),
                    # withSpinner( verbatimTextOutput("backw"), type = 1),
                    # withSpinner( verbatimTextOutput("bth"), type = 1),
                    withSpinner( verbatimTextOutput("ranking"), type = 1)
                     )
              )
            )
    )