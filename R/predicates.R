
is_string <- function(x){
    is.character(x) && length(x) == 1
}

is_nonempty_string <- function(x){
    is_string(x) && nzchar(x)
}

is_positive_integer <- function(x) {
    length(x) == 1 && is.integer(x) && !is.na(x) && x > 0
}

is_dataset_id <- function(x){
    is_string(x) && !is.na(x) && nchar(x) == 32
}

is_dataset_revision <- function(x){
    is_string(x) && !is.na(x) && nchar(x) == 6
}

is_uuid <- function(x){
    is_string(x) && nchar(x) == 36
}

is_ulid <- function(x){
    is_string(x) && nchar(x) == 26
}

is_directory <- function(x){
    is_string(x) && !is.na(x) && dir.exists(x)
}

