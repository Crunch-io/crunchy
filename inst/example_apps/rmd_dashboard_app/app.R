library(crunchy)

ui <- fluidPage(
     uiOutput("dashboard")
)

server <- function(input, output, session) {
    user <- shinyUser()
    output$dashboard <- renderUI({
        if (is.character(user())) {
            h1(user())
        } else if (grepl("acme.com$", crunch:::email(user()))) {
            includeHTML("acme_dashboard.html")
        } else if (grepl("globex.com$", crunch:::email(user()))) {
            includeHTML("globex_dashboard.html")
        } 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)