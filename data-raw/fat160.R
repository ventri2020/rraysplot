library(usethis)
library(keras)
library(ANTsRNet)

# ----

add_dimnames <- function(tensor, patients) {
  dimnames(tensor)[[1]] <- patients
  tensor
}

# ----

load(file = "data-raw/fat120_768x384.rda")
str(fat120_768x384)
length(fat120_768x384)
patients_current = dimnames(fat120_768x384$image)[[1]]
length(patients_current)

load(file = "data-raw/fat40e1_768x384.rda")
str(fat40e1_768x384)
length(fat40e1_768x384)
patients_extra = dimnames(fat40e1_768x384$image)[[1]]
length(patients_extra)

patients_all = c(patients_current, patients_extra)
length(patients_all)

# Join 4 tensors: image, mask, scat, vsat

merged_pairwise = purrr::map(
  names(fat120_768x384),
  ~ list(fat120_768x384[[.x]], fat40e1_768x384[[.x]])
)
merged_pairwise = purrr::set_names(merged_pairwise, names(fat120_768x384))
names(merged_pairwise)

fat160_768x384 <- list(
  as.array(k_concatenate(merged_pairwise[["image"]], axis = 1)),
  as.array(k_concatenate(merged_pairwise[["mask"]], axis = 1)),
  as.array(k_concatenate(merged_pairwise[["scat"]], axis = 1)),
  as.array(k_concatenate(merged_pairwise[["vsat"]], axis = 1))
)
dim(fat160_768x384[[1]])
dim(fat160_768x384[[2]])
dim(fat160_768x384[[3]])
dim(fat160_768x384[[4]])

fat160_768x384 = purrr::set_names(fat160_768x384, names(merged_pairwise))
names(fat160_768x384)
dim(fat160_768x384$image)

# Add dimnames to fat160_768x384$image, $mask, $scat, $vsat

dimnames(fat160_768x384$image)[[1]]
fat160_768x384 <- purrr::map(fat160_768x384, add_dimnames, patients_all)
dimnames(fat160_768x384$image)[[1]]
dim(fat160_768x384$image)

# Save all images

save(fat160_768x384, file = "data-raw/fat160_768x384.rda")

# Remove broken images & change to nested format

# from 120
broken_images_from_120 <- c(
  "1425191", "600725-2013", "1110505-2012",
  "1313380", "1211968", "858488",
  "806365", "878740"
)

# from 40, paczka 40_images_06.12.2020
broken_images_from_40 <- c("1460511")

unbroken_images <- setdiff(
  patients_all,
  c(broken_images_from_120, broken_images_from_40)
)

length(unbroken_images) # 151

# Update the broken lists below.
#   1. run the all-contact-sheets chunk in 20-contact_sheet.Rmd
#   2. check all images in data-contact-sheets/ directory

subarray <- function(tensor, patients) tensor[patients,,]

names(fat160_768x384)
length(fat160_768x384)
dim(fat160_768x384[[1]])
class(fat160_768x384)

# remove broken images
fat151_768x384 <- purrr::map(fat160_768x384, subarray, unbroken_images)
dimnames(fat151_768x384$image)[[1]]
dim(fat151_768x384$image)

(n_images <- dim(fat151_768x384$image)[[1]])

set.seed(202012)

test <- sort(sample(1:n_images, 10, replace = FALSE))
train <- sort((1:n_images)[-test])

str(test)
str(train)

fat_768x384 <- list(
  train = list(
    image = fat151_768x384$image[train,,],
    mask = fat151_768x384$mask[train,,],
    scat = fat151_768x384$scat[train,,],
    vsat = fat151_768x384$vsat[train,,]
  ),
  test = list(
    image = fat151_768x384$image[test,,],
    mask = fat151_768x384$mask[test,,],
    scat = fat151_768x384$scat[test,,],
    vsat = fat151_768x384$vsat[test,,]
  )
)

dim(fat_768x384$test$image)
dim(fat_768x384$train$image)
dimnames(fat_768x384$test$image)[[1]]
dimnames(fat_768x384$train$image)[[1]]

test_dimnames <- dimnames(fat_768x384$test$image)[[1]]
train_dimnames <- dimnames(fat_768x384$train$image)[[1]]
test_dimnames
train_dimnames

encode_data <- function(data, dims = c(768, 384)) {
  train_shape <- c(dim(data$train$image)[1], dims, 1)
  test_shape <- c(dim(data$test$image)[1], dims, 1)

  r_reshape <- purrr::compose(as.array, keras::k_reshape)

  list(
    train = purrr::map(data$train, r_reshape, shape = train_shape),
    test = purrr::map(data$test, r_reshape, shape = test_shape)
  )
}

fat_768x384x1 <- encode_data(fat_768x384, dims = c(768, 384))

dimnames(fat_768x384x1$test$image)[[1]]

add_dimnames_to_data <- function(data, train_names, test_names) {
  train = purrr::map(data$train, add_dimnames, train_names)
  test = purrr::map(data$test, add_dimnames, test_names)
  list(train = train, test = test)
}

fat_768x384x1 <- add_dimnames_to_data(
  fat_768x384x1,
  train_names = train_dimnames,
  test_names = test_dimnames
)

dimnames(fat_768x384x1$test$image)[[1]]
dimnames(fat_768x384x1$train$image)[[1]]

usethis::use_data(fat_768x384x1, overwrite = TRUE)

# Resample data to 384x192x1 and 384x192x1

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
