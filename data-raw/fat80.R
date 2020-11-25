## code to prepare `DATASET` dataset goes here

library(tidyr)
library(dplyr)
library(usethis)

# https://antsx.github.io/ANTsRNet/docs/reference/resampleTensor.html
# ANTsRNet::resampleTensor

broken_test_images <- c("1110505-2012")
broken_train_images <- c("600725-2013", "806365", "858488")

load(file = "data-raw/fat80_768x384.rda")

subarray <- function(arr, dim_names) {
  arr[dim_names,,]
}

remove_images <- function(data, test_names, train_names) {
  dtest_names <- setdiff(dimnames(data$test$image)[[1]], test_names)
  dtrain_names <- setdiff(dimnames(data$train$image)[[1]], train_names)

  list(
    train = purrr::map(data$train, subarray, dim_names = dtrain_names),
    test = purrr::map(data$test, subarray, dim_names = dtest_names)
  )
}

fat80_768x384 <- remove_images(
  fat80_768x384, broken_test_images, broken_train_images
)

dim(fat80_768x384$test$vsat)
dim(fat80_768x384$train$image)

# years <- seq(1900, 2017, by = 10)
# lifetables <- tbl_df(bind_rows(lapply(years, get_lifetables))) %>%
#   arrange(year, sex, x)
# readr::write_csv(
#   lifetables[1:nrow(lifetables) %% 100 == 0,],
#   "data-raw/lifetables_sample.csv")
# usethis::use_data(lifetables, compress = "xz", overwrite = T)

usethis::use_data(fat80_768x384, overwrite = TRUE)

# usethis::use_data(fat80_192x96, overwrite = TRUE)
