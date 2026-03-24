.onLoad <- function(libname, pkgname) {
    backports::import(pkgname, c("...names"))

    crunch_client_header <- Sys.getenv("CRUNCH_CLIENT_HEADER")
    if (crunch_client_header != "") {
        crunch::set_crunch_config(
            httr::add_headers("crunch-client" = crunch_client_header),
            update = TRUE
        )
    }
}

