context("crunchyServer")

test_that("as.server returns a function", {
    expect_true(is.function(as.server(input)))
    expect_true(is.function(as.server(function (input, output, session) input)))
    expect_identical(as.server(input), function (input, output, session) input)
    expect_identical(as.server(input), as.server(function (input, output, session) input))
})
