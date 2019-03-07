#' @importFrom stringi stri_replace_all
shift <- function(obj,fd){
  
  obj$fun_line <- sprintf('%s_%03d',obj$fun,obj$line)
  
  xx <- split(obj,obj$fun_line)
  
  for(i in seq_along(xx)){
  
    xx[[i]] <- xx[[i]][!duplicated(xx[[i]]$object),]
      
    for(j in 1:nrow(xx[[i]])){
      
      fd[xx[[i]]$line[j]] <- stringi::stri_replace_all(
        fd[xx[[i]]$line[j]],
        replacement = xx[[i]]$rlang[j],
        regex = sprintf('\\b%s\\b',xx[[i]]$obj[j])
      )
      
    }
    
  }
  fd
}
