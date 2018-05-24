context("reactive functions")

test_that("shinyDataset returns a reactive object", {
    expect_is(shinyDataset("Foo"), "reactive")
})

test_that("shinyUser returns a reactive object", {
    expect_is(shinyUser("Foo"), "reactive")
})

test_that(".getUserRecord errors if not logged in", {
    expect_equal(
        .getUserRecord(), 
        "You are not logged into Crunch, please check that you can access app.crunch.io.")
    expect_error(.getUserRecord(text_error = FALSE), 
        "You are not authenticated. Please `login()` and try again.", fixed = TRUE)
})

with_mock_crunch({
    user <- .getUserRecord()
    expect_equal(crunch:::email(user), "fake.user@example.com")
})