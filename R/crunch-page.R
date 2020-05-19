#' Build a Crunchy UI
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

#' @importFrom shiny div includeCSS includeScript tags
injectCrunchAssets <- function () {
    suppressMessages(
        trace(
            "bootstrapPage",
            where=shiny::fillPage,
            tracer=crunchAssets,
            print=FALSE
        )
    )
}

crunchAssets <- quote({
    attachDependencies <- function (x, ...) {
        # Prepend a bit of HTML before whatever the user supplied but after
        # the global things--as if these were the first things in the user's
        # list
        x[[length(x)]] <- c(
            list(
                # Load Crunch assets
                tags$head(
                    # tags$link(
                    #     rel="stylesheet",
                    #     type="text/css",
                    #     href="https://app.crunch.io/styles.css"
                    # ),
                    includeCSS(system.file("extra.css", package="crunchy")),
                    includeScript(system.file("extra.js", package="crunchy"))
                ),
                # Add a placeholder for Crunch auth
                div(
                    class = "form-group shiny-input-container",
                    style = "display: none;",
                    tags$input(
                        id = "token",
                        type = "text",
                        class = "form-control",
                        value = ""
                    )
                )
            ),
            x[[length(x)]]
        )
        htmltools::attachDependencies(x, ...)
    }
})
