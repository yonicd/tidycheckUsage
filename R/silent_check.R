#' @title Run devtools::check in a backaground session
#' @description Run \code{\link[devtools]{check}} in another R session
#' @param \dots Arguments to pass to \code{\link[devtools]{check}}
#' @return An object containing errors, warnings, and notes.
#' @details Silent option of devtools::check is foreced to TRUE.
#' @seealso 
#'  \code{\link[callr]{r_bg}}
#'  \code{\link[devtools]{check}}
#' @rdname silent_check
#' @export 
#' @importFrom callr r_bg
#' @importFrom devtools check
silent_check <- function(...){
  
  callr::r_bg(function(){
    on.exit({
      if(nzchar(system('terminal-notifier -version',intern = TRUE))){
        result <- paste0(sapply(x,length),collapse = '|')
        system(sprintf("echo 'Package Check is Done:\n%s' | terminal-notifier -sound default",result))}
    },
    add = TRUE) 
    x <- devtools::check(..., quiet = TRUE)
    x
  })
  
}
