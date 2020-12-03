#' Return a list of five 2D arrays
#'
#' Create five named 2D arrays: checker, urandom, zeros, ones, rectangle.
#'
#' @param images_dir character
#' @param extension character
#'
#' @return tibble
#' @export
#' @examples
#' \dontrun{
#' images_info("../80_images", extension = "dcm")
#' }
images_info <- function(images_dir, extension = "dcm") {
  image = "image_base|dicom_color|dicom_red|dicom_blue"
  splitter = glue::glue("^({images_dir})/([0-9-]+)/({image})/.*\\.(?:{extension})$")

  tibble::tibble(
    file_path = fs::dir_ls(
      path = images_dir,
      regexp = glue::glue(".*\\.({extension}$)"),
      recurse = TRUE
    ) %>%
      as.character() %>%
      stringr::str_subset(image)
  ) %>%
    tidyr::extract(
      col = file_path,
      into = c("series", "patient", "type"),
      regex = splitter,
      remove = FALSE
    ) %>%
    dplyr::mutate(
      kind = dplyr::recode(
        type,
        image_base = "MRI",
        dicom_color = "AT",
        dicom_red = "SCAT",
        dicom_blue = "VSAT"
      )
    ) %>%
    dplyr::arrange(patient, kind) %>%
    dplyr::select(3, 5, 4, 2, 1)
}

# What is the naming standard for path components?
# https://stackoverflow.com/questions/2235173/what-is-the-naming-standard-for-path-components
