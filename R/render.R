#' Wrapper around shiny's renderPlot for better error handling
#'
#' @param expr expression that renders a plot
#' @param ... additional arguments passed to \code{\link[shiny]{renderPlot}}
#' @return Same as \code{renderPlot}, but if \code{expr} errors when evaluated,
#' instead of printing a red R error message in your app, you get a more
#' user-friendly placeholder.
#' @export
renderPlot <- function (expr, ...) {
    shiny::renderPlot(tryCatch(expr, error=function (e) {
        ## Render a "plot" that is a nicer error message, not a red R traceback
        plot(0, 0, axes=FALSE, xlab="", ylab="", pch="")
        text(0, 0, ":(")
    }), ...)
}
