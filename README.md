
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidycheckUsage

When using magrittr pipes or ggplot2 reading the objects that you forgot
to `enquo` is a pain. These functions can be run prior to
`devtools::check` to return a `data.frame` containing all the warnings
created when `check` runs `codetools::checkUsage`.

## Installation

You can install tidynm from ghe with:

``` r
remotes::install_github('yonicd/tidycheckUsage')
```

## Examples

### Installed Packages

``` r
library(tidycheckUsage)
```

``` r
install.packages(c('dplyr'))
```

``` r
library(dplyr,warn.conflicts = FALSE,quietly = TRUE)

knitr::kable(tidycheckUsagePackage('dplyr'))
```

|file |line |object      |col1 |col2 |path |fun                    |warning                                                   |
|:----|:----|:-----------|:----|:----|:----|:----------------------|:---------------------------------------------------------|
|     |     |dupe        |     |     |     |as.tbl_cube.data.frame |local variable ‘dupe’ assigned but may not be used        |
|     |     |index       |     |     |     |do.rowwise_df          |local variable ‘index’ assigned but may not be used       |
|     |     |cols        |     |     |     |fmt_cols               |local variable ‘cols’ assigned but may not be used        |
|     |     |measures    |     |     |     |fmt_measures           |local variable ‘measures’ assigned but may not be used    |
|     |     |args        |     |     |     |fmt_pos_args           |local variable ‘args’ assigned but may not be used        |
|     |     |type        |     |     |     |order_by               |local variable ‘type’ assigned but may not be used        |
|     |     |type        |     |     |     |select_var             |local variable ‘type’ assigned but may not be used        |
|     |     |first_type  |     |     |     |select_vars            |local variable ‘first_type’ assigned but may not be used  |
|     |     |actual_type |     |     |     |switch_rename          |local variable ‘actual_type’ assigned but may not be used |
### Built Packages

``` r
system('git clone https://github.com/hrbrmstr/slackr.git')
devtools::install('slackr')
```

``` r
tidycheckUsagePackage('slackr')
```

|file         |line |object   |col1 |col2 |path                                     |fun        |warning                                                |
|:------------|:----|:--------|:----|:----|:----------------------------------------|:----------|:------------------------------------------------------|
|slackr_bot.r |57   |resp_ret |3    |10   |/Users/jonathans/projects/forks/slackr/R |slackr_bot |local variable ‘resp_ret’ assigned but may not be used |
|slackr_bot.r |57   |resp_ret |3    |10   |/Users/jonathans/projects/forks/slackr/R |slackrBot  |local variable ‘resp_ret’ assigned but may not be used |
|slackr.R     |41   |resp_ret |3    |10   |/Users/jonathans/projects/forks/slackr/R |slackr     |local variable ‘resp_ret’ assigned but may not be used |

### Functions in Environment

``` r

myfun <- function(x){
  
  ret <- mtcars%>%
    mutate(mpg2=mpg*x)
  
  ret <- ret%>%
    dplyr::mutate(mpg3=mpg2^2)
  
}

tidycheckUsage(fun = myfun)
```

|file |line |object |col1 |col2 |path |fun   |warning                                            |
|:----|:----|:------|:----|:----|:----|:-----|:--------------------------------------------------|
|     |3    |%>%    |16   |18   |     |myfun |no visible global function definition for ‘%>%’    |
|     |4    |mpg    |17   |19   |     |myfun |no visible binding for global variable ‘mpg’       |
|     |4    |mutate |5    |10   |     |myfun |no visible global function definition for ‘mutate’ |
|     |6    |%>%    |13   |15   |     |myfun |no visible global function definition for ‘%>%’    |
|     |7    |mpg2   |24   |27   |     |myfun |no visible binding for global variable ‘mpg2’      |

## HTML Report outputs

Forking `covr::report` a similar output is created for symbol usage in `R` scripts.

```r
tidycheckUsage::usage_report(tidycheckUsagePackage('sinew'))
```

### Summary statistics for symbol usage

Number of relevant symbols are counted then categorized by usage warnings:

  - Valid symbols (no warnings or notes)
  - Problem symbols that generate warnings in `codetools`
    - General: Neither Missing Global or Unused Local
    - Missing Global: symbols that generate a warning: 'no visible binding for global variable'
    - Unused Local: symbols that generate a warning: 'local variable is assigned but may not be used'

![](https://github.com/yonicd/tidycheckUsage/blob/covr_report/Misc/Images/frontmatter.png?raw=true)

### Within Script Investigations

#### Red indicates no visible binding for global variable
![](https://github.com/yonicd/tidycheckUsage/blob/covr_report/Misc/Images/missing_global.png?raw=true)


#### Orange indicates local variable is assigned but may not be used
![](https://github.com/yonicd/tidycheckUsage/blob/covr_report/Misc/Images/unused_local.png?raw=true)


## Appending `rlang`

More often than not when a `missing global` pops up it ussually means that you are using [non-standard evaluation](http://adv-r.had.co.nz/Computing-on-the-language.html) and need to place `rlang` syntax instead of calling the object itself within a `tidyverse` call.

To help make this painless the output from `tidycheckUsage` is used to find and replace all those objects.

```r
x <- function(){
  
  data <- tidyr::unite(mtcars, col = vs_am, c(vs,am))
  
  ggplot2::ggplot(data = data, ggplot2::aes(x=mpg,y=qsec,colour=vs_am)) + 
  ggplot2::geom_point()
}

tidycheckUsage(x)
  file line object col1 col2 path fun      warning_type                                        warning
1         3     am   50   51        x no_global_binding    no visible binding for global variable ‘am’
2         3     vs   47   48        x no_global_binding    no visible binding for global variable ‘vs’
3         3  vs_am   38   42        x no_global_binding no visible binding for global variable ‘vs_am’
4         5    mpg   47   49        x no_global_binding   no visible binding for global variable ‘mpg’
5         5   qsec   53   56        x no_global_binding  no visible binding for global variable ‘qsec’
6         5  vs_am   65   69        x no_global_binding no visible binding for global variable ‘vs_am’

(x1 <- append_rlang(x))
function () 
{
    data <- tidyr::unite(mtcars, col = !!rlang::sym('vs_am'), c(!!rlang::sym('vs'), !!rlang::sym('am')))
    ggplot2::ggplot(data = data, ggplot2::aes(x = !!rlang::sym('mpg'), y = !!rlang::sym('qsec'), 
        colour = !!rlang::sym('vs_am'))) + ggplot2::geom_point()
}
<environment: 0x10ceb96d8>

tidycheckUsage(x1)
NULL

x1()
```

![](https://github.com/yonicd/tidycheckUsage/blob/covr_report/Misc/Images/rlang_example.png?raw=true)