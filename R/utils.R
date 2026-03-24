#' @importFrom utils URLdecode hasName
#' @importFrom stats setNames

ifnull <- function(x, y){
    if (is.null(x)) return(y)
    x
}

format_timestamp <- function(stamp){
    strftime(stamp, "%Y-%m-%d %H:%M:%OS UTC", tz = 'UTC')
}

# based on lobstr::mem_used, so I don't need to import the whole thing just for this
mem_usage <- function(){
    bit <- 8L*.Machine$sizeof.pointer
    if (!(bit == 32L || bit == 64L)) return(NA_real_)
    if (bit == 32L) node <- 28L else node <- 56L
    round(sum(gc()[, 1]*c(node, 8L))/1e6, 1)
}
