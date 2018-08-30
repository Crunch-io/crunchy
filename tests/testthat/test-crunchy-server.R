context("crunchyServer")

# Do some mocking so that we can call the server function directly.
# Make each of the registered UI body versions 
withr::with_options(
    list(
        crunchy.body=function () stop("authed"),
        crunchy.body.public=function () stop("not authenticated"),
        crunchy.body.unauthorized=function () stop("not authorized")
    ),
    with_mock(`shiny::renderUI`=force, {
        test_that("If no authz function set, you're either authenticated or not", {
            f <- crunchyServer(list) # `func` just needs to accept three args
            expect_error(f(list(), list(), list()), "not authenticated")
            expect_error(f(list(token="asdf"), list(), list()), "authed")
        })
        test_that("Can set authz in crunchyServer", {
            f2 <- crunchyServer(list, authz=function (i, o, s) i$token == "qwer")
            expect_error(f2(list(), list(), list()), "not authenticated")
            expect_error(f2(list(token="asdf"), list(), list()), "not authorized")
            expect_error(f2(list(token="qwer"), list(), list()), "authed")
        })
        test_that("Can set authz with setCrunchyAuthorization", {
            setCrunchyAuthorization(function (i, o, s) i$token == "qwer")
            on.exit(options(crunchy.authorization=NULL))
            f3 <- crunchyServer(list)
            expect_error(f3(list(), list(), list()), "not authenticated")
            expect_error(f3(list(token="asdf"), list(), list()), "not authorized")
            expect_error(f3(list(token="qwer"), list(), list()), "authed")
        })
    })
)
