NULL

#' Tensors for U-Net Neural Nets
#'
#' Tensors were created from 80 768x384 images
#' of the 80 patients,
#' along with manually created masks for
#' subcutaneous adipose tissue (SCAT)
#' and visceral adipose tissue (VSAT).
#'
#' Tensors are arranged into two lists,
#' train and test list, respectively.
#' There are eight tensors:
#' train$image, train$mask, train$scat, train$vsat,
#' test$image, test$mask, test$scat, test$vsat.
#'
#' Each tensor is an array of image data
#' with shape: train -- (67, 384, 192), test -- (67, 384, 192)
#'

#' @format A list of tensors. Images resolution 768x384.
#' \describe{
#' \item{train}{number of samples 67}
#' \item{test}{number of samples 9}
#' }
"fat_768x384x1"

#' @format A list of tensors. Images resolution 384x192.
#' \describe{
#' \item{train}{number of samples 67}
#' \item{test}{number of samples 9}
#' }
"fat_384x192x1"

#' @format A list of tensors. Images resolution 192x96.
#' \describe{
#' \item{train}{number of samples 67}
#' \item{test}{number of samples 9}
#' }
"fat_192x96x1"
