#' Return a ggplot of array
#'
#' Create ggplot from array
#'
#' @importFrom rlang .data
#'
#' @importFrom purrr %>% map map_dbl
#' @importFrom tidyr expand_grid
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes scale_fill_gradientn expansion
#' @importFrom ggplot2 coord_fixed element_blank element_text margin rel
#' @importFrom rlang duplicate
#' @importFrom grDevices rgb
#' @importFrom colorspace RGB mixcolor
#'
#' @param arrList array or list of 1, 2, or 3 arrays
#' @param title character
#' @param title_size numeric
#'
#' @return ggplot object
#' @export
#' @examples
#' urandom <- make_arrays(m = 5, n = 5)$urandom
#' plot_array2d(urandom, title = "urandom", title_size = 24)
plot_array2d <- function(arrList, title = NULL, title_size = 18) {
  # all arrays should have the same dimensions

  if (all(class(arrList) == c("matrix", "array"))) {
    arrList = list(arrList, arrList, arrList)
  }

  if (class(arrList) == "list" & length(arrList) == 1) {
    zeros <- rlang::duplicate(arrList[[1]])
    zeros[,] <- 0
    arrList <- list(arrList[[1]], zeros, zeros)
  }

  if (class(arrList) == "list" & length(arrList) == 2) {
    # insert into middle (green channel)
    zeros <- rlang::duplicate(arrList[[1]])
    zeros[,] <- 0
    arrList <- append(arrList, list(zeros), 1)
  }

  if (class(arrList) == "list" & length(arrList) == 3) {
    arrList <- list(arrList[[1]], 0.5 * arrList[[2]], arrList[[3]])
  }

  d = dim(arrList[[1]])

  # max in all arrays
  vecList <- purrr::map(arrList, as.numeric)
  maxi <- max(purrr::map_dbl(vecList, max, na.rm = TRUE), na.rm = TRUE)
  # avoid possible divide by -Inf or 0
  if (!is.finite(maxi) | maxi == 0) maxi = 1

  col <- colorspace::RGB(
    vecList[[1]]/maxi,
    vecList[[2]]/maxi,
    vecList[[3]]/maxi
  )
  col_hex <- colorspace::hex(col)

  dt <- tibble::tibble(
    y = rev(rep(1:d[2], each = d[1])),
    x = rep(1:d[1], times = d[2])
  ) %>%
    dplyr::mutate(z = col_hex)

  dt %>% ggplot2::ggplot(ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_raster(ggplot2::aes(fill = .data$z)) +
    ggplot2::labs(
      title = title,
      x = NULL,
      y = NULL
    ) +
    ggplot2::scale_fill_manual(
      values = as.character(levels(factor(col_hex))),
      na.value = "#ffd015"
    ) +
    # hide the gray panel from the background
    ggplot2::coord_fixed(1, expand = FALSE) +
    ggplot2::theme(
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        margin = ggplot2::margin(t = 2, b = 4), # ?margin
        size = title_size,
        lineheight = 1,
        face = "bold",
        colour = "black",
        hjust = 0.5
      ),
      legend.position = "none"
    )
}

#' Create ggplot from image and mask
#'
#' @rdname plotBlendedImages
#'
#' @param img antsImage
#' @param mask antsImage
#' @param alpha numeric
#' @param title character
#' @param title_size numeric
#'
#' @return ggplot object
#' @export
plotBlendedImages <- function(
    img, mask, alpha = 0.35,
    title = NULL, title_size = 16
) {
  d = dim(mask)

  ivec <- as.numeric(img)
  mvec <- as.numeric(mask)

  maxi <- max(ivec, na.rm = TRUE)
  # avoid possible divide by -Inf or 0
  if (!is.finite(maxi) | maxi == 0) maxi = 1

  icol <- colorspace::RGB(ivec/maxi, ivec/maxi, ivec/maxi)
  mcol <- colorspace::RGB(mvec, 0, mvec)
  blended_col = colorspace::mixcolor(alpha, icol, mcol)
  blended_hex <- colorspace::hex(blended_col, fixup = FALSE)

  dt <- tibble::tibble(
    y = rev(rep(1:d[2], each = d[1])),
    x = rep(1:d[1], times = d[2])
  ) %>%
    dplyr::mutate(z = blended_hex)

  dt %>% ggplot2::ggplot(ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_raster(aes(fill = blended_hex)) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ggplot2::scale_fill_manual(
      values = as.character(levels(factor(blended_hex)))
    ) +
    ggplot2::coord_fixed(1, expand = FALSE) +
    ggplot2::theme(
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        margin = ggplot2::margin(t = 2, b = 4), # ?margin
        size = title_size,
        lineheight = 1,
        face = "bold",
        colour = "deeppink4",
        hjust = 0.5
      ),
      legend.position = "none"
    )
}

#' Create ggplot from array and mask
#'
#' @rdname plot2_array2d
#'
#' @param arrList array or list of 1, 2, or 3 arrays
#' @param maskList array or list of 1, 2, or 3 arrays
#' @param alpha numeric
#' @param title character
#' @param title_size numeric
#'
#' @return ggplot object
#' @export
#' @examples
#' urandom <- make_arrays(m = 5, n = 5)$urandom
#' square <- make_arrays(m = 5, n = 5)$rectangle
#' plot2_array2d(urandom, square, title = "urandom*square", title_size = 18)
plot2_array2d <- function(
    arrList, maskList = NULL, alpha = 0.35,
    title = NULL, title_size = 18
) {
  if (all(class(arrList) == c("matrix", "array"))) {
    arrList <- list(arrList, arrList, arrList)
  }
  if (class(arrList) == "list" & length(arrList) == 2) {
    arrList <- list(arrList[[1]], arrList[[1]] * 0, arrList[[2]])
  }

  d = dim(arrList[[1]])

  if (!is.null(maskList)) {
    if (all(class(maskList) == c("matrix", "array"))) {
      # maskList[maskList == 0] <- NA
      maskList <- list(maskList, maskList * 0, maskList)
    }
    if (class(maskList) == "list" & length(maskList) == 2) {
      maskList <- list(maskList[[1]], maskList[[1]] * 0, maskList[[2]])
    }
  } else {
    ones <- array(1, dim = d)
    maskList = list(ones, ones, ones)
  }

  # max in all arrays
  ivecList <- purrr::map(arrList, as.numeric)
  maxi <- max(purrr::map_dbl(ivecList, max, na.rm = TRUE), na.rm = TRUE)
  # avoid possible divide by -Inf or 0
  if (!is.finite(maxi) | maxi == 0) maxi = 1

  mvecList <- purrr::map(maskList, as.numeric)

  icol <- colorspace::RGB(
    ivecList[[1]]/maxi, ivecList[[2]]/maxi, ivecList[[3]]/maxi
  )
  mcol <- colorspace::RGB(
    mvecList[[1]], mvecList[[2]], mvecList[[3]]
  )
  blended_col = colorspace::mixcolor(alpha, icol, mcol)
  blended_hex <- colorspace::hex(blended_col, fixup = FALSE)

  dt <- tibble::tibble(
    y = rev(rep(1:d[2], each = d[1])),
    x = rep(1:d[1], times = d[2])
  ) %>%
    dplyr::mutate(z = blended_hex)

  dt %>% ggplot2::ggplot(ggplot2::aes(.data$x, .data$y)) +
    ggplot2::geom_raster(ggplot2::aes(fill = .data$z)) +
    ggplot2::labs(
      title = title,
      x = NULL,
      y = NULL
    ) +
    ggplot2::scale_fill_manual(
      values = as.character(levels(factor(blended_hex))),
      na.value = "#ffd015"
    ) +
    # remove gray panel from the background
    ggplot2::coord_fixed(1, expand = FALSE) +
    ggplot2::theme(
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        margin = ggplot2::margin(t = 2, b = 4), # ?margin
        size = title_size,
        lineheight = 1,
        face = "bold",
        colour = "gold4",
        hjust = 0.5
      ),
      legend.position = "none"
    )
}
