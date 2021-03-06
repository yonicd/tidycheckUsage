#' @title return checkUsage as data.frame
#' @description evaluates checkUsage and returns a tidy output
#' @param fun closure, function to check
#' @param ... options to be passed to checkUsage
#' @return data.frame
#' @details by default the skipWith arguments of checkUsagePackage
#' is set to TRUE to mimic the devtools::check() function.
#' @examples 
#' \donttest{
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
#' }
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname tidycheckUsage
#' @export 
#' @importFrom codetools checkUsage
#' @importFrom utils capture.output
tidycheckUsage <- function(fun,...){
  
  xx <- NULL

  breadcrumb__ <- TRUE
  
  args  <- list(...)
  
  args$report <- as_dataframe
  args$fun <- fun
  
  if(!'skipWith'%in%names(args)){
    
    args$skipWith <- TRUE
    
  }
  
  do.call(codetools::checkUsage,args)

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
      xx$line <- as.numeric(xx$line)
      xx$col1 <- as.numeric(xx$col1)
      xx$col2 <- as.numeric(xx$col2)
      
      xx <- xx[order(xx$file,xx$line,xx$col1),]
      
      if(flag){
        xx$file <- ''
        xx$path <- ''
      }
      
    }
  
  if(!is.null(xx)){
    attr(xx,'class') <- c('data.frame','function_usage')
    attr(xx,'src' ) <- fun
  }
  
  return(xx)
}
