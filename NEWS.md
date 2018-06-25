## crunchy 0.2.3 (under development)
* Support for all `shiny::bootstrapPage()` types directly: no need for a `crunch-`prefixed version of them. Now you can use `navbarPage`, `fillPage`, etc. just as you would for any `shiny` app, and when the `crunchy` package is loaded, Crunch authentication and other enhancements will automatically be loaded.
* `shinyUser()` to return a `reactive` object yielding the CrunchUser currently viewing the app. This function also ensures that the current user is authenticated with the Crunch API.
* RStudio Gadgets for interactive use with the `crunch` package: (1) finding and loading a dataset, and (2) creating an array or multiple response variable.
* Vignette on how to build a Crunchy app to deploy a static 'flexdashboard', including how to protect it with Crunch authentication and how to conditionally show static content to different users. See `vignette("flexdashboards", package="crunchy")`.

## crunchy 0.2.2

* `crunchNavbarPage` for Crunchy version of `navbarPage` (#2)

## crunchy 0.2.0

* `crunchFillPage` for flexbox version of `crunchPage`
* CSS tweaks to improve scrolling and better display Plotly graphics

## crunchy 0.1.0

* Initial addition of functions and tests
