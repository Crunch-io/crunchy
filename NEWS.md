# crunch 0.3.2
* Fixes to tests for upcoming crunch package update.

# crunchy 0.3.1
* New maintainer

# crunchy 0.3.0
* Simpler and better auth enforcement. Wrap `crunchyServer()` around your usual `shiny::shinyServer()` function to enforce Crunch authentication and to be able to supply custom authorization rules, which you can set with `setCrunchyAuthorization()`. Wrap your UI body (inside `shiny::shinyUI()`, the part after any `tags$head()` or other headers) in `crunchyBody()` to conditionally show your app when the current user is authenticated. Add `crunchyPublicBody()` to specify what unauthenticated users will see, and `crunchyUnauthorizedBody()` for what authenticated but not authorized users will see.
* Support for all `shiny::bootstrapPage()` types directly: no need for a `crunch-`prefixed version of them. Now you can use `navbarPage`, `fillPage`, etc. just as you would for any `shiny` app, and when the `crunchy` package is loaded, Crunch authentication and other enhancements will automatically be loaded.
* `shinyUser()` to return a `reactive` object yielding the CrunchUser currently viewing the app. This function also ensures that the current user is authenticated with the Crunch API.
* `withCrunchyProgress()` context to report progress from the Crunch API (for example, when exporting data) as a progress bar in a Shiny app using `shiny::withProgress()`.
* RStudio Gadgets for interactive use with the `crunch` package: (1) finding and loading a dataset, and (2) creating an array or multiple response variable.
* Vignette on how to build a Crunchy app to deploy a static 'flexdashboard', including how to protect it with Crunch authentication and how to conditionally show static content to different users. See `vignette("flexdashboards", package="crunchy")`.

# crunchy 0.2.2

* `crunchNavbarPage` for Crunchy version of `navbarPage` (#2)

# crunchy 0.2.0

* `crunchFillPage` for flexbox version of `crunchPage`
* CSS tweaks to improve scrolling and better display Plotly graphics

# crunchy 0.1.0

* Initial addition of functions and tests
