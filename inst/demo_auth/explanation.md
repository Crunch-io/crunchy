This is a demo of writing a shiny application running on crunch's shiny server and
meant to be a living documentation of how it works & best practices.

### Crunch shiny application structure

- **Package:** By convention, almost all app logic is contained within a package
  saved in the shiny repo's `packages` directory.
- **App:** In the shiny repo's 'apps' directory each app gets a folder with a shiny
  app (generally an app.R file that calls on a function from the package).
- **Dependencies:** In the `app` folder, a 'dependencies.csv' file locks the versions of
  dependencies down. The easiest way to get this file is with:
  ```r
  remotes::install_github('sluga/depra')
  pkg <- '<PACKAGE NAME>'
  deps <- depra::deps_table(pkg, self = TRUE) |>
      subset(select = c(package, version))
  deps$version[deps$package == pkg] <- NA    
  write.csv(deps, 'dependencies.csv', row.names = FALSE)
  ```
  
  This is still not always enough (My current theory because it doesn't include
  optional dependencies (eg a package's Suggests), so you may need to deploy
  (at least to the dev environment) and see if it is enough and then tweak
  the csv manually.
  
  (renv.lock files like those used by renv are also kind of supported, but
  the csv is more reliable. Since our operations team requiers that we use a hosted
  CRAN-like mirror, we've had to roll our own installation script)


The application will be available at:
- `https://<SUBDOMAIN>.crunch.io/shiny/apps/<APP-NAME>/`

Where `<SUBDOMAIN>` is any subdomain (eg `team`, `yougov`, or `shopperintelligence`)
and `<APP-NAME>` is the name of the folder in the `apps` directory.

## Dev server

Apps are available on the dev server at: 
`https://team.crunch-dev.io/shiny/apps/<APP-NAME>/`

However, only the "team" subdomain exists on the dev server, so you must have an account 
there to see shiny apps. Because many apps require using production data, the
authentication module provided by the `crunchy` package (see below) allows you
to use url query params to indicate that you want to refer to the production API, by
adding `?subdomain=<SUBDOMAIN>&use_prod_domain=true` to the end of the app's url. The
dev environment also supports overriding the token provided by the API with header
`override_token`, which you can set via the ModHeader extension or similar.

## `crunchy` package

The `crunchy` package contains helpers for Crunch shiny apps. You can install with:
`remotes::install_github("Crunch-io/crunchy")`

## Authentication

Authentication is taken care of by the `crunchy` package's authentication module.
The UI function (`authenticationUI()`) is designed to go inside a `bslib::nav_item()` at the end 
of a `bslib::page_navbar`. The argument `req` is passed in from the ui function (usually 
a shiny app's ui is not a function, but it is allowed to be one, and the `req` argument
contains information about the HTTP request that is connecting the user to the app).

A slightly simpler way to get a shiny app's UI behind authentication, is to use 
`crunchy::crunchy_page_navbar()`.

The authentication flow requires that users log into the main crunch application
before going to the shiny app. If the user has done this, the shiny application
should just have access to the user's credentials. One way to encourage logging 
into crunch first is to put the shiny application inside an `iframe` tile of a 
native crunch dashboard.

If the authentication flow was successful, the UI displays the user's email. 
If not, it shows a "Sign in" link which launches a modal screen allowing the user to 
manually specify their API token. Note that the app is still accessible even if the
user is not authenticated, so it's important that the rest of the UI also checks that
the user is authenticated.

The server part of the module (`authenticationServer()`) accepts a `restrict_to` list 
argument which can contain one or more of: 
- **email_in**:  A list of emails allowed to use the app
- **email_like**: A regular expression to match the user's email against
- **can_load_dataset**: A dataset id, and a user is only considered to have access 
  if they can load the dataset

It returns a list with the following reactive items (and so must be accessed like 
they're functions, eg `auth$subdomain()`):
- subdomain - The subdomain for the crunch API
- api_key - The api key for use with the crunch API
- signed_in - Logical indicating whether the user is signed in (regardless of whether they have access)
- email - The user's email address according to the crunch API.
- access - Logical indicating whether the user has access

The server module also allows passing in a `dev_mode` argument to assist with local development. 
There isn't a standard way to set this up yet, but in the demo there is the ability to set
a "ENVIRONMENT_ROLE" env var to `"LOCAL"`, and then it will use rcrunch's default api key and
subdomain.

## Using rcrunch in a shiny context
Unfortunately rcrunch was not designed for the multi-user per R session setting like our
shiny server is. The function `crunchy::with_temp_auth()` is designed to 
help shiny apps need to work around these features in particular: 

### Ensuring the user is authenticated
Though we have a helper to get the user's authentication, there's no perfect way to enforce
the user is logged in when interacting with a shiny app, so it's the responsibility of the app
to ensure the user actually has access.

### Setting credentials
When making requests to the crunch API, rcrunch pulls the API URL and credentials from 
options/environment variables, which are shared for the whole R session. This means if 
you're not careful, it's easy to accidentally allow someone to use someone else's 
credentials. Using function `crunchy::with_temp_auth()` handles this for you.

### rcrunch's cache
rcrunch caches responses from the API. This can save a lot of time, but is problematic because
the cache is shared across all users (even if a user shouldn't have access to something) and 
because this cache won't be consistently reset (in general it will reset when the app stops, 
after all users are disconnected for several minutes). For most situations, apps should reset
the cache each time they make requests to the API.  Using function `crunchy::with_temp_auth()` 
handles this for you.

## Deployment
When a pull request is created against the main branch of the crunch shiny repo, a github
action deploys the app to the dev environment (`<SUBDOMAIN>.crunch-dev.io/shiny/apps/<APP-NAME>`)

Merging the pull request deploys it to production. Each deployment requires restarting the
kubernetes pod, and this is currently done immediately without warning to the shiny apps. 
So far our users have been okay with these disruptions, even when they happen ~1/day. 
Probably in not too long, we need to get better about this.

## Logging
We don't yet have a system for logging that is available to non-crunch collaborators.

## Environment variables
During deployment, a file in your app's folder called `.Renviron.template` is used 
to fill in environnment files that will be made available to your application.

For environment variables that are not secret, you can add them directly to the 
`.Renvironment.template` file. For secret ones, we'll have to work with our 
operations team.

The `.Renviron.template` file is structured like this. You should always include 
`ENVIRONMENT_ROLE` (set to "DEV" on dev and "PROD" and production) and `APP_LOG_FILE`
(gives path to a log file on permanent storage that is unique to the app and pod).

```
ENVIRONMENT_ROLE={{ENVIRONMENT_ROLE}}
APP_LOG_FILE={{APP_LOG_FILE}}
SECRET_ENV_VAR={{SECRET_ENV_VAR}}
NON_SECRET=turbo
```

## Storage
There is some storage space that is persisted across deployments available
at `/crunch/storage`. This can be useful for persisting things like settings or 
reports, but it's currently the app owner's responsibility to maintain, we've been
making subfolders per app within there.

The convention is that each app makes its own folder within the `/crunch/storage/` 
directory (like `/crunch/storage/yg.popest`).

## Backgrounding tasks
Since R is single threaded, and shiny server is running each app in a single process,
any long running task by one user will completely block anyone else from doing anything
in the application. Posit's shiny team has spent a lot of time writing about this, 
but these are some pointers specific to our setup:
- `future.callr` is our recommended `future` backend, because it does not keep background
  tasks alive the entire time the app is running. Because we can have many different 
  applications running, it is too many processes if each of them hold onto them the
  entire time they are running. This does have the tradeoff of being
  slower to start-up, so we tend to design our apps to background a big chunk of work.
- We have a pretty beefy machine, but do think about how much memory each of the background
  tasks is using.
- R6 objects (including `ipc::AsyncProgress`) can have a lot of overhead being sent
  to a background task, so be careful.

## Query params and URL hash
A common pattern is to want to pass in parameters via the URL (eg a dataset id).
See `shiny::getUrlHash()`, `shiny::getQueryString()` and `shiny::parseQueryString()`
for how to do this.

## App lifecycle

This has been a source of confusion, so for reference:

1. After a deployment, no apps are running.

2. The first time a user connects to your application, shiny server essentially runs
   `Rscript -e 'shiny::runApp(appDir = ".")'` from your app's directory.
   
3. If subsequent users connect while the first is still connected, essentially only 
  the code within the `ui` and  `server` functions is run per user.

4. A couple of minutes after all users have disconnected, the whole application
  stops running. When the next user connects they will be back at step 2. In many cases
  (maybe all, maybe just when using things like `ipc::AsyncProgress`) background tasks
  are killed when the main application stops running.

5. When we deploy, all apps are killed immediately without warning.

If you have code that you want to run outside of the app's lifecycle (eg to clean
up files saved in `/crunch/storage/`), we've been using cron.
