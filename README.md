# crunch + shiny = crunchy

[![Build Status](https://travis-ci.org/Crunch-io/crunchy.png?branch=master)](https://travis-ci.org/Crunch-io/crunchy) [![codecov.io](https://codecov.io/github/Crunch-io/crunchy/coverage.svg?branch=master)](https://codecov.io/github/Crunch-io/crunchy?branch=master) [![Build status](https://ci.appveyor.com/api/projects/status/53epi1s8f0slhemm/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/crunchy/branch/master) [![cran](https://www.r-pkg.org/badges/version-last-release/crunchy)](https://cran.r-project.org/package=crunchy)

`crunchy` makes it easy to build Shiny apps with data stored in the [Crunch.io](https://crunch.io/) cloud data service. You can run these apps locally, or you can host them on Crunch.

## Installing

Install `crunchy` from CRAN with

```r
install.packages("crunchy")
```

The pre-release version of the package can be pulled from GitHub using the [remotes](https://remotes.r-lib.org/) package:

```r
# install.packages("remotes")
remotes::install_github("Crunch-io/crplyr")
```

## Using

Load `library(crunchy)` and it brings with it both the `shiny` and `crunch` packages. Most things in a Crunchy app work just as they would in a Shiny app or as they would working with Crunch in an interactive R session, with a couple of exceptions. Most importantly, you should not `login()` to Crunch as you would otherwise do when using the `crunch` R package. Your Crunchy app will use the authentication token from the web browser, the one you get when you log into the Crunch web app.

`crunchy` provides a few important functions to facilitate building Shiny apps with Crunch data and managing authentication and authorization:

* Wrap `crunchyServer()` around your usual `shiny::shinyServer()` function to enforce Crunch authentication and to be able to supply custom authorization rules, which you can set with `setCrunchyAuthorization()`.
* Wrap `crunchyBody()` around your UI body (inside `shiny::shinyUI()`, the part after any `tags$head()` or other headers) to conditionally show your app when the current user is authenticated. Add `crunchyPublicBody()` to specify what unauthenticated users will see, and `crunchyUnauthorizedBody()` for what authenticated but not authorized users will see.
* To report a Shiny progress bar for any Crunch requests that show a text progress bar in R, wrap the code in `withCrunchyProgress()`.

In addition, there are a couple of functions that return reactive versions of Crunch objects:

* `shinyDataset()`, a wrapper around `crunch::loadDataset()` that returns a reactive object
* `shinyUser()` similarly returns the (reactive) Crunch entity of the current user

Their reactivity responds to the current user of the Crunchy app, concerned with the use case of deploying Crunchy apps at `shiny.crunch.io` for users that may have different authorization. Note that, because `shinyDataset` returns a shiny `reactive` object, you need to always "call" it when you want to get the dataset in your server function scope. Your server function might look something like:

```r
function(input, output, session) {
    ds <- shinyDataset("Your dataset name")

    freqs <- reactive({
        fmla <- as.formula(paste("~", input$varname))
        crtabs(fmla, data=ds())
    })
    ...
}
```

Note `ds()` instead of just `ds` in the aggregation function.

You are recommended to load datasets in your Crunchy app by their API URL, not by their name or path. This is the fastest, most reliable way to reference a dataset--the dataset's URL will never change and is the same for everyone.

For a simple example of a Crunchy app that shows interactive summary plots for variables, copy `system.file("example_apps/crunchy_server/app.R", package="crunchy")`, supply your dataset id on line 14, and run it.

## Running your app locally

If you have not done so already, go to https://app.crunch.io and log in to the Crunch web app. This will set an authentication cookie in your browser. You'll need this to be able to access your datasets in your Crunchy app.

In addition to installing the `crunchy` package and its dependencies (including a suitable version of R), you'll need to add an entry to your `/etc/hosts` file that maps `localhost` to `local.crunch.io`. You probably already have a line in there like `127.0.0.1 localhost`, so you can add `local.crunch.io` as an alias after `localhost` on the same line. (This works slightly differently on different operating systems; consult Google if you aren't sure how to do it on yours.) This host file mapping is needed to allow you to use your cookie from `app.crunch.io`.

Serve your app as you would any other Shiny app. There are a number of ways to do this; one example, for a directory named "demo" containing server.R and ui.R files, you can run this from the command line:

    $ R -e 'library(crunchy); runApp("demo", port=7765)'

substituting the port of your choice, or omitting the `port` argument entirely if you want Shiny to choose a free one for you. The host file mapping lets you access this app at `http://local.crunch.io:7765`, and because the domain matches the Crunch service at `app.crunch.io`, your authentication cookie from there works, and you will be able to load and query your datasets.

## Deploying your app

You can hose Crunchy apps at `shiny.crunch.io` and use them as dashboards within the Crunch web app. See the [wiki](https://github.com/Crunch-io/crunchy/wiki) for instructions on setting up and maintaining apps.

## For package contributors

The repository includes a Makefile to facilitate some common tasks, if you're into that sort of thing.

### Running tests

`$ make test`. Requires the [httptest](https://enpiar.com/r/httptest/) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=server`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the [testthat](https://testthat.r-lib.org/) package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
