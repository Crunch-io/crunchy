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
shinyDataset <- function (...) .buildReactiveExpr('loadDataset', ...)

.buildReactiveExpr <- function (FUN, ...) {
    cal <- match.call(expand.dots=TRUE)[-1]
    cal[[1]] <- as.name(cal[[1]])
    expr <- eval(substitute(quote({
        tokenAuth(input$token, "shiny.crunch.io")
        cal
    })))

    env <- parent.frame(2)
    e <- substitute(reactive(expr, env=env))
    return(eval(e, envir=env))
}
