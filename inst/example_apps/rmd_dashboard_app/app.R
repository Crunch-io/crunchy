
library(shiny)
library(crunchy)
# Render the dashboard
rmarkdown::render("dashboard.Rmd")
ui <- fluidPage(
    includeHTML("dashboard.html")
)

server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

