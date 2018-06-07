library(crunchy)

ui <- fluidPage(
    actionButton('refresh', 'Refresh Dashboard'),
    textOutput("last_render"),
    uiOutput("dashboard")
)

server <- function (input, output, session) {
    file <- reactivePoll(1000, session,
        checkFunc = function () {
            file.info("acme_dashboard.html")$ctime
        },
        valueFunc = function () {
            list(
                path = "acme_dashboard.html",
                time = Sys.time()
            )
        }
    )
    user <- shinyUser()
    observeEvent(input$refresh, rmarkdown::render("acme_dashboard.Rmd"))
    output$last_render <- renderText(paste("Last Render:", file()$time))
    output$dashboard <- renderUI({
        user()
        includeHTML(file()$path)
    })
}

shinyApp(ui = ui, server = server)
