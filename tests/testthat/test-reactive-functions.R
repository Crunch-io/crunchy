context("reactive functions")

test_that("shinyDataset returns a reactive object", {
    expect_is(shinyDataset("Foo"), "reactive")
})

test_that("shinyUser returns a reactive object", {
    expect_is(shinyUser("Foo"), "reactive")
})

with_mock_crunch({
    user <- .getUserRecord()
    expect_equal(user$id, "00002")
})