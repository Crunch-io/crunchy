library(crunchy)

ui <- fluidPage(
     uiOutput("dashboard")
)

server <- function(input, output, session) {
    user <- shinyUser()
    output$dashboard <- renderUI({
        ## TODO: email isn't exported? Let's fix that; ::: is no good.
        current_user <- crunch:::email(user())
        if (grepl("acme.com$", current_user)) {
            includeHTML("acme_dashboard.html")
        } else if (grepl("globex.com$", current_user)) {
            includeHTML("globex_dashboard.html")
        } else {
            ## TODO: something else?
        }
    })
}

# Run the application
shinyApp(ui = ui, server = server)
