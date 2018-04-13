library(crunchy)
library(shiny)

create_dashboard <- function (){
    ds <- mtcars
    ui <- crunchFluidPage(
        column( width = 4, 
            fluidRow(
                selectInput("var_name", "Variable Name", choices = names(ds))
            )
        ),
        column(width = 8, 
            fluidRow(
                plotOutput("var_plot")
            ),
            fluidRow(
                dataTableOutput("dt")
            )
        )
    )
    server <- function (input, output, session) {
        vect <- reactive({
            as.vector(ds[[input$var_name]])
                })
        output$var_plot <- renderPlot({
            plot(vect(), ylab = input$var_name)
        })
        output$dt <- renderDataTable({
            print(vect())
            out <- as.data.frame(vect())
            names(out) <- input$var_name
            out
        })
    }
    shinyApp(ui, server)
}
create_dashboard()
