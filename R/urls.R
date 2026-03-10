
extract_url_parameters <- function(x){
    # remove everything up to (and including) the question mark
    clean <- gsub('^.*[?]', '', x)
    # url parameters are separated by &
    split <- strsplit(clean, '&')[[1]]
    # each part: 'foo=bar'
    res <- lapply(split, function(.x){
        .res <- strsplit(.x, '=')[[1]]
        setNames(list(URLdecode(.res[2])), .res[1])
    })
    # end result: list(foo1 = 'bar1', foo2 = 'bar2')
    unlist(res, recursive = FALSE)
}

#' Extract components of URLs
#'
#' @param url_hostname The url hostname like `yougov.crunch.io`
#'
#' @export
extract_subdomain <- function(url_hostname){
    # for local Docker testing
    if (grepl('localhost', url_hostname)){
        return('team')
    }
    strsplit(url_hostname, "[.]")[[1]][[1]]
}

#' @export
#' @rdname extract_subdomain
extract_domain <- function(url_hostname){
    # for local Docker testing
    if (grepl('localhost', url_hostname)){
        return('crunch.io')
    }
    gsub("[^.]+\\.([^:^/]+).*$", "\\1", url_hostname)
}

form_api_url <- function(subdomain, domain = "crunch.io"){
    sprintf('https://%s.%s/api/', subdomain, domain)
}

form_dataset_url <- function(subdomain, dataset_id, domain = "crunch.io"){
    # NB: This is a whaam URL, not the API one. (so it works in rcrunch
    #     but won't if you use the URL directly)
    sprintf('https://%s.%s/dataset/%s', subdomain, domain, dataset_id)
}
