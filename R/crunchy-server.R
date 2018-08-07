#' A Shiny server with Crunch auth
#'
#' To make sure that users who access your shiny.crunch.io app are allowed to
#' access it, use `crunchyServer()` instead of [shiny::shinyServer()], and wrap
#' your UI content inside [crunchyBody()]. This will prevent anyone who is not
#' logged into Crunch in their browser from accessing your app.
#'
#' To restrict access further to only certain Crunch users, you can set an
#' authorization method, either by passing a server function to
#' the `authz` argument of this function, or by calling
#' [setCrunchyAuthorization()].
#'
#' @param func A `function (input, output, session)`, as you'd normally give to
#' `shinyServer()`. If the user is not authenticated or authorized, this
#' function will not be evaluated.
#' @param authz A `function (input, output, session)` to evaluate
#' to determine if the current user is authorized to enter the app.
#' Since it will be called repeatedly, it should be cheap to execute.
#' @return Invisibly, a Shiny server function with the auth logic wrapped around
#' `func`.
#' @seealso [crunchyBody()] for wrapping the UI contents, [crunchyPublicBody()]
#' for specifying an alternate UI for when the user is not authenticated, and
#' [crunchyUnauthorizedBody()] for giving an alternate UI for users who are
#' authenticated with Crunch but not authorized to view this app.
#' @export
#' @importFrom shiny shinyServer
crunchyServer <- function (func, authz=getOption("crunchy.authorization")) {
    shinyServer(function (input, output, session) {
        public_ui <- getOption("crunchy.body.public", crunchyDefaultPublicUI())
        output$crunch_body <- renderUI({
            # First, check whether this user is authenticated.
            #
            # Note that this doesn't check the server, just for the existence of
            # a *.crunch.io token. Generally good enough, and fast. If you
            # really want to lock it down, specify an authorization function.
            # E.g. `inherits(shinyUser()(), "UserEntity")` checks that we get a
            # valid server response that requires authentication
            if (is.character(input$token) && nchar(input$token) > 0) {
                # Next, if the user has supplied an authorization requirement,
                # check that.
                if (is.null(authz) || is.truthy(authz(input, output, session))) {
                    # We're good, so call the "normal" server function
                    func(input, output, session)
                    # Return the UI body. It is a "lazyUIOutput" that needs to
                    # be evaluated in the server context.
                    getOption("crunchy.body")()
                } else {
                    # Show the unauthorized page, which defaults to the unauthenticated
                    getOption("crunchy.body.unauthorized", public_ui)()
                }
            } else {
                # Not authenticated.
                public_ui()
            }
        })
    })
}

#' Register authorization logic for your Crunchy app
#'
#' Call this to set an expression or server function to evaluate to determine
#' whether the current user is authorized to access your app. Ideally, this is
#' cheap to execute because it will be called repeatedly.
#' @param func A `function (input, output, session)` to call
#' inside [crunchyServer()]
#' @return Invisibly, the server function. This function is called
#' for the side effect of setting the authorization function globally.
#' @export
#' @examples
#' setCrunchyAuthorization(function (input, output, session) {
#'     # Restrict to users who have crunch.io emails
#'     endsWith(email(shinyUser()()), "@crunch.io")
#' })
setCrunchyAuthorization <- function (func) {
    options(crunchy.authorization=func)
    invisible(func)
}

is.truthy <- function (expr) {
    # Evaluate code in a server-like function, and always return TRUE/FALSE
    tryCatch(isTRUE(expr), error=function (e) FALSE)
}
