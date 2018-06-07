#' @importFrom httpcache uncached
#' @importFrom crunch crGET
.onLoad <- function (lib, pkgname="crunchy") {
    injectCrunchAssets()
    invisible()
}
