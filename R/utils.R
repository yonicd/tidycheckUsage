expand_seq <- function(x){
  rownames(x) <- NULL
  x <- data.frame(t(x),stringsAsFactors = FALSE)
  ret <- cbind(x[which(!names(x)%in%c('line1','line2'))],line1=as.character(x$line1:x$line2))
  ret
}

fetch_parsed <- function(y,x){

  LINES <- seq(as.numeric(y[1]),as.numeric(y[2]))
  
  x[x$line1%in%LINES & x$line2%in%LINES&x$text==y[3]&grepl('^SPECIAL|^\\bSYMBOL\\b',x$token),]  
}

#' @importFrom utils getParseData
parse_package <- function(x){
  
  sxx <- split(x,x$file)
  
  a <- lapply(sxx,FUN = function(xx_){
    
    PATH <- xx_$path[1]
    FILE <- xx_$file[1]
    
    xx_ <- unique(xx_[,c('line1','line2','object')])
    
    p <- parse(file = file.path(PATH,FILE))
    
    x <- utils::getParseData(p,includeText = TRUE)
    
    ret <- do.call('rbind',apply(xx_,1,fetch_parsed,x=x))
    
    nm <- names(ret)
    
    nm[length(nm)] <- 'object'
    
    names(ret) <- nm
    ret$file <- FILE
    
    ret <- ret[,c('file','line1','col1','col2','object')]

    ret
  })
  
  a <- unique(do.call('rbind',a))
  
  row.names(a) <- NULL
  
  a$line1 <- as.character(a$line1)
  a$col1 <- as.character(a$col1)
  a$col2 <- as.character(a$col2)
  
  ex <- do.call('rbind',apply(x,1,expand_seq))
  
  ret <- unique(merge(a,ex))
  
  names(ret)[2] <- 'line'
  
  ret
}


#' @title Default NULL
#' @description Infix function to replace NULLs
#' @param x,y If `x` is NULL, will return `y`; otherwise returns `x`.
#' @rdname null-default
#' @name null-default
#' @export 
`%||%` <- function (x, y) 
{
  if (is.null(x)) {
    y
  }
  else {
    x
  }
}

warn_type <- function(x){
  
  if(!grepl('global|local',x))
    return('general')
  
  if(grepl('global',x))
    return('no_global_binding')
  
  if(grepl('local',x))
    return('unused_local')
}