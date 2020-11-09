test_that("make_arrays return a list of five 2D arrays", {
  ar5 <- make_arrays()
  d2 <- length(dim(ar5$zeros))

  expect_length(ar5, 5)
  expect_named(ar5, c("checker", "urandom", "zeros", "ones", "rectangle"))
  expect_type(ar5, "list")
  expect_true(is.array(ar5$urandom))
  expect_true(is.matrix(ar5$urandom))
  expect_equal(d2, 2)
})
