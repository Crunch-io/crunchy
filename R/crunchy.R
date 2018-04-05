#' @importFrom shiny div includeCSS includeScript tags
.onLoad <- function (lib, pkgname="crunchy") {
    suppressMessages(trace("bootstrapPage", where=shiny::fillPage, tracer=quote({
        tagList <- function (...) {
            shiny::tagList(
                ...,
                # Load our assets
                tags$head(
                    tags$link(rel="stylesheet", type="text/css",
                        href="https://app.crunch.io/styles.css"),
                    includeCSS(system.file("extra.css", package="crunchy")),
                    includeScript(system.file("extra.js", package="crunchy"))
                ),
                # Add a placeholder for our auth
                div(class = "form-group shiny-input-container",
                    style = "display: none;",
                    tags$input(id = "token", type = "text", class = "form-control", value = "")
                )
            )
        }
    }), print=FALSE))
    invisible()
}
