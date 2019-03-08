library(testthat)
library(tidycheckUsage)

testthat::context('package functions')

testthat::test_that('package',{
  
  x <- tidycheckUsage::tidycheckUsagePackage(pack = 'tidycheckUsage')
  
  expect_s3_class(x,'data.frame')
  expect_equal(nrow(x),3)

})
