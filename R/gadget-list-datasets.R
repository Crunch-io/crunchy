#' Open dataset selector
#'
#' @param ... Further arguments passed to `crunch::listDatasets()`
#' @importFrom crunch listDatasets projects
#' @importFrom shiny column observeEvent selectInput stopApp runGadget textInput uiOutput
#' @importFrom miniUI gadgetTitleBar miniContentPanel
#' @importFrom rstudioapi insertText getActiveDocumentContext verifyAvailable
#' @return A `loadDataset()` call is pasted into your RStudio session
#' @export
#' @keywords internal
listDatasetGadget <- function (...){
    rstudioapi::verifyAvailable("0.99.878")

    projects <- c("Personal Project", names(projects()))
    personal_datasets <- listDatasets(...)

    ui <- miniPage(
        gadgetTitleBar("Select Dataset"),
        miniContentPanel(
            column(width = 3,
                selectInput("project",
                    "Select Project",
                    projects)),
            column(width = 3,
                uiOutput("dataset")
            ),
            column(width = 3,
                textInput("ds_name", "Object Name (Optional)")
            )
        )
    )

    server <- function (input, output, session) {
        output$dataset <- shiny::renderUI({
            if (input$project == "Personal Project") {
                selections <- personal_datasets
            } else {
                selections <- listDatasets(...)
            }
            selectInput("dataset",
                "Select Dataset",
                selections)
        })
        observeEvent(input$done, {
            code <- buildLoadDatasetCall(project = input$project,
                dataset = input$dataset,
                ds_name = input$ds_name)
           stopApp(returnValue = insertText(text = code,
               id = getActiveDocumentContext()$id))
        })
    }
    runGadget(ui, server)
}

buildLoadDatasetCall <- function (project, dataset, ds_name = "") {
    dataset <- escapeQuotes(dataset)
    assignment <- ifelse(nchar(ds_name) > 0,
        paste0(ds_name, " <- "),
        "")
    if (project == "Personal Project") {
        code <- paste0(assignment, "loadDataset('", dataset,"')")
    } else {
        code <- paste0(assignment, "loadDataset('",
            dataset,
            "', project = '",
            escapeQuotes(project), "')" )
    }
    return(code)
}

escapeQuotes <- function(str) {
    gsub("'", "\\\\'", str)
}
