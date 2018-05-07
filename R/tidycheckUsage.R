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
#' tidycheckUsage(fun = myfun)
#' 
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname checkUsagedf
#' @export 
#' @importFrom codetools checkUsage
#' @importFrom utils capture.output
tidycheckUsage <- function(fun,...){
  
  xx <- NULL

  breadcrumb__ <- TRUE
  
  codetools::checkUsage(fun,report=as_dataframe,...)

  if(!is.null(xx)){
    
    xx$fun  <- deparse(substitute(fun))
    
    flag <- FALSE
    
    if(!nzchar(xx$file[1])){
      flag <- TRUE
      file <- tempfile(pattern = 'checkUsage-',fileext = '.R')
      utils::capture.output(print(fun), file = file)
      check_file <- readLines(file)
      cat(check_file[!grepl("^<", check_file)], file = file, sep = "\n")
      xx$file <- basename(file)
      xx$path <- dirname(file)      
    }
    
      xx      <- parse_package(xx)
      
      if(flag){
        xx$file <- ''
        xx$path <- ''
      }
      
    }
  
    
  return(xx)
}
