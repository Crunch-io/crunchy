#' Launch array builder gadget
#'
#' Categorical Array and Multiple Response variables can be difficult to
#' construct without being able to investigate the available variables, and
#' their categories. This shiny gadget lets you select subvariables from the
#' dataset list, and ensures that those variables have consistent categories. To
#' use the gadget you must have at least one CrunchDataset loaded into the global
#' environment.
#'
#' @return a valid call to `makeArray()` or `makeMR()`
#' @param env the environment to run the gadget
#' @importFrom shiny runGadget dialogViewer
#' @export
makeArrayGadget <- function (env = globalenv()) {
    runGadget(app = .makeArrayGadget(env),
        viewer = dialogViewer("Array Builder", width = 800)
    )
}

#' @importFrom crunch aliases crGET variables is.Categorical
#' @importFrom miniUI gadgetTitleBar miniPage miniContentPanel miniTabPanel
#' miniTabstripPanel
#' @importFrom shiny actionButton br checkboxGroupInput column fluidRow h3 HTML
#'   isolate observe observeEvent radioButtons reactive reactiveValues renderUI
#'   req selectInput shinyApp stopApp tags textInput uiOutput uiOutput
#'   updateCheckboxGroupInput
.makeArrayGadget <- function (env) {
    crGET(getOption("crunch.api")) # check login status
    dataset_list <- getCrunchDatasets(env)
    ui <- miniPage(
        tags$head(
            tags$style(HTML("
                 .multicol {
                   -webkit-column-count: 3; /* Chrome, Safari, Opera */
                   -moz-column-count: 3; /* Firefox */
                   column-count: 3;
                 }
               "
            )
            )
        ),
        miniTabstripPanel(id = "tabstrip",
            miniTabPanel(id = "var_select",
                title = "Select Subvariables",
                icon = shiny::icon("check-square"),
                gadgetTitleBar("Select SubVariables",
                    right = NULL,
                    left = NULL),
                miniContentPanel(
                    fluidRow(
                        column(width = 4,
                            selectInput("dataset",
                                "Select Dataset",
                                choices = names(dataset_list)
                            )
                        ),
                        column(width = 4,
                            textInput("search", "Search")
                        )
                    ),
                    h3("Select Subvariables"),
                    fluidRow(style = "margin-bottom: 25px; margin-top: 25px;",
                        column(width = 4,
                            actionButton("select_all", "Select All")
                        ),
                        column(width = 4,
                            actionButton("clear_all", "Clear")
                        )
                    ),
                    fluidRow(
                        tags$div(class = "multicol",
                            column(width = 12,
                                uiOutput("variables")
                            )
                        )
                    )
                )
            ),
            miniTabPanel(id = "builder",
                title = "Build Array Variable",
                icon = shiny::icon("edit"),
                gadgetTitleBar("Build Variable"),
                miniContentPanel(
                    textInput("obj_name", "Object Name (Optional)"),
                    textInput("var_name", "Variable Name"),
                    br(),
                    radioButtons("array_type", "Variable Type",
                        choices = c("Categorical Array", "Multiple Response")),
                    br(),
                    uiOutput("select_categories")
                )
            )
        )
    )

    server <- function (input, output, session) {
        ds <- reactive(dataset_list[[req(input$dataset)]])
        vars <- reactive ({
            aliases(variables(ds()))[vapply(ds(), is.Categorical, FUN.VALUE = logical(1))]
        })
        var_subset <- reactive(
            vars()[grep(input$search, vars())]
        )

        # We need to keep track of which values have been selected even when the
        # variables which can be selected change because of the search bar. This
        # observer creates a list which keeps track of whatever has been
        # selected or intentionally deseledcted.
        values <- reactiveValues(currently_selected = character(0))
        observe({
            values$currently_selected <- union(
                isolate(
                    values$currently_selected[!(values$currently_selected %in% var_subset())]
                ),
                input$selected_vars
            )
        })
        observeEvent(input$select_all,
            updateCheckboxGroupInput(session, "selected_vars", selected = var_subset())
        )
        observeEvent(input$clear_all,
            updateCheckboxGroupInput(session, "selected_vars", selected = "")
        )

        output$variables <- renderUI({
            checkboxGroupInput("selected_vars",
                NULL,
                choices = var_subset(),
                selected =  isolate(values$currently_selected)
            )
        })

        output$select_categories <- renderUI({
            generateCategoryCheckboxes(ds(),
                values$currently_selected,
                input$array_type
            )
        })

        observeEvent(input$done, {
            code <- buildArrayCall(
                input$dataset,
                input$array_type,
                input$obj_name,
                input$var_name,
                values$currently_selected,
                input$mr_selection
            )
            stopApp(returnValue = rstudioapi::insertText(text = code,
                id = rstudioapi::getActiveDocumentContext()$id))
        })
    }
    return(shinyApp(ui, server))
}

#' @importFrom crunch categories
#' @importFrom shiny p
generateCategoryCheckboxes <- function (ds, selected_vars, array_type) {
    if (length(selected_vars) == 0) {
        p("Error: No variables selected.",
            style = "color:red")
    } else if (array_type == "Multiple Response") {
        cats <- lapply(selected_vars, function(x) {
            names(categories(ds[[x]]))
        })
        mr_options <- Reduce(intersect, cats)

        if (length(mr_options) == 0) {
            p("Error: selected variables have no common categories.",
                style = "color:red")
        } else {
            checkboxGroupInput("mr_selection",
                "Selection Categories",
                choices = mr_options
            )
        }
    }
}

buildArrayCall <- function (ds_name,
    array_type,
    object_name = "",
    array_var_name,
    vars_selected,
    mr_selection) {
    if (array_type == "Multiple Response") {
        f <- 'makeMR('
        sel <- paste0(", ", "selections = ", asCharVector(mr_selection))
    } else {
        f <- 'makeArray('
        sel <- ''
    }

    if (object_name != "") {
        assign <- paste0(object_name, " <- ")
    } else {
        assign <- ""
    }

    call <- paste0(
        assign,
        f,
        ds_name,
        "[ ,", asCharVector(vars_selected), "], ",
        "name = '", array_var_name, "'",
        sel,
        ")")
    return(call)
}

asCharVector <- function (v) {
    paste0("c(",
        paste0(paste0("'", v, "'"), collapse = ", "),
        ")")
}

#' @importFrom httpcache halt
#' @importFrom crunch is.dataset
getCrunchDatasets <- function (env) {
    l <- ls(envir = env)
    out <- lapply(l, function(x) get(x, envir = env))
    names(out) <- l
    out <- out[vapply(out, is.dataset, FUN.VALUE = logical(1))]
    if (length(out) == 0) {
        halt("No CrunchDatasets detected.")
    }
    return(out)
}
