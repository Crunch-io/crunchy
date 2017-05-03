#' Build a Crunchy UI
#'
#' Shiny provides page functions for defining UI layout. These
#' functions wraps those and includes additional assets needed to match
#' Crunch UI style and keep your users authenticated. When building shiny apps
#' with Crunch datasets, use these instead of [shiny::fluidPage()] or
#' [shiny::fillPage()].
#' @param ... arguments passed to `fluidPage` or `fillPage`
#' @return The result of `fluidPage` or `fillPage`
#' @export
#' @importFrom shiny fluidPage fillPage includeCSS includeScript tags div
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
