#' Simple page_navbar replacement for crunchy authentication
#'
#' This is a replacement for [`bslib::page_navbar()`] that makes it easier to
#' put your shiny application's UI behind the crunchy authentication. To use
#' put the non-`bslib::nav_panel()` parts of a `page_navbar()` into `crunchy_page_navbar()`
#' and then put the nav_panels inside your shiny's server function inside `crunchy_page_navbar_server()`.
#'
#' These navpanels will only show after the application has determined that the user has
#' access. A more customizable interface is possible with [`authenticationUI()`] and
#' [`authenticationServer()`] modules, but note that your app may start to load its UI
#' for anyone logged into crunch, whether or not they are supposed to have access to your app.
#'
#' @param ...,id Passed to the named arguments of [`bslib::page_navbar()`].
#'   Note that instead of putting the unnamed `bslib::nav_panel()` arguments
#'   the ui, as you would in `bslib::page_navbar()` you instead put them in the server
#'   inside `crunchy_page_navbar_server()`. The authentication is put after your nav items,
#'   after a spacer.
#'
#' @returns For `crunchy_page_navbar()` A function that can be used as a ui for `shiny::shinyApp()`
#'   and for `crunchy_page_navbar_server()`, the auth module
#' @export
#'
#' @examples
#' \dontrun{
#' dev_mode <- list(
#'     api_key = crunch::envOrOption('crunch.api.key'),
#'     domain = extract_domain(gsub("https?://", "", crunch::envOrOption('crunch.api'))),
#'     subdomain = extract_subdomain(gsub("https?://", "", crunch::envOrOption('crunch.api')))
#' )
#' ui <- crunchy_page_navbar(title = "Some App")
#'
#' # server function
#' server <- function(input, output, session){
#'     auth <- crunchy_page_navbar_server(
#'         dev_mode = dev_mode,
#'         restrict_to = list(email_like = "@"),
#'         bslib::nav_panel(
#'             title = "Welcome",
#'             uiOutput("welcome"),
#'             verbatimTextOutput("projects")
#'         )
#'     )
#'
#'     output$welcome <- renderUI({tags$p("Welcome back ", auth$email(), "!")})
#'     output$projects <- renderText({
#'         with_temp_auth(auth, {
#'             paste0(capture.output(crunch::projects()), collapse = "\n")
#'         })
#'      })
#' }
#' shinyApp(ui, server)
#' }
crunchy_page_navbar <- function(..., id = "crunchy-page-navbar") {
    if (any(!...names() %in% names(formals(bslib::page_navbar)))) {
        warning(
            "It looks like you've included navigation items in `crunchy_page_navbar()`.\n",
            "This is not recommended. Instead navigation items should be called from ",
            "`crunchy_page_navbar_server()`"
        )
    }

    function(req) {
        bslib::page_navbar(
            bslib::nav_panel("", shiny::tags$p("Authenticating..."), value = "loading-tab"),
            ...,
            bslib::nav_spacer(),
            bslib::nav_item(authenticationUI("auth", req)),
            id = id
        )
    }
}

#' @export
#' @rdname crunchy_page_navbar
#' @param restrict_to,dev_mode Passed to [`authenticationServer()`]
#' @param session The shiny reactive domain (almost always can use the default)
crunchy_page_navbar_server <- function(
        ...,
        id = "crunchy-page-navbar",
        restrict_to = list(),
        dev_mode = list(),
        session = shiny::getDefaultReactiveDomain()
) {
    auth <- authenticationServer("auth", restrict_to = restrict_to, dev_mode = dev_mode)
    dots <- list(...)

    # May not be the best way, but don't accidentally add tabs twice if log in status changes
    access_is_true <- shiny::reactive({ if (isTRUE(auth$access())) TRUE else NULL })
    shiny::observeEvent(
        ignoreNULL = TRUE,
        ignoreInit = TRUE,
        once = TRUE,
        access_is_true(),
        {
            for (iii in seq_along(dots)) {
                bslib::nav_insert(id, dots[[iii]], target = "loading-tab", position = "before", select = iii == 1)
            }
            bslib::nav_remove(id, "loading-tab")
        },
    )

    auth
}


#' Cookie-based authentication
#'
#' @param id A string that identifies the shiny module between UI and Server objects
#'   (typically just "auth")
#' @param req The request object, received by using a function for your shiny's UI,
#'   defaults to an empty list, which means no restriction. See details.
#' @param invisible Whether to hide the authentication UI (the user's email as a clickable link)
#'   defaults to `FALSE`
#'
#' @export
#' @examples
#' \dontrun{
#' # UI should be a function, passing its argument to authenticationUI
#' ui <- function(req){
#'      navbarPage(
#'          title = 'Some App',
#'          navbarMenu('Some Menu',tabPanel('Some panel', p('Hello'))),
#'          bslib::nav_spacer(),
#'          bslib::nav_item(
#'              authenticationUI('auth', req)
#'          )
#'      )
#' }
#' # server function
#' server <- function(input, output, session){
#'     auth <- authenticationServer(
#'         'auth',
#'         restrict_to = list(
#'              email_in         = 'hinko@client.com',
#'              email_like       = '*@crunch.io',
#'              can_load_dataset = 'wftcfkglaelnfgehcgqsfvnkuijyzwfb'
#'         )
#'     )
#'     foo <- fooServer(
#'          'foo',
#'          access    = auth$access,
#'          subdomain = auth$subdomain,
#'          domain    = auth$domain,
#'          user      = auth$email,
#'          api_key   = auth$api_key
#'     )
#' }
#' }
authenticationUI <- function(id, req, invisible = FALSE){
    ns <- shiny::NS(id)
    js <- JS$authenticate(req, ns('authentication_token'))
    user_info <- NULL
    if (!isTRUE(invisible)){
        user_info <- shiny::actionLink(ns('user_link'), shiny::uiOutput(ns('user'), inline = TRUE))
    }
    shiny::tagList(
        shiny::tags$head(shiny::tags$script(shiny::HTML(js))),
        user_info
    )
}

#' @param restrict_to `list` describing who should have access to the shiny application, see details
#' @param dev_mode An optional list of overrides for authentication components (`email`, `subdomain`, `domain`,
#' `api_key`, and `access`) for use during development.
#'
#' @details
#' The `restrict_to` argument defaults to an empty list, which allows unrestricted access.
#' To restrict it, add one or more named elements:
#'   - `email_in`: Character vector of exact email addresses
#'   - `email_like`: String pattern to test user's email address against (passed to [`grepl()`])
#'   - `can_load_dataset`: String with Crunch dataset ID that the user must have access to
#'
#' If multiple elements are supplied, the user will gain access if **at least one** of them works.
#'
#' [`crunchy_page_navbar()`] provides a simpler interface to the crunchy authentication flow
#' that doesn't allow as much UI customization, but makes it easier to have your app
#' require that users have access.
#' @export
#' @rdname authenticationUI
authenticationServer <- function(id, restrict_to = list(), dev_mode = list()){
    allowed_restrictions <- c(
        'email_in', 'email_like',
        'can_load_dataset'
    )
    stopifnot(
        is.character(id), length(id) == 1,
        inherits(restrict_to, 'list'), length(unique(names(restrict_to))) == length(restrict_to),
        all(names(restrict_to) %in% allowed_restrictions),
        !hasName(restrict_to, 'email_in')         || is.character(restrict_to$email_in),
        !hasName(restrict_to, 'email_like')       || is_string(restrict_to$email_like),
        !hasName(restrict_to, 'can_load_dataset') || is_dataset_id(restrict_to$can_load_dataset),
        inherits(dev_mode, 'list')
    )
    shiny::moduleServer(id, function(input, output, session){

        # if no fields in restrict_to -> unrestricted access
        # if one or more fields -> access if *at least one* of the conditions is fulfilled
        access_conditions <- list()
        if (hasName(restrict_to, 'email_in')){
            access_conditions <- c(access_conditions,
                                   function(email, ...) email %in% restrict_to$email_in
            )
        }
        if (hasName(restrict_to, 'email_like')){
            access_conditions <- c(access_conditions,
                                   function(email, ...) grepl(restrict_to$email_like, email)
            )
        }
        if (hasName(restrict_to, 'can_load_dataset')){
            access_conditions <- c(access_conditions,
                                   function(subdomain, domain, ...){
                                       url <- paste0(form_api_url(subdomain, domain), "datasets/", restrict_to$can_load_dataset)
                                       outcome <- try(httpcache::uncached(crunch::crGET(url)))
                                       !inherits(outcome, 'try-error')
                                   }
            )
        }
        if (length(access_conditions) == 0){
            test_access <- function(...) TRUE
        } else{
            test_access <- function(...){
                ok <- vapply(access_conditions, function(fn) fn(...), FUN.VALUE = logical(1))
                any(ok)
            }
        }

        domain <- shiny::reactive({
            if (!is.null(dev_mode$domain)) return(dev_mode$domain)
            if (Sys.getenv("ENVIRONMENT_ROLE") == "DEV" && identical(tolower(shiny::getQueryString()[["use_prod_domain"]]), "true")) {
                return("crunch.io")
            }
            return(extract_domain(session$clientData$url_hostname))
        })
        subdomain <- shiny::reactive({
            if (!is.null(dev_mode$subdomain)) return(dev_mode$subdomain)
            if (Sys.getenv("ENVIRONMENT_ROLE") == "DEV" && !is.null(shiny::getQueryString()[["subdomain"]])) {
                return(shiny::getQueryString()[["subdomain"]])
            }
            extract_subdomain(session$clientData$url_hostname)
        })
        api_key   <- shiny::reactiveVal(NULL)
        user      <- shiny::reactiveVal(NULL)
        access    <- shiny::reactiveVal(FALSE)
        signed_in <- shiny::reactive(!is.null(user()))
        n_failed_login_attempts <- shiny::reactiveVal(0)

        shiny::observeEvent(api_key(), {
            shiny::req(api_key())
            attempt <- tryCatch(
                {
                    if (!is.null(dev_mode$email)){
                        email <- dev_mode$email
                    } else{
                        with(
                            crunch::temp.options(crunch = list(crunch.api = form_api_url(subdomain(), domain = domain()), crunch.api.key = api_key())),
                            { email <- httpcache::uncached(crunch::email(crunch::me())) }
                        )
                    }
                    if (!is.null(dev_mode$access)){
                        has_access <- TRUE
                    } else{
                        with(
                            crunch::temp.options(crunch = list(crunch.api = form_api_url(subdomain(), domain = domain()), crunch.api.key = api_key())),
                            { has_access <- test_access(email = email, subdomain = subdomain(), domain = domain()) }
                        )
                    }
                    list(email = email, access = has_access)
                },
                error = function(e){ message(e$message); list(email = NULL, access = FALSE)}
            )
            user(attempt$email)
            access(attempt$access)
            if (!attempt$access) n_failed_login_attempts(n_failed_login_attempts() + 1)
        })

        shiny::observeEvent(input$authentication_token, {
            if (!is.null(dev_mode$api_key)){
                api_key(dev_mode$api_key)
            } else{
                token <- input$authentication_token
                shiny::req(is_valid_auth_token(token))
                api_key(token)
            }
        })

        show_modal_rx <- shiny::reactiveVal(0)
        shiny::observeEvent(input$user_link, show_modal_rx(show_modal_rx() + 1))
        shiny::observeEvent(n_failed_login_attempts(), if (n_failed_login_attempts() > 0) show_modal_rx(show_modal_rx() + 1))

        shiny::observeEvent(show_modal_rx(), {
            shiny::req(show_modal_rx() > 0)
            if (signed_in() && access()){
                title <- 'Success'
                msg <- shiny::p(
                    'You are signed in & have permission to use this app.'
                )
            } else if (signed_in()){
                title <- 'Permission required'
                msg <- shiny::p(
                    'You are signed in but lack the permission to use this app.',
                    user(), " at ", form_api_url(subdomain(), domain())
                )
            } else{
                title <- 'Sign in'
                msg <- shiny::tagList(
                    shiny::p(
                        'You are currently not signed in.',
                        'To sign in, log into the Crunch web app and refresh this page.',
                        'Alternatively, you can paste your API key in the field below:'
                    ),
                    shiny::textInput(shiny::NS(id, 'api_key'), 'API key', width = '100%')
                )
            }
            shiny::showModal(shiny::modalDialog(title = title, msg, footer = shiny::actionButton(shiny::NS(id, "ok"), "OK")))
        })
        shiny::observeEvent(input$ok, {
            shiny::removeModal()
            shiny::req(input$api_key)
            api_key(trimws(input$api_key))
        })

        output$user <- shiny::renderUI(ifnull(user(), 'Sign in'))

        list(
            subdomain = subdomain,
            domain = domain,
            api_key = api_key,
            signed_in = signed_in,
            email = user,
            access = access
        )
    }
    )}

#' Use Crunch API with the current user's authentication
#'
#' Because rcrunch is not designed for an environment where it has to make API
#' requests on behalf of multiple users, like a shiny server, we need to be
#' careful that we always set the authentication for the correct user.
#'
#' @param auth An authentication object from the `authenticationServer` module
#' @param expr An expression that will run with authentication
#'
#' @export
#' @examples
#' \dontrun{
#'  auth <- authenticationServer('auth')
#'  ds_rx <- reactive({with_temp_auth(auth, {
#'      loadDataset(dataset_id(), project = NULL)
#'  })})
#' }
with_temp_auth <- function(auth, expr) {
    shiny::req(auth$access())
    httpcache::clearCache()
    api <- form_api_url(auth$subdomain(), auth$domain())
    with(
        crunch::temp.options(crunch = list(crunch.api = api, crunch.api.key = auth$api_key())),
        expr
    )
}

is_valid_auth_token <- function(x){
    x <- trimws(x)
    is.character(x) && length(x) == 1 && !identical(x, 'non-token')
}

