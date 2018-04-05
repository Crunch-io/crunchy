#' Build a Crunchy UI
#'
#' Shiny provides page functions for defining UI layout. These
#' functions wraps those and includes additional assets needed to match
#' Crunch UI style and keep your users authenticated. When building shiny apps
#' with Crunch datasets, use these instead of [shiny::fluidPage()],
#' [shiny::fillPage()] or [shiny::navbarPage()].
#'
#' These are no longer necessary. Just use the `shiny` ones and it just works.
#' These functions are left here for backwards compatibility.
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
crunchPage <- function (...) fluidPage(...)

#' @rdname crunchPage
#' @export
crunchFluidPage <- crunchPage

#' @rdname crunchPage
#' @export
crunchFillPage <- function (...) fillPage(...)

#' @rdname crunchPage
#' @export
crunchNavbarPage <- function (...) navbarPage(...)
