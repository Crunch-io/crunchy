if (Sys.getenv('ENVIRONMENT_ROLE') == 'LOCAL') {
    api_url_host <- gsub("https?://", "", crunch::envOrOption('crunch.api'))
    dev_mode <- list(
        api_key = crunch::envOrOption('crunch.api.key'),
        domain = extract_domain(api_url_host),
        subdomain = extract_subdomain(api_url_host)
    )
} else {
    dev_mode <- list()
}

ui <- crunchy_page_navbar(title = "Demo")

server <- function(input, output, session) {
    auth <- crunchy_page_navbar_server(
        dev_mode = dev_mode,
        restrict_to = list(email_like = "@"),
        bslib::nav_panel(
            "Explanation & Pointers",
            tags$div(class = 'container', htmltools::includeMarkdown(
                system.file('demo_auth/explanation.md', package = 'crunchy')
            )),
        ),
        bslib::nav_panel(
            "Usage",
            uiOutput("main_panel")
        ),
        bslib::nav_panel(
            "Debug",
            fluidRow(
                tags$p("Debugging Info"),
                tags$h2("auth module info"),
                verbatimTextOutput("auth_module_info"),
                tags$h2("shiny request"),
                verbatimTextOutput("session_request"),
                tags$h2("shiny clientData"),
                verbatimTextOutput("shiny_client_data")
            )
        )
    )

    output$main_panel <- shiny::renderUI({
        fluidRow(
            column(
                3,
                textInput('ds_id', 'Dataset id'),
                actionButton('load_ds', 'Load Dataset'),
                selectizeInput('var_alias', 'Variable', choices = c('<DATASET NOT FOUND>' = '')),
                actionButton('tabulate', 'Tabulate'),
                uiOutput("download_container")
            ),
            column(
                9,
                verbatimTextOutput('results')
            )
        )
    })

    ds_rx <- reactiveVal()
    var_options_rx <- reactiveVal()

    observeEvent(input$load_ds, {
        with_temp_auth(auth, {
            ds <- try(crunch::loadDataset(input$ds_id, project = NULL), silent = TRUE)

            if (inherits(ds, 'try-error')) {
                ds_rx(NULL)
                var_options_rx(setNames('', sprintf('Could not find dataset "%s"', input$ds_id)))
            } else {
                ds_rx(ds)
                vars <- crunch::allVariables(ds)
                var_options_rx(setNames(crunch::aliases(vars), names(vars)))
            }
        })
    })

    observeEvent(
        var_options_rx(),
        updateSelectizeInput(inputId = 'var_alias', choices = var_options_rx(), server = TRUE)
    )

    output$results <- renderPrint({
        with_temp_auth(auth, {
            req(ds_rx(), input$var_alias)

            table(as.vector(ds_rx()[[input$var_alias]]))
        })
    }) |> bindEvent(input$tabulate)


    output$auth_module_info <- renderText({
        lapply(auth, function(x) {
            if (is.reactive(x)) x() else x
        }) |>
            str(give.head = FALSE, width = 80, strict.width = 'wrap') |>
            capture.output() |>
            paste0(collapse = "\n")
    })

    output$download_container <- renderUI({
        shiny::downloadButton("download", "Download variable list")
    })

    output$download <- shiny::downloadHandler("variables.txt", content = function(file) {
        writeLines(var_options_rx(), file)

    })

    output$session_request <- renderText({
        session$request |>
            as.list() |>
            str(give.head = FALSE, width = 80, strict.width = 'wrap') |>
            capture.output() |>
            paste0(collapse = "\n")
    })

    output$shiny_client_data <- renderText({
        session$clientData |>
            shiny::reactiveValuesToList() |>
            str(give.head = FALSE, width = 80, strict.width = 'wrap') |>
            capture.output() |>
            paste0(collapse = "\n")
    })
}

shiny::shinyApp(ui = ui, server = server)
