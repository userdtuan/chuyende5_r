tab_clustering <- tabItem(tabName = "clustering",
            h2("k-means"),
            fluidRow(
              column(width = 6,
                     box(width = 6,
                         title_side = "top left",
                         title = "Parameters",
                         solidHeader = TRUE,
                         status = "primary",
                         selectInput("xcol",
                                     "X",
                                     numericData,
                                     selected = numericData[[5]]),
                         selectInput("ycol",
                                     "Y",
                                     numericData,
                                     selected = numericData[[6]]),
                         sliderInput("clusters", "Number of clusters: ",
                                     min = 1, max = 8, value = 3)
                     ),
                     box(width = 6,
                         title_side = "top left",
                         title = "Center positions",
                         solidHeader = TRUE,
                         status = "primary",
                         verbatimTextOutput("clusters_info")
                     )),
              box(width = 10,
                  title = "Plot with clusters",
                  solidHeader = TRUE,
                  status = "primary",
                  plotOutput("plot1")
              )
            )
    )