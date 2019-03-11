#' @title Append rlang !!sym
#' @description Programatically append template on objects to the body of a function
#' @param obj function_usage or package_usage class
#' @param template pattern to replace an object with, Default: "(!!sym('\%s'))"
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
#' obj <- tidycheckUsage::tidycheckUsage(x)
#' 
#' (x1 <- tidycheckUsage::append_rlang(obj))
#' 
#' tidycheckUsage::tidycheckUsage(x1)
#' 
#' x1()
#' }
#' @rdname append_rlang
#' @export 
append_rlang <- function(obj, template = "(!!sym('%s'))"){
  UseMethod("append_rlang")
}


#' @rdname append_rlang
#' @export 
append_rlang.function_usage <- function(obj, template = "(!!sym('%s'))"){
  
  fd <- capture.output(attr(obj,'src'))
  
  obj$rlang <- obj$object

  obj$rlang[obj$warning_type=='no_global_binding'] <- 
    sprintf(template,obj$object[obj$warning_type=='no_global_binding'])
  
  fd <- shift(obj,fd, nchar(template) - 2)

  eval(parse(text = fd))
}

#' @rdname append_rlang
#' @export 

append_rlang.package_usage <- function(obj, template = "(!!sym('%s'))"){
  
  obj$rlang <- obj$object

  obj$rlang[obj$warning_type=='no_global_binding'] <- 
    sprintf(template,obj$object[obj$warning_type=='no_global_binding'])
  
  FILES <- split(obj,obj$file)
  
  ret <- lapply(FILES,function(xx){
    
    fp <- file.path(xx$path[1],xx$file[1])
    
    fd <- readLines(fp)

    fd <- shift(xx,fd,nchar(template) - 2)

    message(sprintf('Editing %s',fp))
    
    cat(fd,file=fp,sep = '\n')
  })
  
  message(sprintf('Total files edited: %s', length(FILES)))
  
}
