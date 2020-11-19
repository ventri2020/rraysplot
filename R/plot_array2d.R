#' Return a ggplot of array
#'
#' Create ggplot from array
#'
#' @importFrom purrr %>% map map_dbl
#' @importFrom tidyr expand_grid
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes scale_fill_gradientn expansion
#' @importFrom ggplot2 coord_fixed element_blank element_text margin rel
#' @importFrom rlang duplicate
#' @importFrom grDevices rgb
#'
#' @param arrList array or list of 1, 2, or 3 arrays
#' @param title character
#' @param title_size numeric
#'
#' @return ggplot object
#' @export
#' @examples
#' urandom <- make_arrays(m = 5, n = 5)$urandom
#' plot_array2d(urandom, title = "urandom", title_size = 32)
plot_array2d <- function(arrList, title = NULL, title_size = 24) {
  # all arrays should have the same dimensions

  if (all(class(arrList) == c("matrix", "array"))) {
    arrList = list(arrList, arrList, arrList)
  }

  if (class(arrList) == "list" & length(arrList) == 2) {
    # insert into middle (green channel)
    zeros <- rlang::duplicate(arrList[[1]])
    zeros[,] <- 0
    arrList <- append(arrList, list(zeros), 1)
  }

  d = dim(arrList[[1]])

  # max in all arrays
  vecList <- purrr::map(arrList, as.numeric)
  maxi <- max(purrr::map_dbl(vecList, max, na.rm = TRUE))
  # avoid possible divide by zero below
  if (is.nan(maxi) | is.na(maxi) | maxi == 0) maxi = 1

  # col <- grDevices::rgb(
  #   vecList[[1]], vecList[[2]], vecList[[3]],
  #   maxColorValue = maxi
  # )
  col <- colorspace::hex(colorspace::RGB(
            vecList[[1]] / maxi, vecList[[2]] / maxi, vecList[[3]] / maxi
         ))
  col[col]
  # dt <- tidyr::expand_grid(x = 1:d[1], y = 1:d[2]) %>%
  # dt <- tidyr::expand_grid(x = 1:d[1], y = d[2]:1) %>%
  dt <- tibble::tibble(
    y = rev(rep(1:d[2], each = d[1])),
    x = rep(1:d[1], times = d[2])
  ) %>%
    dplyr::mutate(z = col)

  dt %>% ggplot2::ggplot(ggplot2::aes(x, y, fill = col)) +
    ggplot2::geom_raster() +
    ggplot2::labs(
      title = title,
      x = NULL,
      y = NULL
    ) +
    ggplot2::scale_fill_manual(
      values = as.character(levels(addNA(col, ifany = TRUE)))
    ) +
    # remove gray panel from the background
    ggplot2::coord_fixed(1, expand = FALSE) +
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

#' @export
#' @rdname plot_array2d
#' @param x character path of image or an object of class antsImage
#' @param title character
#' @param title_size numeric
plot_antsImage <- function(x, title, title_size) {
  ANTsRCore::check_ants(x)
}
