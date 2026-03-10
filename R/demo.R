#' Run demo application
#'
#' @param which demo to run (currently only 'demo_auth' is supported)
#'
#' @export
launch_demo <- function(which = 'demo_auth'){
    shiny::shinyAppDir(system.file(which, package = 'crunchy'),
        options = list(launch.browser = TRUE)
    )
}
