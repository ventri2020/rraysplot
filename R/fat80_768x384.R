#' fat80_768x384 metadata.
#'
#' Tensors created from 80 768x384 images of the 80 patients,
#' along with manually created masks for
#' subcutaneous adipose tissue (SCAT)
#' and visceral adipose tissue (VSAT).
#'
#' Lists of two lists training and test data, respectively.
#' train$image, train$mask, train$scat, train$vsat,
#' test$image, test$mask, test$scat, test$vsat,
#' where each tensor is an array of image data
#' with shape (70, 384, 192)
#' (integers in range 0-255 or 0-1).
#'
#' @source KM
#' @format A list of two lists:
#' \describe{
#' \item{train}{number of samples 70}
#' \item{test}{number of samples 10}
#' }
#' @examples
#' str(fat80_768x384)
"fat80_768x384"
