#' Build a Crunchy UI
#'
#' Shiny provides a \code{\link[shiny]{fluidPage}} for defining UI layout. This
#' function wraps that one and includes additional assets needed to match
#' Crunch UI style and keep your users authenticated. When building shiny apps
#' with Crunch datasets, use this instead of \code{fluidPage}.
#' @param ... arguments passed to \code{fluidPage}
#' @return The result of \code{fluidPage}
#' @export
#' @importFrom shiny fluidPage includeCSS includeScript tags div
crunchPage <- function (...) {
    fluidPage(
        tags$head(
            ## Need a stable css link
            # tags$link(rel="stylesheet", type="text/css",
            #     href="https://beta.crunch.io/whaam-2.2.3-rc-3392-b218bc2/styles.css"),
            includeCSS(system.file("extra.css", package="crunchy")),
            includeScript(system.file("extra.js", package="crunchy"))
        ),
        div(class = "form-group shiny-input-container",
            style = "display: none;",
            tags$input(id = "token", type = "text", class = "form-control", value = "")),
        ...
    )
}
