#' @title Append rlang !!sym on package
#' @description Programatically append !!rlang::sym('[OBJECT]') to the body of a function
#' @param pack character, name of package to check.
#' @param unquo_type character, unquo type, Default: 'UQ'
#' @param ... options to be passed to checkUsagePackage
#' @details By default rlang::UQ is used because there are still
#'  problems with '!!', eg !!rlang::sym(x)^2 will cause an error.
#' @rdname append_rlang_package
#' @export 

append_rlang_package <- function(pack,unquo_type = c('UQ','!!'), ...){
  
  if(all(unquo_type == c('UQ','!!'))){
    unquo_type = 'UQ'
  }
  
  x <- tidycheckUsagePackage(pack,...)
  
  x$rlang <- x$object
  
  fill <-switch(unquo_type,
    'UQ' = {"rlang::UQ(rlang::sym('%s'))"},
    '!!' = {"(!!rlang::sym('%s'))"}
  )
  
  x$rlang[x$warning_type=='no_global_binding'] <- 
    sprintf(fill,x$object[x$warning_type=='no_global_binding'])
  
  FILES <- split(x,x$file)
  
  ret <- lapply(FILES,function(xx){
    
    fp <- file.path(xx$path[1],xx$file[1])
    
    fd <- readLines(fp)
    
    for(i in 1:nrow(xx))
      fd[xx$line[i]] <- gsub(sprintf('\\b%s\\b',xx$object[i]),xx$rlang[i],fd[xx$line[i]]) 
    
    cat(fd,file=fp,sep = '\n')
  })
  
}
