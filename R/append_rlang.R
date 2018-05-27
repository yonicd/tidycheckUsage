#' @title Append rlang !!sym
#' @description Programatically append !!rlang::sym('[OBJECT]') to the body of a function
#' @param .f function
#' @param unquo_type character, unquo type, Default: 'UQ'
#' @param ... options to be passed to checkUsage.
#' @return function
#' @examples 
#' \dontrun{
#' x <- function(){
#'   
#'   data <- tidyr::unite(mtcars, col = vs_am, c(vs,am))
#'   
#'   ggplot2::ggplot(data = data, ggplot2::aes(x=mpg^2,y=qsec,colour=vs_am)) + 
#'     ggplot2::geom_point()
#' }
#' 
#' tidycheckUsage::tidycheckUsage(x)
#' 
#' (x1 <- tidycheckUsage::append_rlang(x))
#' 
#' tidycheckUsage::tidycheckUsage(x1)
#' 
#' x1()
#' }
#' @rdname append_rlang
#' @export 

append_rlang <- function(.f,unquo_type = c('UQ','!!'),...){
  
  if(all(unquo_type == c('UQ','!!'))){
    unquo_type = 'UQ'
  }
  
  fd <- deparse(.f)
  
  x <- tidycheckUsage(fun=eval(parse(text=fd)),...)
  
  x$rlang <- x$object
  
  fill <-switch(unquo_type,
                'UQ' = {"rlang::UQ(rlang::sym('%s'))"},
                '!!' = {"(!!rlang::sym('%s'))"}
  )
  
  x$rlang[x$warning_type=='no_global_binding'] <- 
    sprintf(fill,x$object[x$warning_type=='no_global_binding'])
  
  for(i in 1:nrow(x))
    fd[x$line[i]] <- gsub(sprintf('\\b%s\\b',x$object[i]),x$rlang[i],fd[x$line[i]])
  
  eval(parse(text = fd))
}
