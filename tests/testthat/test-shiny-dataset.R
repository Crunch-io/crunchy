context("shinyDataset")

test_that("shinyDataset returns a reactive object", {
    expect_is(shinyDataset("Foo"), "reactive")
})
