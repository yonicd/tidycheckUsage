make_marker <- function(pack,x){

  new_x <- x[,c('line','col1','path','file','warning')]
  new_x$file <- file.path(new_x$path,new_x$file)
  new_x$path <- NULL
  names(new_x) <- c('line','column','file','message')
  new_x$type <- 'info'
  
  new_x$line <- as.numeric(new_x$line)
  new_x$column <- as.numeric(new_x$column)
  new_x <- split(new_x,new_x$file)
  
  y <- lapply(new_x,as.list)
  names(y) <- NULL
  
  rstudioapi::callFun("sourceMarkers",
                    name = pack,
                    markers = y,
                    basePath = getwd(),
                    autoSelect = "none")
}