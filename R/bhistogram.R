#' Return a binned histogram of array or vector
#'
#' Create binned histogram for numeric data
#'
#' @importFrom rlang .data
#'
#' @importFrom tibble tibble
#' @importFrom dplyr mutate
#' @importFrom scales rescale
#' @importFrom ggplot2 ggplot aes geom_bar element_text
#' @importFrom ggplot2 scale_y_continuous scale_x_binned
#'
#' @param v numeric
#' @param title character
#' @param title_size numeric
#' @param n_breaks numeric
#'
#' @return ggplot object
#' @export
#' @examples
#' mm = c(rnorm(1500, 0, .1), rnorm(1000, 1, .2))
#' bhistogram(mm, title = "Multimodal frequencies", title_size = 14)
bhistogram <- function(
    v, title = NULL, title_size = 14, n_breaks = 10
) {
  rv <- scales::rescale(v, to = c(0,1), from = range(v, na.rm = TRUE))
  tb <- tibble::tibble(value = as.numeric(rv))

  ggplot2::ggplot(tb, ggplot2::aes(x = .data$value)) +
    ggplot2::geom_bar(fill = "#312271") +
    ggplot2::scale_x_binned(
      n.breaks = n_breaks,
      limits = c(0, 1)
    ) +
    ggplot2::labs(
      title = title,
      x = "value (0 \u2013 black, 1 \u2013 white)",
      y = "binned counts"
    ) +
    ggplot2::scale_y_continuous(
      # breaks = c(50000, 100000, 150000, 200000, 250000),
      # limits = c(0, 768 * 384)
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        size = title_size,
        color = "#312271"
      )
    )
}
