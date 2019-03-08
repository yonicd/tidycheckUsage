rlang_syms <- function(){
  
  loadNamespace("rstudioapi")
  
  adc <- rstudioapi::getSourceEditorContext()
  old_text <-adc$selection[[1]]$text
  if(grepl(',',old_text)){
    new_text <-sprintf("(!!!(rlang::syms('%s')))",old_text)
  }else{
    new_text <-sprintf("(!!(rlang::sym('%s')))",old_text)
  }
  rstudioapi::modifyRange(location = adc$selection[[1]]$range,new_text,id = adc$id)
}

rlang_data <- function(){
  
  loadNamespace("rstudioapi")
  
  adc <- rstudioapi::getSourceEditorContext()
  old_text <-adc$selection[[1]]$text
  
  if(grepl('^.$',old_text)){
    new_text <- '.data'
  }else{
    if(grepl(',',old_text)){
      
      new_text <-paste0(sprintf("(.data[['%s']])",strsplit(old_text,',')[[1]]),collapse = ',')
      
    }else{
      
      new_text <-sprintf("(.data[['%s']])",old_text)  
      
    }
  }
  
  rstudioapi::modifyRange(location = adc$selection[[1]]$range,new_text,id = adc$id)
}

#' @importFrom rstudioapi getActiveProject
addin_report <- function() {
  loadNamespace("rstudioapi")
  
  pack <- basename(rstudioapi::getActiveProject() %||% getwd())
  
  loadNamespace(pack)
  
  usage_report(tidycheckUsagePackage(pack))
}