# images_list <- function(dicom_dir) {
#   image = "image_base|dicom_color|dicom_red|dicom_blue"
#
#   paths = list.files(
#     path = dicom_dir,
#     pattern = ".*\\.dcm$",
#     full.names = TRUE,
#     recursive = TRUE
#   ) %>%
#     stringr::str_subset(image)
# }
