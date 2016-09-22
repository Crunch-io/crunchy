context("crunchPage")

test_that("crunchPage has a token div", {
    cp <- crunchPage()
    out <- format(cp)
    expect_true(grepl('input id="token"', out))
})
