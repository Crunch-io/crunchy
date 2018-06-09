#' Return Crunch User Information
#'
#' This function returns information about the current user of the shiny app. This
#' is useful if you want to change the behavior of the app depending on who is
#' viewing the app. You can access elements of this record with crunch functions
#' like `name()` or `email().`
#' 
#' @return A user record if the user is logged in, otherwise a character vector or error
#' @export
shinyUser <- function () .buildReactiveExpr(".getUserRecord")

#' @export
#' @inheritParams shinyUser
#' @importFrom httpcache uncached
#' @importFrom crunch me
#' @keywords internal
.getUserRecord <- function() uncached(me())