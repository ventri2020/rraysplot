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

  runif_mn <- array_mn(stats::runif(m * n))
  zeros_mn <- array_mn(rep(0, times = m * m))
  ones_mn <- array_mn(rep(1, times = m * m))

  zeros_m <- zeros_mn[1:m]
  zeros_n <- zeros_mn[1:n]

  rectangle_mn <- ones_mn
  rectangle_mn[1, ] <- zeros_n
  rectangle_mn[m, ] <- zeros_n
  rectangle_mn[, 1] <- zeros_m
  rectangle_mn[, n] <- zeros_m

  even_ceiling <- function(x) 2 * ceiling(x / 2)

  checker_mn <- function(m = 5, n = 5) {
    ord <- max(even_ceiling(c(m, n)))
    pat2 <- c(
      rep(0:1, times = ord / 2),
      rep(1:0, times = ord / 2)
    )
    array(pat2, dim = c(ord, ord))[1:m, 1:n]
  }

  list(
    checker = checker_mn(m, n),
    urandom = array(runif_mn, c(m, n)),
    zeros = zeros_mn,
    ones = ones_mn,
    rectangle = rectangle_mn
  )
}
