#' Return Crunch User Information
#'
#' This function returns information about the current user of the shiny app. This
#' is useful if you want to change the behaviour of the app dependeing on who is
#' viewing the app.
#'
#' @return A list with the following entries:
#' - id_method: the method used to authenticate the user, for instance oauth
#' - preferneces: various preferences used by the Crunch web app
#' - name: the user's name
#' - account_permissions: the users permissions, for instance whether they can create datasets
#' - id_provider: If id_method = 'oauth', the authentication provider
#' - email: the user email
#' - id: the user's crunch id
#' @export
#'
#' @examples
getUser <- function (...) .buildReactiveExpr(".getUserRecord", ...)

#' @export
#' @keywords internal
.getUserRecord <- function() {
    user <- httpcache::uncached(crunch::me())
    return(user@body)
}
