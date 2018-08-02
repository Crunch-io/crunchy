# Vignette outline:
# Simple version: use crunchyServer instead of shinyServer, and wrap your UI
# body that you want protected by auth inside of crunchyBody
#
# Options:
# * Specify a different "unauthenticated" page with crunchyPublicBody in your UI,
# after you specify crunchyBody
# * Add authorization requirements so that you require more than just being logged
# into crunch. Either specify an expression in the `authz` arg to crunchyServer,
# or setCrunchyAuthorization() outside of the server function
# * Add a different "unauthorized" page with crunchyUnauthorizedBody in your UI




#' A Shiny UI with Crunch auth
#'
#' When using [crunchyServer()] to wrap your app in Crunch authentication and
#' authorization, you need to wrap your UI body content inside `crunchyBody()`.
#'
#' This is the part that is conditionally rendered if the user is allowed.
#' Any UI elements you want always to show, including `<head>` tags, should go
#' outside this function.
#' @param ... UI elements for your app
#' @return A `uiOutput()` container into which `crunchyServer()` will
#' conditionally render output.
#' @export
#' @examples
#' \dontrun{
#' shinyUI(fluidPage(
#'     tags$head(
#'         # This is content that will always be rendered
#'         tags$title("My secure app")
#'     ),
#'     crunchyBody(
#'         # This is content that only is rendered if the user is authorized
#'         fluidRow(
#'             column(6, h1("Column 1")),
#'             column(6, h1("Column 2"))
#'         )
#'     )
#' ))
#' }
crunchyBody <- function (...) {
    # This is called inside a UI function. It captures the body content you
    # request, stores it for lazy calling inside crunchyServer(), then returns
    # the div that crunchyServer() will write into
    crunchUIOutput(...)
    uiOutput("crunch_body")
}

#' Alternate UIs for unauthenticated and unauthorized users
#'
#' [crunchyServer()] and [crunchyBody()] allow you to protect your app with
#' Crunch authentication and authorization. Add these UI contents to your
#' [shiny::shinyUI()] body to display different content for visitors who are
#' not authenticated with Crunch (`crunchyPublicBody()`) or who are
#' authenticated but not authorized to access your app
#' (`crunchyUnauthorizedBody`).
#' @param ... UI elements for your app, to be conditionally rendered
#' @return An empty string; these functions are called for their side effects of
#' registering the UI elements so that `crunchyServer()` can render them as
#' appropriate.
#' @export
#' @seealso [setCrunchyAuthorization()] for governing who is authorized to view
#' your app
#' @examples
#' \dontrun{
#' # This is the example from crunchyBody(), adding these alternate bodies:
#' shinyUI(fluidPage(
#'     tags$head(
#'         # This is content that will always be rendered
#'         tags$title("My secure app")
#'     ),
#'     crunchyBody(
#'         # This is content that only is rendered if the user is authorized
#'         fluidRow(
#'             column(6, h1("Column 1")),
#'             column(6, h1("Column 2"))
#'         )
#'     ),
#'     crunchyPublicBody(
#'         # This is shown to visitors who are not logged into Crunch at all
#'         h1("Please log into Crunch.")
#'     ),
#'     crunchyUnauthorizedBody(
#'         # This is for Crunch users who don't meet your authorization criteria
#'         # Perhaps they don't have access to a particular dataset
#'         h1("You don't have access to this app."),
#'         tags$div("Contact your_admin@example.com.")
#'     )
#' ))
#' }
crunchyPublicBody <- function (...) {
    crunchPublicUIOutput(...)
    return("")
}

#' @rdname crunchyPublicBody
#' @export
crunchyUnauthorizedBody <- function (...) {
    crunchUnauthorizedUIOutput(...)
    return("")
}



crunchUIOutput <- function (...) {
    ui <- lazyUIOutput(...)
    options(crunchy.body=ui)
    ui
}

crunchPublicUIOutput <- function (...) {
    ui <- lazyUIOutput(...)
    options(crunchy.body.public=ui)
    ui
}

crunchUnauthorizedUIOutput <- function (...) {
    ui <- lazyUIOutput(...)
    options(crunchy.body.unauthorized=ui)
    ui
}

lazyUIOutput <- function (...) {
    function () {
        tags$div(...)
    }
}

crunchyDefaultPublicUI <- lazyUIOutput(
    h1("You are not authenticated"),
    tags$div(
        "Try logging in at ",
        tags$a(href="https://app.crunch.io/login", "https://app.crunch.io/login"),
        "."
    )
)
