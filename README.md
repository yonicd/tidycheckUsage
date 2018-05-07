# tidycheckUsage

When using magrittr pipes or ggplot2 reading the objects that you forgot
to `enquo` is a pain. These functions can be run prior to
`devtools::check` to return a `data.frame` containing all the warnings
created when `check` runs `codetools::checkUsage`.

## Installation

You can install tidycheckUsage with:

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

checkUsagePackage_dataframe('dplyr')
```
|file |path |line1 |line2 |fun                    |object      |warning                                                   |
|:----|:----|:-----|:-----|:----------------------|:-----------|:---------------------------------------------------------|
|     |     |      |      |as.tbl_cube.data.frame |dupe        |local variable ‘dupe’ assigned but may not be used        |
|     |     |      |      |do.rowwise_df          |index       |local variable ‘index’ assigned but may not be used       |
|     |     |      |      |fmt_cols               |cols        |local variable ‘cols’ assigned but may not be used        |
|     |     |      |      |fmt_measures           |measures    |local variable ‘measures’ assigned but may not be used    |
|     |     |      |      |fmt_pos_args           |args        |local variable ‘args’ assigned but may not be used        |
|     |     |      |      |order_by               |type        |local variable ‘type’ assigned but may not be used        |
|     |     |      |      |select_var             |type        |local variable ‘type’ assigned but may not be used        |
|     |     |      |      |select_vars            |first_type  |local variable ‘first_type’ assigned but may not be used  |
|     |     |      |      |switch_rename          |actual_type |local variable ‘actual_type’ assigned but may not be used |


### Built Packages

``` r
system('git clone https://github.com/hrbrmstr/slackr.git')
devtools::install('slackr')
```

``` r
checkUsagePackage_dataframe('slackr')
```
|file         |path                                     |line1 |line2 |fun        |object   |warning                                                |
|:------------|:----------------------------------------|:-----|:-----|:----------|:--------|:------------------------------------------------------|
|slackr.R     |/Users/jonathans/projects/forks/slackr/R |41    |41    |slackr     |resp_ret |local variable ‘resp_ret’ assigned but may not be used |
|slackr_bot.r |/Users/jonathans/projects/forks/slackr/R |57    |57    |slackr_bot |resp_ret |local variable ‘resp_ret’ assigned but may not be used |
|slackr_bot.r |/Users/jonathans/projects/forks/slackr/R |57    |57    |slackrBot  |resp_ret |local variable ‘resp_ret’ assigned but may not be used |

### Functions in Environment

``` r
myfun <- function(x){
  
  ret <- mtcars%>%
    mutate(mpg2=mpg*x)
  
  ret <- ret%>%
    dplyr::mutate(mpg3=mpg2^2)
  
}

checkUsage_dataframe(fun = myfun)
```

|file |path |line1 |line2 |fun   |object |warning                                            |
|:----|:----|:-----|:-----|:-----|:------|:--------------------------------------------------|
|     |     |3     |4     |myfun |%>%    |no visible global function definition for ‘%>%’    |
|     |     |3     |4     |myfun |mutate |no visible global function definition for ‘mutate’ |
|     |     |3     |4     |myfun |mpg    |no visible binding for global variable ‘mpg’       |
|     |     |6     |7     |myfun |%>%    |no visible global function definition for ‘%>%’    |
|     |     |6     |7     |myfun |mpg2   |no visible binding for global variable ‘mpg2’      |
