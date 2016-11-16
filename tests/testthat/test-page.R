context("crunchPage")

test_that("crunchPage has a token div", {
    cp <- crunchPage()
    out <- format(cp)
    expect_true(grepl('input id="token"', out))
})

test_that("crunchFillPage has a token div", {
    cfp <- crunchFillPage()
    out <- format(cfp)
    expect_true(grepl('input id="token"', out))
})
