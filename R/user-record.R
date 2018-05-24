#' Return Crunch User Information
#'
#' This function returns information about the current user of the shiny app. This
#' is useful if you want to change the behavior of the app depending on who is
#' viewing the app. You can access elements of this record with crunch functions
#' like `name()` or `email().`
#' 
#' @param text_error If TRUE the function will return a character vector instead of
#' erroring. This is useful for handling the error in your shiny app.  
#' @return A user record if the user is logged in, otherwise a character vector or error
#' @export
shinyUser <- function (text_error = TRUE) .buildReactiveExpr(".getUserRecord", text_error)

#' @export
#' @inheritParams shinyUser
#' @importFrom httpcache uncached
#' @importFrom crunch me
#' @keywords internal
.getUserRecord <- function(text_error = TRUE) {
    out <- tryCatch(
        uncached(me()),
        error = function(e){
            if (text_error) {
                return("You are not logged into Crunch, please check that you can access app.crunch.io.")
            } else {
                stop(e)
            }
        })
    return(out)
}