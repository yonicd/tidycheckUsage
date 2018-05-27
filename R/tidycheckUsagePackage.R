#' @title run tidycheckUsage on an installed package
#' @description Evaluates tidycheckUsage on entire package
#' @param pack character, name of package to check.
#' @param ... options to be passed to checkUsage.
#' @return data.frame
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname tidycheckUsagePackage
#' @export 
#' @importFrom codetools checkUsagePackage
tidycheckUsagePackage <- function(pack,...){

  xx <- NULL

  breadcrumb__ <- TRUE
  
  if(!pack%in%loadedNamespaces())
    library(pack,character.only = TRUE)

  codetools::checkUsagePackage(pack,report=as_dataframe,...)

  if(!is.null(xx)){
    if(nzchar(xx$file[1])){
      xx <- parse_package(xx)
    }else{
      names(xx)[3] <- 'line'
      xx$line2 <- NULL
      xx$col1 <- ''
      xx$col2 <- ''
      xx <- xx[,c('file','line','object','col1','col2','path','fun','warning')]
    }
    
    xx$line <- as.numeric(xx$line)
    xx <- xx[order(xx$file,xx$line),]
    
    attr(xx,'package') <- pack
  }

  return(xx)
}

get_pack_name <- function(x) {
  attr(x, "package") %||% "checkUsage"
}