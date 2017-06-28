#' Build a Crunchy UI
#'
#' Shiny provides page functions for defining UI layout. These
#' functions wraps those and includes additional assets needed to match
#' Crunch UI style and keep your users authenticated. When building shiny apps
#' with Crunch datasets, use these instead of [shiny::fluidPage()],
#' [shiny::fillPage()] or [shiny::navbarPage()].
#' @param title the title to be displayed in the navigation bar. Defaults to NULL.
#' @param ... arguments passed to `fluidPage`, `fillPage` or `navbarPage`
#' @return The result of `fluidPage`, `fillPage` or `navbarPage`
#' @export
#' @importFrom shiny fluidPage fillPage navbarPage includeCSS includeScript tags div
#' @examples
#' \dontrun{
#' crunchPage(
#'     fluidRow(
#'         column(6,
#'             selectInput("filter",
#'                 label="Filter",
#'                 choices=filterList,
#'                 selected="All"),
#'             br(),
#'             plotOutput("funnel1", height="300"),
#'         ),
#'         column(6,
#'             selectInput("brand",
#'                 label="Competitor",
#'                 choices=brands,
#'                 selected="Nike"),
#'             br(),
#'             plotOutput("funnel2", height="300"),
#'         )
#'     )
#' )
#' }
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

#' @rdname crunchPage
#' @export
crunchNavbarPage <- function(title = NULL, ...) {
  navbarPage(title = title,
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
