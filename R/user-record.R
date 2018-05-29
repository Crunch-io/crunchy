#' Get Crunch user details and confirm authentication
#'
#' `shinyUser()` returns information about the current user of the Shiny app. This
#' is useful if you want to change the behavior of the app depending on who is
#' viewing the app. You can access elements of this record with Crunch functions
#' like `name()` or `email().`
#'
#' `checkAuthentication()` is an alias for `shinyUser()` for when you only care
#' about ensuring that the current user is authenticated with Crunch.
#'
#' @return A user record if the user is logged in, otherwise a character vector or error
#' @export
#' @importFrom crunch me
shinyUser <- function () .buildReactiveExpr("me")

#' @rdname shinyUser
#' @export
checkAuthentication <- shinyUser
