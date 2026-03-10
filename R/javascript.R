
JS <- list(
    authenticate = function(req, element){
        token <- "non-token"
        cookie <- req$HTTP_COOKIE
        split <- regmatches(cookie, regexec("token=\\\"(.+?)\\\"", cookie))
        if (length(split) > 0 && length(split[[1]]) > 1){
            token <- split[[1]][2]
        }
        # Allow overriding token in dev environment, so the infrastructure will think you
        # are logged into the dev server (with token), but your app can connect to the
        # production API with "token_override" that you set via ModHeader browser
        # extension or similar
        if (Sys.getenv("ENVIRONMENT_ROLE") == "DEV") {
            override_split <- regmatches(cookie, regexec("token_override=\\\"(.+?)\\\"", cookie))
            if (length(override_split) > 0 && length(override_split[[1]]) > 1) {
                token <- override_split[[1]][2]
            }
        }

        sprintf(
            "$(document).on('shiny:connected', function(ev){Shiny.setInputValue('%s', '%s');});",
            element, token
        )
    }
)
