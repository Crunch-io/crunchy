#' Display progress from Crunch API processes
#'
#' Some potentially large operations, such as imports and exports, report
#' progress in the Crunch API. In an interactive R session, they print a text
#' progress bar. This context, which wraps [shiny::withProgress()], reports that
#' Crunch API progress up to the Shiny web app.
#'
#' @param expr Code to evaluate
#' @param ... Additional arguments passed to [shiny::withProgress()]
#' @return The result of `expr`
#' @export
#' @importFrom shiny setProgress withProgress
#' @examples
#' \dontrun{
#' withCrunchyProgress(
#'     ds <- newDataset(df),
#'     message = "Importing..."
#' )
#' }
withCrunchyProgress <- function(expr, ...) {
    tracer <- quote({
        setup_progress_bar <- function (...) NULL
        update_progress_bar <- function (p, value) {
            setProgress(value, message=NULL)
        }
        close <- function (...) NULL
    })
    trace("pollProgress", tracer=tracer, where=crGET)
    on.exit(untrace("pollProgress", where=crGET))
    withProgress(expr, min=0, max=100, value=0, ...)
}
