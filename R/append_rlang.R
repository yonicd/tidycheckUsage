#' @title Append rlang !!sym
#' @description Programatically append !!rlang::sym('[OBJECT]') to the body of a function
#' @param .f function
#' @return function
#' @examples 
#' \dontrun{
#' require(dplyr)
#' 
#' x <- function(){
#'   tidyr::unite(mtcars, col = vs_am, c(vs,am))%>%
#'   ggplot2::ggplot(ggplot2::aes(x=mpg,y=qsec,colour=vs_am)) + 
#'   ggplot2::geom_point()
#' }
#' 
#' tidycheckUsage(x)
#' 
#' (x1 <- append_rlang(x))
#' 
#' tidycheckUsage(x1)
#' 
#' x1()
#' }
#' @rdname append_rlang
#' @export 

append_rlang <- function(.f){
  
  fd <- deparse(.f)
  
  x <- tidycheckUsage(fun=eval(parse(text=fd)))
  
  x$rlang <- x$object
  
  x$rlang[x$warning_type=='no_global_binding'] <- sprintf("!!rlang::sym('%s')",
                                                          x$object[x$warning_type=='no_global_binding'])
  
  for(i in 1:nrow(x))
    fd[x$line[i]] <- gsub(sprintf('\\b%s\\b',x$object[i]),x$rlang[i],fd[x$line[i]])
  
  eval(parse(text = fd))
}
