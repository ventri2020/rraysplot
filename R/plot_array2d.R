#' Return a ggplot of array
#'
#' Create ggplot from array
#'
#' @importFrom purrr %>%
#' @importFrom tidyr expand_grid
#' @importFrom ggplot2 ggplot aes scale_fill_gradientn expansion
#' @importFrom ggplot2 coord_fixed element_blank element_text margin rel
#'
#' @param arr array
#' @param title character
#'
#' @return ggplot object
#' @export
#' @examples
#' urandom <- make_arrays(m = 5, n = 5)$urandom
#' plot_array2d(urandom)
plot_array2d <- function(arr, title = NULL) {
  d <- dim(arr)
  dt <- tidyr::expand_grid(x = 1:d[1], y = 1:d[2]) %>%
    dplyr::mutate(z = as.numeric(arr))

  dt %>% ggplot2::ggplot(ggplot2::aes(x, y, fill = z)) +
    ggplot2::geom_raster() +
    ggplot2::labs(
      title = title,
      x = NULL,
      y = NULL
    ) +
    ggplot2::scale_fill_gradientn(
      colors = grDevices::gray.colors(128, start = 0, end = 1),
      expand = ggplot2::expansion(mult = c(0, .1))
    ) +
    ggplot2::coord_fixed(
      1,
      expand = FALSE # removes gray panel from the background
    ) +
    ggplot2::theme(
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        margin = ggplot2::margin(t = 8, b = 16), # ?margin
        size = ggplot2::rel(1.6),
        lineheight = 1,
        face = "bold",
        colour = "red",
        hjust = 0.5
      ),
      legend.position = "none"
    )
}
