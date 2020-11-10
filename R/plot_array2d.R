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
#' @param title_size numeric
#'
#' @return ggplot object
#' @export
#' @examples
#' urandom <- make_arrays(m = 5, n = 5)$urandom
#' plot_array2d(urandom, title = "urandom", title_size = 32)
plot_array2d <- function(arr, title = NULL, title_size = 24) {
  d = dim(arr)

  vec = as.numeric(arr)
  maxi = max(vec)
  if (maxi == 0) maxi = 1

  col <- grDevices::rgb(vec, vec, vec, maxColorValue = maxi)

  # dt <- tidyr::expand_grid(x = 1:d[1], y = d[2]:1) %>%
  dt <- tidyr::expand_grid(x = 1:d[1], y = 1:d[2]) %>%
    dplyr::mutate(z = col)

  dt %>% ggplot2::ggplot(ggplot2::aes(x, y, fill = col)) +
    ggplot2::geom_raster() +
    ggplot2::labs(
      title = title,
      x = NULL,
      y = NULL
    ) +
    ggplot2::scale_fill_manual(
      values = as.character(levels(factor(col)))
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
        size = title_size,
        lineheight = 1,
        face = "bold",
        colour = "#f04747",
        hjust = 0.5
      ),
      legend.position = "none"
    )
}
