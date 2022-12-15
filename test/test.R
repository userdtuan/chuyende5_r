library(shiny)
library(plotly) 

ui <- fluidPage(
  plotlyOutput("plotb")
)

server <- function(input, output, session) {
  
  input <- list(bo = "class")
  
  dataset <- reactive({ mpg })
  
  categories <- reactive({ levels(factor(dataset()[[input$bo]])) })
  
  output$plotb <- renderPlotly({
    ggplot(data = dataset(), aes(
      x = .data[[input$bo]],
      text = after_stat(paste(
        "Category: ", categories()[x],
        "<br>Count: ", count
      ))
    )) +
      geom_bar(fill = "cornflowerblue", color = "black") +
      labs(
        title = sprintf("Bar chart of %s", input$bo),
        x = input$bo, y = "Frequency"
      ) +
      theme_light()
    
    ggplotly(tooltip = "text")
  })
}

shinyApp(ui, server)