#' @title run tidycheckUsage on an installed package
#' @description Evaluates tidycheckUsage on entire package
#' @param pack character, name of package to check.
#' @param markers boolean, invoke RStudio markers, Default: FALSE
#' @param ... options to be passed to checkUsage.
#' @return data.frame
#' @details by default the skipWith arguments of checkUsagePackage
#' is set to TRUE to mimic the devtools::check() function.
#' @seealso 
#'  \code{\link[codetools]{checkUsage}}
#' @rdname tidycheckUsagePackage
#' @export 
#' @importFrom codetools checkUsagePackage
tidycheckUsagePackage <- function(pack, markers = FALSE, ...){

  xx <- NULL

  breadcrumb__ <- TRUE
  
  if(!pack%in%loadedNamespaces())
    loadNamespace(pack)
    
  args  <- list(...)
  
  args$report <- as_dataframe
  args$pack <- pack
  
  if(!'skipWith'%in%names(args)){
    
    args$skipWith <- TRUE
    
  }
 
  do.call(codetools::checkUsagePackage,args)

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
    xx$col1 <- as.numeric(xx$col1)
    xx$col2 <- as.numeric(xx$col2)
    
    xx <- xx[order(xx$file,xx$line,xx$col1),]
    
    attr(xx,'package') <- pack
    attr(xx,'class') <- c('data.frame','package_usage')
  }

  if(interactive()){
    if(markers){
      make_marker(pack,xx)
      return(invisible(xx))
    }else{
      return(xx)
    }
  }else{
    return(xx)
  }
  
}

get_pack_name <- function(x) {
  attr(x, "package") %||% "checkUsage"
}