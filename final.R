source('functions/helper.R')
library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(DT)
library(knitr)
library(dplyr)
library(ECharts2Shiny)
library(plotly)

# Preprocessing danych
kq_thpt_raw <- read.csv("giua_ky/diemthi2020.csv")[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_mon_ngoai_ngu')]
list_tinh <- read.csv("giua_ky/listtinh.csv")
movies <- read.csv("movie_metadata.csv")[, c('movie_title', 'director_name', "budget","gross","country", "title_year", "imdb_score", "num_voted_users","color")
]
movies <- na.omit(movies)

numericData = c("budget","gross","title_year", "budget", "imdb_score", "num_voted_users")

kq_thpt_fixed <- handle_missing(kq_thpt_raw,-1)
kq_thpt_fixed <- gan_ten_tinh(kq_thpt_fixed,list_tinh)[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_ngoai_ngu', 'Ten.Tinh')]

############################################################################################################################################

# UI
sidebar <- dashboardSidebar(side = "left", size = "thin", color = "teal",
                            sidebarMenu(
                              menuItem(text = "Phổ điểm",
                                       tabName = "pho_diem",
                                       icon = icon("info circle")),
                              menuItem(text = "Thống kê",
                                       tabName = "histogram",
                                       icon = icon("chart bar")),
                              menuItem(text = "Dữ liệu đã xử lý",
                                       tabName = "fixed_data",
                                       icon = icon("table")),
                              menuItem(text = "Dữ liệu thô",
                                       tabName = "raw_datasets",
                                       icon = icon("table")),
                              menuItem(text = "Regression",
                                       tabName = "regression",
                                       icon = icon("chart line"))
                              # menuItem(text = "General",
                              #          tabName = "general",
                              #          icon = icon("info circle")),
                              # menuItem(text = "Info",
                              #          tabName = "info",
                              #          icon = icon("info circle")),
                              # menuItem(text = "Film database",
                              #          tabName = "database",
                              #          icon = icon("bars")),
                              # menuItem(text = "Histogram",
                              #          tabName = "hist",
                              #          icon = icon("chart bar")),
                              # menuItem(text = "Clustering",
                              #          tabName = "clustering",
                              #          icon = icon("asterisk")),
                              # menuItem(text = "Demo",
                              #          tabName = "demo",
                              #          icon = icon("chart line")),
                              # menuItem(text = "Raw Dataset",
                              #          tabName = "dataset_raw",
                              #          icon = icon("table"))
                            ))
source('tabs/tab_pho_diem.R')
source('tabs/tab_info.R')
source('tabs/tab_raw_datasets.R')
source('tabs/tab_database.R')
source('tabs/tab_hist.R')
source('tabs/tab_clustering.R')
source('tabs/tab_regression.R')
source('tabs/tab_demo.R')
source('tabs/tab_dataset_raw.R')
source('tabs/tab_general.R')
source('tabs/tab_fixed_data.R')
source('tabs/tab_pie_chart.R')
source('tabs/tab_histogram.R')
body <- dashboardBody(
  tabItems(
    tab_pho_diem,
    tab_histogram,
    tab_fixed_data,
    tab_raw_datasets,
    tab_regression
    # tab_pie_chart,
    # dataset_raw,
    # tab_info,
    # tab_database,
    # tab_hist,
    # tab_clustering,
    # tab_demo,
    # tab_general
  )
)

ui <- dashboardPage(
  theme = "spacelab",
  header = dashboardHeader(color = "blue"),
  sidebar = sidebar,
  body = body
)


server <- shinyServer(function(input, output) {
  
  # Regresja 
  output$regression_summary <- renderPrint({
    fit <- lm(movies[, input$ycol2] ~ movies[, input$xcol2])
    names(fit$coefficients) <- c("Intercept", input$var2)
    summary(fit)
  })
  
  selectedData3 <- reactive({
    movies[, c(input$xcol2, input$ycol2)]
  })
  output$scatterplot <- renderPlot({
    plot(selectedData3(),
         main = "Regression",
         xlab = input$xcol2,
         ylab = input$ycol2,
         pch = 19)
    abline(lm(movies[, input$ycol2] ~ movies[, input$xcol2]), col = "red")
    lines(lowess(movies[, input$xcol2], movies[, input$ycol2]), col = "blue")
    
  })
  #Raw dataset
  output$data_rawTable <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("SBD", "Ly", "Hoa", "Sinh",
                   "Dia", "Su", "GDCD",
                   "Toan", "Van", "Ngoai Ngu", "Ma Mon Ngoai Ngu"),
      
      filter = 'top',
      options = list(
        pageLength = 12, autoWidth = TRUE
      ),
      data <- kq_thpt_raw
    )
  )
  output$tinhTable <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("STT", "Ma Tinh", "Ten Tinh"),
      
      filter = 'top',
      options = list(
        pageLength = 12, autoWidth = TRUE
      ),
      data <- list_tinh
    )
  )
  # c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_ngoai_ngu', 'Ten.Tinh')]
  output$fixedData <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("SBD", "Ly", "Hoa", "Sinh",
                   "Dia", "Su", "GDCD",
                   "Toan", "Van", "Ngoai Ngu", "Mon Ngoai Ngu", "Tinh"),
      
      filter = 'top',
      options = list(
        pageLength = 12, autoWidth = TRUE
      ),
      data <- kq_thpt_fixed
    )
  )
  #----
  tb.tinh <- table(kq_thpt_fixed[names(kq_thpt_fixed)=="Ten.Tinh"])
  df.pie_tinh <- as.data.frame(tb.tinh)
  colnames(df.pie_tinh) <- c('name','value')
  
  output$phan_bo_theo_tinh <- renderPlotly({
    ggplot(data = df.pie_tinh, aes(x = reorder(name, -name), y = value
                                   ,text = after_stat(paste(
                                          "Tỉnh: ", df.pie_tinh[x,1],
                                          "<br>Count: ", df.pie_tinh[x,2]
    )))) +
      geom_bar(stat = 'identity',fill = "cornflowerblue", color = "black") +
      labs(
        title = "Số thí sinh phân bố theo tỉnh",
        x = "Tỉnh",
        y = "Số thí sinh"
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust=1))
    ggplotly(tooltip = "text")
  })
  output$tb_phan_bo_theo_tinh <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("Tên tỉnh", "Số lượng"),
      
      filter = 'top',
      options = list(
        pageLength = 10, autoWidth = TRUE
      ),
      data <- df.pie_tinh
    )
  )
  tb.ngoai_ngu <- table(kq_thpt_fixed[names(kq_thpt_fixed)=="Ma_ngoai_ngu"])
  df.ngoai_ngu <- as.data.frame(tb.ngoai_ngu)
  colnames(df.ngoai_ngu) <- c('name','value')
  df.ngoai_ngu <- subset(df.ngoai_ngu,name!='none' )
  output$tb_phan_bo_theo_ngoai_ngu <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("Ngoại ngữ", "Số lượng"),
      
      filter = 'top',
      options = list(
        pageLength = 10, autoWidth = TRUE
      ),
      data <- df.ngoai_ngu
    )
  )
  output$pie_ngoaingu <- renderPieChart(data = df.ngoai_ngu, div_id = "ngoai_ngu")
  
  df.khoithi <- tu_nhien_vs_xa_hoi(kq_thpt_fixed)
  output$tb_tnxh <- DT::renderDataTable(
    DT::datatable(
      rownames = FALSE,
      colnames = c("Khối thi", "Số lượng"),
      
      filter = 'top',
      options = list(
        pageLength = 10, autoWidth = TRUE
      ),
      data <- df.khoithi
    )
  )
  name <- c('Tự nhiên','Xã hội')
  value <- c(df.khoithi[1,1], df.khoithi[1,2])
  
  output$pie_khoithi <- renderPieChart(data = data.frame(name,value), div_id = "pie_khoithi")
  
  #---
  # reactiveMon <- reactiveValues()
  # reactiveMon$a <- 'Toan'
  # aes(
  #   x = .data[[input$bo]],
  #   text = after_stat(paste(
  #     "Category: ", categories()[x],
  #     "<br>Count: ", count
  #   ))
  # )
  tb_pho_diem <- reactive( {pho_diem(kq_thpt_fixed,input$mon)} )
  output$pho_diem <- renderPlotly({
    ggplot(data = tb_pho_diem(), aes(x = reorder(name, -name), y = value,
                                                         text = after_stat(paste(
                                                           "Grade: ", tb_pho_diem()[x,1],
                                                           "<br>Count: ", tb_pho_diem()[x,2]
                                                         )))) +
      geom_bar(stat = 'identity', fill = "cornflowerblue", color = "black") +
      labs(
        title = "Số thí sinh phân bố theo môn ",
        x = "Điểm ",
        y = "Số lượng"
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust=1))
    ggplotly(tooltip = "text")
  })
  
})
shinyApp(ui = ui, server = server)