library(usethis)
library(keras)
library(ANTsRNet)

load(file = "data-raw/fat120_768x384.rda")
str(fat120_768x384)
length(fat120_768x384)

# Update the broken lists below.
#   1. run the all-contact-sheets chunk in 20-contact_sheet.Rmd
#   2. check all images in data-contact-sheets/ directory

# 1425191 600725-2013 1110505-2012
# 1313380 1211968 858488 806365 878740

# broken_images <- c(
#   "1425191", "600725-2013", "1110505-2012",
#   "1313380", "1211968", "858488",
#   "806365", "878740"
# )

# Paczka 40_images_06.12.2020
broken_images <- c("1460511")

subarray <- function(arr, dim_names) arr[dim_names,,]

remove_images <- function(data, patients) {
  dnames <- setdiff(dimnames(data$image)[[1]], patients)
  purrr::map(data, subarray, dim_names = dnames)
}

fat_768x384 <- remove_images(fat120_768x384, broken_images)

str(fat_768x384)
n_images <- dim(fat_768x384$image)[1]

set.seed(202012)
test <- sort(sample(1:n_images, 10, replace = FALSE))
train <- sort((1:n_images)[-test])

str(train)
str(test)

fat120_768x384 <- list(
  train = list(
    image = fat_768x384$image[train,,],
    mask = fat_768x384$mask[train,,],
    scat = fat_768x384$scat[train,,],
    vsat = fat_768x384$vsat[train,,]
  ),
  test = list(
    image = fat_768x384$image[test,,],
    mask = fat_768x384$mask[test,,],
    scat = fat_768x384$scat[test,,],
    vsat = fat_768x384$vsat[test,,]
  )
)

dim(fat120_768x384$test$image)
dim(fat120_768x384$train$image)
# dimnames(fat120_768x384$test$image)[[1]]
# dimnames(fat120_768x384$train$image)[[1]]

test_dimnames <- dimnames(fat120_768x384$test$image)[[1]]
train_dimnames <- dimnames(fat120_768x384$train$image)[[1]]
test_dimnames
train_dimnames

add_dimnames <- function(tensor, dim_names) {
  dimnames(tensor)[[1]] <- dim_names
  tensor
}

add_dimnames_to_data <- function(data, train_names, test_names) {
  train = purrr::map(data$train, add_dimnames, train_names)
  test = purrr::map(data$test, add_dimnames, test_names)
  list(train = train, test = test)
}

encode_data <- function(data, dims = c(768, 384)) {
  train_shape <- c(dim(fat120_768x384$train$image)[1], dims, 1)
  test_shape <- c(dim(fat120_768x384$test$image)[1], dims, 1)

  r_reshape <- purrr::compose(as.array, keras::k_reshape)

  list(
    train = purrr::map(data$train, r_reshape, shape = train_shape),
    test = purrr::map(data$test, r_reshape, shape = test_shape)
  )
}

fat_768x384x1 <- encode_data(fat120_768x384, dims = c(768, 384))

fat_768x384x1 <- add_dimnames_to_data(
  fat_768x384x1,
  train_names = train_dimnames,
  test_names = test_dimnames
)

dimnames(fat_768x384x1$test$image)[[1]]
dimnames(fat_768x384x1$train$image)[[1]]

usethis::use_data(fat_768x384x1, overwrite = TRUE)

resample_data <- function(data, dims) {
  resampleArray <- purrr::compose(as.array, ANTsRNet::resampleTensor)

  train = purrr::map(data$train, resampleArray, shape = dims)
  test = purrr::map(data$test, resampleArray, shape = dims)

  list(train = train, test = test)
}

fat_384x192x1 = resample_data(fat_768x384x1, dims = c(384, 192))

fat_384x192x1 <- add_dimnames_to_data(
  fat_384x192x1,
  train_names = train_dimnames,
  test_names = test_dimnames
)

dim(fat_384x192x1$test$vsat)
dim(fat_384x192x1$train$image)
dimnames(fat_384x192x1$test$image)[[1]]
dimnames(fat_384x192x1$train$image)[[1]]

usethis::use_data(fat_384x192x1, overwrite = TRUE)

fat_192x96x1 = resample_data(fat_384x192x1, dims = c(192, 96))

fat_192x96x1 <- add_dimnames_to_data(
  fat_192x96x1,
  train_names = train_dimnames,
  test_names = test_dimnames
)

dim(fat_192x96x1$test$vsat)
dim(fat_192x96x1$train$image)
dimnames(fat_192x96x1$test$image)[[1]]
dimnames(fat_192x96x1$train$image)[[1]]

usethis::use_data(fat_192x96x1, overwrite = TRUE)
