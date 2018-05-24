library(crunchy)

ui <- sidebarLayout(
         sidebarPanel(
             actionButton('refresh', 'Refresh Dashboard'),
             textOutput("last_render")
         ),
    mainPanel(
             uiOutput("dashboard")
    )
)

server <- function(input, output, session) {
    file <- reactivePoll(1000, session,
        checkFunc = function() {
            file.info("acme_dashboard.html")$ctime
            }, 
        valueFunc = function() {
            list(path = "acme_dashboard.html",
                time = Sys.time()
                )
            })
    observeEvent(input$refresh, rmarkdown::render("acme_dashboard.Rmd"))
    output$last_render <- renderText(paste("Last Render:", file()$time))
    output$dashboard <- renderUI({
        if (inherits(shinyUser(), "UserEntity")){
            includeHTML(file()$path)
        }
    })
}

shinyApp(ui = ui, server = server)