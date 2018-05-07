as_dataframe <- function(x){
  fun <- gsub(':(.*?)$','',x)

  x_ <- gsub('^(.*?): ','',x)

  msg <- gsub('\\n$','',gsub(' \\((.*?)$','',x_))

  object <- gsub('^(.*?)\u2018|\u2019(.*?)$','',msg)

  x__ <- gsub('\\n$','',gsub('^(.*?) \\(|\\)$','',x_))

  if(grepl('\\(|\\)',x__)){

    lines <- gsub('^(.*?):|\\(|\\)','',x__)

  }else{

    lines <- ''

  }

  if(grepl(':',x__)){

    path <- gsub(':(.*?)$','',x__)

  }else{

    path <- ''

  }

  line1 <- gsub('-(.*?)$','',lines)
  line2 <- gsub('^(.*?)-','',lines)

  if(grepl('/',path)){
    file <- basename(path)
    path <- dirname(path)
  }else{

    file <- ''

  }

  ret <- data.frame(
   file             = file,
   path             = path,
   line1            = line1,
   line2            = line2,
   fun              = fun,
   object           = object,
   warning          = msg,
   stringsAsFactors = FALSE)

  breadcrumb <- which(sapply(sys.frames(),function(x) length(ls(pattern = 'breadcrumb__',envir = x))>0))

  toenv <- sys.frames()[[breadcrumb]]

  xx <- get('xx',envir = toenv)
  xx <- rbind(xx,ret)
  
  assign('xx',xx,envir = toenv)
}
