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

test_that("crunchNavbarPage has a token div", {
    cnp <- crunchNavbarPage("title")
    out <- format(cnp)
    expect_true(grepl('input id="token"', out))
})

test_that("shiny::fillPage has a token div", {
    fp <- fillPage()
    out <- format(fp)
    expect_true(grepl('input id="token"', out))
})

test_that("shiny::fillPage has a token div and whatever else we give it", {
    fp <- fillPage(div(class="testing"))
    out <- unlist(strsplit(format(fp), "\n"))
    expect_true(any(grepl('input id="token"', out)))
    expect_true(any(grepl('class="testing"', out)))
    ## And our stuff is before any content the user provides
    expect_true(grep('class="testing"', out) > grep('input id="token"', out))
})

## Obviously this is called in .onLoad, but call it here so covr sees it
injectCrunchAssets()
