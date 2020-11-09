#' Return a list of five 2D arrays
#'
#' Create five named 2D arrays: checker, urandom, zeros, ones, rectangle.
#'
#' @param m numeric
#' @param n numeric
#'
#' @return list of five named 2D arrays
#' @export
#' @examples
#' make_arrays(5, 5)
make_arrays <- function(m = 5, n = 5) {
  array_mn <- function(vec_mn) array(vec_mn, dim = c(m, n))

  runif_mn <- array_mn(runif(m * n))
  zeros_mn <- array_mn(rep(0, times = m * m))
  ones_mn <- array_mn(rep(1, times = m * m))

  ones_m <- ones_mn[1:m]
  ones_n <- ones_mn[1:n]

  rectangle_mn <- zeros_mn
  rectangle_mn[1, ] <- ones_n
  rectangle_mn[m, ] <- ones_n
  rectangle_mn[, 1] <- ones_m
  rectangle_mn[, n] <- ones_m

  list(
    checker = array(NA, c(m, n)),
    urandom = array(runif_mn, c(m, n)),
    zeros = zeros_mn,
    ones = ones_mn,
    rectangle = rectangle_mn
  )
}
