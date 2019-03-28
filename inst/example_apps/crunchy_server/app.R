library(crunchy)
library(crplyr)
library(plotly)

ui <- fluidPage(
    crunchyBody(
        h1(textOutput("dsname")),
        uiOutput("variables"),
        plotlyOutput("plot")
    )
)

server <- crunchyServer(function (input, output, session) {
    ds <- loadDataset("https://app.crunch.io/api/datasets/YOUR_DATASET_ID/")
    output$dsname <- renderText(name(ds))
    # crplyr::autplot() doesn't support text variables
    plottable_vars <- names(ds)[types(variables(ds)) != "text"]
    output$variables <- renderUI({
        selectInput("variable", "Variable", plottable_vars, selected=plottable_vars[1])
    })
    output$plot <- renderPlotly(autoplot(ds[[input$variable]]))
})

shinyApp(ui = ui, server = server)
