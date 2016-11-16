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
        loadCrunchAssets(),
        crunchAuthPlaceholder(),
        ...
    )
}

#' @rdname crunchPage
#' @export
crunchFluidPage <- crunchPage

#' @rdname crunchPage
#' @export
crunchFillPage <- function (...) {
    fillPage(
        loadCrunchAssets(),
        crunchAuthPlaceholder(),
        ...
    )
}

#' @importFrom shiny includeCSS includeScript tags
loadCrunchAssets <- function () {
    tags$head(
        tags$link(rel="stylesheet", type="text/css",
            href="https://app.crunch.io/styles.css"),
        includeCSS(system.file("extra.css", package="crunchy")),
        includeScript(system.file("extra.js", package="crunchy"))
    )
}

#' @importFrom shiny div
crunchAuthPlaceholder <- function () {
    div(class = "form-group shiny-input-container",
        style = "display: none;",
        tags$input(id = "token", type = "text", class = "form-control", value = ""))
}
