#' Display checkUsage results using a standalone report
#'
#' @param x a tidycheckUsage dataset, defaults to running `checkUsagePackage_dataframe()`.
#' @param file The report filename.
#' @param browse whether to open a browser to view the report.
#' @examples
#' \dontrun{
#' x <- tidycheckUsagePackage()
#' usage_report(x)
#' }
#' @export
#' @importFrom DT datatable
#' @import shiny
#' @rdname usage_report
usage_report <- function(x = tidycheckUsagePackage(),
                   file = file.path(tempdir(), paste0(get_pack_name(x), "-report.html")),
                   browse = interactive()) {
  
  loadNamespace("shiny")
  
  data <- to_shiny_data_(x)
  
  ui <- shiny::fluidPage(
    shiny::includeCSS(system.file("www/shiny.css", package = "tidycheckUsage")),
    shiny::column(8, offset = 2,
                  shiny::tabsetPanel(
                    shiny::tabPanel("Files",
                                    DT::datatable(data$file_stats,
                                                  escape = FALSE,
                                                  options = list(searching = FALSE, dom = "t", paging = FALSE),
                                                  rownames = FALSE,
                                                  callback = DT::JS(
                                                    "table.on('click.dt', 'a', function() {
                                                    files = $('div#files div');
                                                    files.not('div.hidden').addClass('hidden');
                                                    id = $(this).text();
                                                    files.filter('div[id=\\'' + id + '\\']').removeClass('hidden');
                                                    $('ul.nav a[data-value=Source]').text(id).tab('show');
});"))),
            shiny::tabPanel("Source", addHighlight(renderSourceTable(data$full)))
                                    )
                                    ),
  title = paste(attr(x, "package"), "Usage"))
  
  htmltools::save_html(ui, file)
  
  viewer <- getOption("viewer", utils::browseURL)
  
  if (browse) {
    viewer(file)
  }
  invisible(file)
  }

to_shiny_data_ <- function(xx_) {
  
  xx_$short_path <- file.path(basename(xx_$path),xx_$file)
  
  res <- list()
  
  res$full <- lapply(split(xx_,xx_$short_path),function(sxx){
    
    path <- file.path(sxx$path[1],sxx$file[1])
    
    p <- parse(path)
    
    pp <- utils::getParseData(p)
    
    LINES <- readLines(path,warn = FALSE)
    
    a <- list(line   = seq_along(LINES),
              source = LINES,
              usage  = ifelse(grepl('^#',gsub('^\\s+','',LINES)),NA,-1)
    )
    
    tbl <- table(sxx$line)
    
    a$usage[as.numeric(names(tbl))] <- as.numeric(tbl)
    
    a$usage[setdiff(pp$line1[grepl('^SYMBOL$|^SPECIAL$',pp$token)],as.numeric(names(tbl)))] <- 0
    
    a$usage[a$usage%in%c(NA,-1)] <- ""
    
    a$usage_type <- data.frame(table(sxx$line,sxx$warning_type),stringsAsFactors = FALSE)
    a$usage_type$Var1 <- as.numeric(as.character(a$usage_type$Var1))
    a$usage_type$Var2 <- as.character(a$usage_type$Var2)
    
    a
    
  })
  
  res$file_stats <- compute_file_stats_(res$full)
  
  res$file_stats$File <- add_link(names(res$full))
  
  res$file_stats <- sort_file_stats_(res$file_stats)
  
  res$file_stats$Usage <- add_color_box(res$file_stats$Usage)
  
  res
}

compute_file_stats_ <- function(files) {
  do.call("rbind",
          lapply(files,
                 function(file) {
                   data.frame(
                     Usage = sprintf("%.2f", (sum(file$usage != "") - sum(file$usage > 0)) / sum(file$usage != "") * 100),
                     'Relevant Symbols' = sum(file$usage != ""),
                     'Valid Symbols' = sum(file$usage != "") - sum(as.numeric(file$usage[(file$usage > 0)])),
                     'Problem Symbols' = sum(as.numeric(file$usage[(file$usage > 0)])),
                      General = sum(file$usage_type$Freq[file$usage_type$Var2=='general']),           
                     'Missing Global' = sum(file$usage_type$Freq[file$usage_type$Var2=='no_global_binding']),                     
                     'Unused Local' = sum(file$usage_type$Freq[file$usage_type$Var2=='unused_local']),
                     stringsAsFactors = FALSE,
                     check.names = FALSE)
                 }
          )
  )
}

sort_file_stats_ <- function(stats) {
  stats[order(as.numeric(stats$Usage), -stats$Relevant),
        c("Usage", "File", "Relevant Symbols","Valid Symbols", "Problem Symbols",'General','Missing Global','Unused Local')]
}

add_link <- function(files) {
  vcapply(files, function(file) { as.character(shiny::a(href = "#", file)) })
}

vcapply <- function(X, FUN, ...) vapply(X, FUN, ..., FUN.VALUE = character(1))

add_color_box <- function(nums) {
  
  vcapply(nums, function(num) {
    nnum <- as.numeric(num)
    if (nnum == 100) {
      as.character(shiny::div(class = "coverage-box coverage-high", num))
    } else if (nnum > 75) {
      as.character(shiny::div(class = "coverage-box coverage-medium", num))
    } else {
      as.character(shiny::div(class = "coverage-box coverage-low", num))
    }
  })
}

renderSourceTable <- function(data) {
  
  shiny::tags$div(id = "files",
                  Map(function(lines, file) {
                    shiny::tags$div(id = file, class="hidden",
                                    shiny::tags$table(class = "table-condensed",
                                                      shiny::tags$tbody(
                                                        lapply(seq_len(NROW(lines$line)),
                                                               function(row_num) {
                                                                 usage <- lines$usage[row_num]
                                                                 
                                                                 cov_type <- NULL
                                                                 if (usage == 0) {
                                                                   cov_value <- "!"
                                                                   cov_type <- "passed"
                                                                 } else if (usage > 0) {
                                                                   cov_value <- shiny::HTML(paste0(lines$usage[row_num], "<em>x</em>", collapse = ""))
                                                                   
                                                                   ctype <- unique(lines$usage_type$Var2[lines$usage_type$Var1==row_num&lines$usage_type$Freq>0])
                                                                   
                                                                   if(length(ctype)>1)
                                                                     ctype <- 'mix'
                                                                   
                                                                   cov_type <- ctype
                                                                   
                                                                 } else {
                                                                   cov_type <- "never"
                                                                   cov_value <- ""
                                                                 }
                                                                 shiny::tags$tr(class = cov_type,
                                                                                shiny::tags$td(class = "num", lines$line[row_num]),
                                                                                shiny::tags$td(class = "col-sm-12", shiny::pre(class = "language-r", lines$source[row_num])),
                                                                                shiny::tags$td(class = "coverage", cov_value)
                                                                 )
                                                               })
                                                      )
                                    ))
                  }, 
                  lines = data,
                  file = names(data)
                  ),
                  shiny::tags$script(
                    "$('div#files pre').each(function(i, block) {
                    hljs.highlightBlock(block);
});"))
}

#' @importFrom htmltools htmlDependency attachDependencies
#' @importFrom htmltools attachDependencies htmlDependencies
addHighlight <- function(x = list()) {
  highlight <- htmltools::htmlDependency("highlight.js", "6.2",
                                         system.file(package = "shiny",
                                                     "www/shared/highlight"),
                                         script = "highlight.pack.js",
                                         stylesheet = "rstudio.css")
  
  htmltools::attachDependencies(x, c(htmltools::htmlDependencies(x), list(highlight)))
}
