#' Load a dataset for a Shiny session
#'
#' This function wraps [crunch::loadDataset()] in a
#' [shiny::reactive()] object for use in a Shiny app. It also ensures
#' that the current user is authenticated with Crunch before proceeding.
#' @param ... Arguments passed to `loadDataset`
#' @return A Shiny `reactive` object.
#' @export
#' @importFrom crunch tokenAuth
shinyDataset <- function (...) {
    env <- parent.frame()
    expr <- .shinyDatasetExpr(...)
    e <- substitute(reactive(expr, env=env))
    return(eval(e, envir=env))
}

.shinyDatasetExpr <- function (...) {
    ## Assembles the expression that goes into the `reactive` object
    Call <- match.call(expand.dots=TRUE)
    Call[[1]] <- as.name('loadDataset')
    expr <- eval(substitute(quote({
        tokenAuth(input$token, "shiny.crunch.io")
        Call
    })))
    return(expr)
}
