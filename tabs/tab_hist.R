tab_hist <- tabItem(tabName = "hist",
            box(width = 6, title_side = "top left",
                title = "Parameters",
                selectInput(inputId = "choice_input",
                            label = "Column name:",
                            choices = numericData,
                            selected = numericData[[2]]
                ),
                sliderInput(inputId = "bins",
                            label = "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30
                )
            ),
            box(title = "Histogram",
                width = 10,
                plotOutput("hist1")
            )
    )