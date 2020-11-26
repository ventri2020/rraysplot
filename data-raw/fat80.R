library(usethis)
library(keras)
library(ANTsRNet)

broken_test_images <- c("1110505-2012")
broken_train_images <- c("600725-2013", "806365", "858488")

load(file = "data-raw/fat80_768x384.rda")

subarray <- function(arr, dim_names) arr[dim_names,,]

remove_images <- function(data, test_names, train_names) {
  dtest_names <- setdiff(dimnames(data$test$image)[[1]], test_names)
  dtrain_names <- setdiff(dimnames(data$train$image)[[1]], train_names)

  list(
    train = purrr::map(data$train, subarray, dim_names = dtrain_names),
    test = purrr::map(data$test, subarray, dim_names = dtest_names)
  )
}

fat_768x384 <- remove_images(
  fat80_768x384, broken_test_images, broken_train_images
)

# dim(fat_768x384$test$vsat)
# dim(fat_768x384$train$image)

encode_data <- function(data, dims = c(768, 384)) {
  train_shape <- c(67, dims, 1)
  test_shape <- c(9, dims, 1)

  r_reshape <- purrr::compose(as.array, keras::k_reshape)

  list(
    train = purrr::map(data$train, r_reshape, shape = train_shape),
    test = purrr::map(data$test, r_reshape, shape = test_shape)
  )
}

fat_768x384x1 <- encode_data(fat_768x384, dims = c(768, 384))

# dim(fat_768x384x1$test$vsat)
# dim(fat_768x384x1$train$image)

usethis::use_data(fat_768x384x1, overwrite = TRUE)

resample_data <- function(data, dims = c(768, 384)) {
  resampleArray <- purrr::compose(as.array, ANTsRNet::resampleTensor)

  train = purrr::map(data$train, resampleArray, shape = dims)
  test = purrr::map(data$test, resampleArray, shape = dims)

  list(train = train, test = test)
}

fat_384x192x1 = resample_data(fat_768x384x1, dims = c(384, 192))

# dim(fat_384x192x1$test$vsat)
# dim(fat_384x192x1$train$image)

usethis::use_data(fat_384x192x1, overwrite = TRUE)

fat_192x96x1 = resample_data(fat_384x192x1, dims = c(192, 96))

# dim(fat_192x96x1$test$vsat)
# dim(fat_192x96x1$train$image)

usethis::use_data(fat_192x96x1, overwrite = TRUE)

