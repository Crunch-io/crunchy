Sys.setlocale("LC_COLLATE", "C") ## What CRAN does
set.seed(999)
options(warn=1)

public <- function (...) with(globalenv(), ...)

source(system.file("crunch-test.R", package="crunch"))