
library(shiny)
library(crunchy)
# Render the dashboard
#rmarkdown::render("dashboard.Rmd")
ui <- fluidPage(
    uiOutput("dashboard")
)

server <- function(input, output, session) {
    user <- getUser()
    output$dashboard <- renderUI({
        if (grepl("acme.com$", user()$email)) {
            includeHTML("acme_dashboard.html")
        } else {
            includeHTML("globex_dashboard.html")
        }
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

