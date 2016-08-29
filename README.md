# crunch + shiny = crunchy

`crunchy` makes it easy to build Shiny apps with data stored in the [Crunch.io](http://crunch.io/) cloud data service. You can run these apps locally, or you can host them on Crunch.

## Installing

`crunchy` is not yet on CRAN, but when it is, it can be installed with

    install.packages("crunchy")

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("Crunch-io/crunchy")

## Using

Load `library(crunchy)` and it brings with it both the `shiny` and `crunch` packages. `crunchy` provides a few important functions to facilitate building Shiny apps with Crunch data:

* `crunchPage`, which is a drop-in replacement for `shiny::fluidPage`
* `shinyDataset`, a wrapper around `crunch::loadDataset` that returns a reactive object

These functions load key resources and ensure that access to the data in Crunch is governed by the same authentication and authorization rules in place throughout the platform. Without using them, you won't be able to load datasets from Crunch.

Using these functions, you can proceed working with Crunch datasets and Shiny app conventions normally, with one exception. Because `shinyDataset` returns a shiny `reactive` object, you need to always "call" it when you want to get the dataset in your server function scope. Your server function might look something like:

    shinyServer(function(input, output, session) {
        ds <- shinyDataset("Your dataset name")

        freqs <- reactive({
            fmla <- as.formula(paste("~", input$varname))
            crtabs(fmla, data=ds())
        })
        ...
    })

Note `ds()` instead of just `ds` in the aggregation function.

### Running your app locally

If you have not done so already, go to https://beta.crunch.io and log in to the Crunch service. This will set an authentication cookie in your browser. You'll need this to be able to access your datasets in your Crunchy app.

In addition to installing the `crunchy` package and its dependencies (including a suitable version of R), you'll need to add an entry to your `/etc/hosts` file that maps `localhost` to `local.crunch.io`. You probably already have a line in there like `127.0.0.1 localhost`, so you can add `local.crunch.io` as an alias after `localhost` on the same line. (This works slightly differently on different operating systems; consult Google if you aren't sure how to do it on yours.) This host file mapping is needed to allow you to use your cookie from `beta.crunch.io`.

Serve your app as you would any other Shiny app. There are a number of ways to do this; one example, for a directory named "demo" containing server.R and ui.R files, you can run this from the command line:

    $ R -e 'shiny::runApp("demo", port=7765)'

substituting the port of your choice, or omitting the `port` argument entirely if you want Shiny to choose a free one for you. The host file mapping lets you access this app at `http://local.crunch.io:7765`, and because the domain matches the Crunch service at `beta.crunch.io`, your authentication cookie from there works, and you will be able to load and query your datasets.

## For package contributors

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
