.onLoad <- function (lib, pkgname="crunchy") {
    injectCrunchAssets()
    ## Hack: make sure the request to the API root inside of me() is uncached
    ## so that we can use this request to ensure that the current user is
    ## authenticated with Crunch.
    suppressMessages(trace(
        "me",
        tracer=quote({
            userURL <- function () uncached(crGET(getOption("crunch.api")))$urls$user_url
        }),
        where=tokenAuth,
        print=FALSE
    ))
    invisible()
}
