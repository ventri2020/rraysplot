images_info <- function(dicom_dir, extension = "dcm") {
  image = "image_base|dicom_color|dicom_red|dicom_blue"
  splitter = glue::glue("^({dicom_dir})/([0-9]+)/({image})/.*\\.(?:{extension})$")

  tibble::tibble(
    file_name = fs::dir_ls(
      path = "../80_images",
      regexp = glue::glue(".*\\.({extension}$)"),
      recurse = TRUE
    ) %>%
      as.character() %>%
      stringr::str_subset(image)
  ) %>%
    tidyr::extract(
      col = file_name,
      into = c("series", "patient", "image"),
      regex = splitter,
      remove = FALSE
    ) %>%
    dplyr::mutate(
      kind = dplyr::recode(
        image,
        image_base = "base",
        dicom_color = "fat",
        dicom_red = "subcutaneous_fat",
        dicom_blue = "visceral_fat"
      )
    ) %>%
    dplyr::arrange(patient, kind) %>%
    select(3, 5, 4, 2, 1)
}
