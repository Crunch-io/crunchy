#' @importFrom httpcache GET
jupyterAPI <- function () {
    ## Use a bare GET so we can keep the response object, not just the body
    resp <- httpcache::GET(getOption("crunch.api"))
    ## Because we need the cookie. curl manages the cookie fine across requests
    ## using the same handle, but we're going to set up another handle to
    ## the Jupyter server
    set_config(config(cookie=resp$headers[["set-cookie"]]))
    ## With that cookie from app.crunch.io set, now we can authenticate with
    ## Jupter and get *its* cookie, which we'll subsequently need
    jp <- httpcache::GET("https://jupyter.crunch.io/")
    ## Return a base URL
    absoluteURL("../api/", jp$url)
}
