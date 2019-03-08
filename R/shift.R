#' @importFrom stringi stri_sub_replace
shift <- function(obj, fd, pad_len){
  
  obj$fun_line <- sprintf('%s_%03d',obj$fun,obj$line)
  
  xx <- split(obj,obj$fun_line)
  
  for(i in seq_along(xx)){
  
  pad <- seq(0, pad_len * ( nrow( xx[[i]] ) - 1 ),by = pad_len)
    
  xx[[i]]$col1 <- xx[[i]]$col1 + pad
  xx[[i]]$col2 <- xx[[i]]$col2 + pad
    
    for(j in 1:nrow(xx[[i]])){
      
      fd[xx[[i]]$line[j]] <- stringi::stri_sub_replace(
        str = fd[xx[[i]]$line[j]],
        from = xx[[i]]$col1[j],
        to = xx[[i]]$col2[j],
        value = xx[[i]]$rlang[j]
      )
      
    }
    
  }
  fd
}
