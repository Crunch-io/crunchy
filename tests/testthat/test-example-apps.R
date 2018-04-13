test_that("makeArrayGadget passes shiny tests", {
    skip_on_cran()
    shinytest::expect_pass(
        shinytest::testApp("example_apps/example_dashboard", compareImages = FALSE))
})