library(testthat)
library(tidycheckUsage)

testthat::test_that('environment functions',{
  myfun <- function(x){
    
    ret <- mtcars%>%
      mutate(mpg2=mpg*x)
    
    ret <- ret%>%
      dplyr::mutate(mpg3=mpg2^2)
    
  }
  
  
  x <- tidycheckUsage::checkUsage_dataframe(fun = myfun)  

  expect_s3_class(x,'data.frame')
  expect_equal(x$file[1],'test-checkUsage.R')
  expect_equal(x$fun[1],'myfun')
  expect_equal(x$object[1],'mutate')
})
