#' @title Run rcmdcheck::rcmdcheck in a backaground session
#' @description Run \code{\link[rcmdcheck]{rcmdcheck}} in another R session
#' @param \dots Arguments to pass to \code{\link[rcmdcheck]{rcmdcheck}}
#' @return An object containing errors, warnings, and notes.
#' @details Silent option of devtools::check is foreced to TRUE.
#' @seealso 
#'  \code{\link[callr]{r_bg}}
#'  \code{\link[rcmdcheck]{rcmdcheck}}
#' @rdname silent_check
#' @export 
#' @importFrom callr r_bg
#' @importFrom rcmdcheck rcmdcheck
silent_check <- function(...){

  callr::r_bg(function(...){
    on.exit({
        result <- paste0(sapply(x,length),collapse = '|')
        system(sprintf("echo 'Package Check is Done:\n%s' | terminal-notifier -sound default",result))
    },
    add = TRUE) 
    x <- rcmdcheck::rcmdcheck(..., quiet = TRUE)
    x
  })
  
}
