NULL

#' Tensors for U-Net Neural Nets
#'
#' Tensors were created from 151 768x384 images
#' of the 160 patients,
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
#' with shape: train -- 141x768x384, test -- 10x768x384,

#' Fat 768x384x1
#'
#' @format A list of tensors. Images resolution 768x384.
#' \describe{
#' \item{train}{number of samples 141}
#' \item{test}{number of samples 10}
#' }
"fat_768x384x1"

#' Fat 384x192x1
#'
#' @format A list of tensors. Images resolution 384x192.
#' \describe{
#' \item{train}{number of samples 141}
#' \item{test}{number of samples 10}
#' }
"fat_384x192x1"

#' Fat 192x96x1
#'
#' @format A list of tensors. Images resolution 192x96.
#' \describe{
#' \item{train}{number of samples 141}
#' \item{test}{number of samples 10}
#' }
"fat_192x96x1"
