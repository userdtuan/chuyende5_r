library(shiny)
library(shinycssloaders)

# Options for Spinner
options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)

ui <- fluidPage(
  fluidRow(
    column(width=12,
           withSpinner(tableOutput('tb'), type = 1)
    ))
)

server <- function(input, output,session) {
  
  output$tb <- renderTable({
    Sys.sleep(3) # system sleeping for 3 seconds for demo purpose
    iris[1:5,]
  })
}

shinyApp(ui, server)