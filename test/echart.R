library(shiny)
library(ECharts2Shiny)
library(dplyr)
source('functions/helper.R')
kq_thpt_raw <- read.csv("datasets/diemthi2020.csv")[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_mon_ngoai_ngu')]
list_tinh <- read.csv("datasets/listtinh.csv")
kq_thpt_fixed <- handle_missing(kq_thpt_raw,-1)
kq_thpt_fixed <- gan_ten_tinh(kq_thpt_fixed,list_tinh)[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_ngoai_ngu', 'Ten.Tinh')]
tb.tinh <- table(kq_thpt_fixed[names(kq_thpt_fixed)=="Ten.Tinh"])
df.pie_tinh <- as.data.frame(tb.tinh)
colnames(df.pie_tinh) <- c('name','value')

data <- data.frame(df.pie_tinh[,2])
names(data) <- c("value")
row.names(data) <- df.pie_tinh[,1]
# Prepare sample data for plotting --------------------------
dat <- data.frame(c(1, 2, 3, 1))
names(dat) <- c("Type-A")
row.names(dat) <- c("Time-1", "Time-2", "Time-3", "Time-4")

# Server function -------------------------------------------
server <- function(input, output) {
  # Call functions from ECharts2Shiny to render charts
  renderBarChart(div_id = "test", grid_left = '1%',direction = "vertical",
                 data = data)
}

# UI layout -------------------------------------------------
ui <- fluidPage(
  
  # We HAVE TO to load the ECharts javascript library in advance
  loadEChartsLibrary(),
  
  tags$div(id="test", style="width:100%;height:300px;"),
  deliverChart(div_id = "test")
)

# Run the application --------------------------------------
shinyApp(ui = ui, server = server)