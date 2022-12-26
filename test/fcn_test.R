# Load the shiny library
library(shiny)

# Define the UI for the app
ui <- fluidPage(
  # Use the row function to create a row for the input fields
  row(
    # Use the column function to create four equal-sized columns
    column(width = 3,
           # Add the first text input field
           textInput("input_text_1", "Enter text 1:", value = "")
    ),
    column(width = 3,
           # Add the second text input field
           textInput("input_text_2", "Enter text 2:", value = "")
    ),
    column(width = 3,
           # Add the third text input field
           textInput("input_text_3", "Enter text 3:", value = "")
    ),
    column(width = 3,
           # Add the fourth text input field
           textInput("input_text_4", "Enter text 4:", value = "")
    )
  )
)

# Define the server for the app
server <- function(input, output) {
  # No server logic is needed for this simple example
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
