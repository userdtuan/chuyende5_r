tab_regression <- tabItem(tabName = "regression",
            fluidRow(
              column(
                width = 7,
                box(title = "Plot",
                    title_side = "top left",
                    plotOutput("scatterplot")
                ),
                box(title = "Parameters",
                    title_side = "top left",
                    selectInput("xcol2",
                                label = h3("X"),
                                choices = numericData,
                                selected = numericData[[2]]
                    ),
                    selectInput("ycol2",
                                label = h3("Y"),
                                choices = numericData,
                                selected = numericData[[5]]
                    )
                )
              ),
              column(width = 8,
                     box(title = "Summary",
                         verbatimTextOutput("regression_summary")
                     )
              )
            )
    )