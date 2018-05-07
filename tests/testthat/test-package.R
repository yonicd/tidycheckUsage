library(testthat)
library(tidycheckUsage)

testthat::test_that('package',{
  
  x <- tidycheckUsage::checkUsagePackage_dataframe(pack = 'tidytext')
  
  expect_s3_class(x,'data.frame')
  expect_equal(x$file[1],'')
  expect_equal(nrow(x),17)

  detach("package:tidytext", unload=TRUE)
    
})
