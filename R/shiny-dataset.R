#' Load a dataset for a Shiny session
#'
#' This function wraps [crunch::loadDataset()] in a
#' [shiny::reactive()] object for use in a Shiny app. It also ensures
#' that the current user is authenticated with Crunch before proceeding.
#' @param ... Arguments passed to `loadDataset`
#' @return A Shiny `reactive` object.
#' @export
#' @importFrom crunch tokenAuth
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'     ds <- shinyDataset("Your dataset name")
#'
#'     freqs <- reactive({
#'         fmla <- as.formula(paste("~", input$varname))
#'         crtabs(fmla, data=ds())
#'     })
#' })
#' }
shinyDataset <- function (...) {
    env <- parent.frame()
    call <- match.call(expand.dots=TRUE)
    expr <- .buildReactiveExpr('loadDataset', call)
    e <- substitute(reactive(expr, env=env))
    return(eval(e, envir=env))
}

.buildReactiveExpr <- function(f, call) {
    call[[1]] <- as.name(f)
    expr <- eval(substitute(quote({
        tokenAuth(input$token, "shiny.crunch.io")
        call
    })))
    return(expr)
}

