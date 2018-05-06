#' @title return checkUsage as data.frame
#' @description FUNCTION_DESCRIPTION
#' @param fun closure, function to check
#' @param ... options to be passed to checkUsage
#' @return data.frame
#' @examples 
#' myfun <- function(x){
#' 
#' ret <- mtcars%>%
#'   mutate(mpg2=mpg*x)
#' 
#' ret <- ret%>%
#'   mutate(mpg3=mpg2^2)
#' 
#' }
#' 
#' checkUsage_dataframe(fun = myfun)
#' 
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname checkUsagedf
#' @export 
#' @importFrom codetools checkUsage
checkUsage_dataframe <- function(fun,...){
  xx <- NULL

  codetools::checkUsage(fun,report=as_dataframe,...)

  if(!is.null(xx))
    xx$fun <- deparse(substitute(fun))

  return(xx)
}
