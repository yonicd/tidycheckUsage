#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param pack character, name of package to check.
#' @param ... options to be passed to checkUsage.
#' @return data.frame
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname checkUsagePackagedf
#' @export 
#' @importFrom codetools checkUsagePackage
checkUsagePackage_dataframe <- function(pack,...){
  xx <- NULL

  breadcrumb__ <- TRUE
  
  if(!pack%in%loadedNamespaces())
    library(pack,character.only = TRUE)

  codetools::checkUsagePackage(pack,report=as_dataframe,...)
  return(xx)
}
