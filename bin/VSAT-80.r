cat("\n----\nCheatsheet\n----\n")

rm(list=ls())

library(keras)

mnist <- dataset_mnist()
train_images <- mnist$train$x
train_labels <- mnist$train$y
test_images <- mnist$test$x
test_labels <- mnist$test$y

str(mnist)

model <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = "relu", input_shape = c(28 * 28)) %>%
  layer_dense(units = 10, activation = "softmax")
model

401920 == 28*28*512 + 512
5130 == 512*10 + 10

model %>% compile(
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
)

str(train_images)
train_images <- array_reshape(train_images, c(60000, 28 * 28))
str(train_images)
train_images <- train_images / 255

str(test_images)
test_images <- array_reshape(test_images, c(10000, 28 * 28))
str(test_images)
test_images <- test_images / 255

train_labels <- to_categorical(train_labels)
str(train_labels)
test_labels <- to_categorical(test_labels)
str(train_labels)

model %>%
  fit(
    train_images, train_labels,
    epochs = 5, batch_size = 128)

metrics <- model %>%
  evaluate(test_images, test_labels)
metrics

model %>%
  predict_classes(test_images[1:10,])

digit <- mnist$test$x[5,,]
str(digit)
range(digit)
plot(as.raster(digit, max = 255))

digit <- mnist$test$x[1,,]
str(digit)
range(digit)
plot(as.raster(digit, max = 255))

# ?reticulate::array_reshape

x <- 1:4
dim(x) <- c(2,2)
x
keras::array_reshape(x, c(2, 2))

K <- keras::backend()

inputTensor <- K$ones( c( 2L, 10L, 10L, 3L ) )

# interpolationType: "nearestNeighbor", "linear", "cubic",
#    "bicubic", "bilinear", "nearest"

outputTensor <- ANTsRNet::resampleTensor(inputTensor, c(5, 5), "bicubic")
dim(outputTensor)
outputTensor[1,,,1]

## Chapter 3

# require(lubridate)
# ymd(as.Date('2020-11-01')) %m+% months(213)

layer <- layer_dense(units = 32, input_shape = c(784))

model <- keras_model_sequential() %>%
  layer_dense(units = 32, input_shape = c(784)) %>%
  layer_dense(units = 32)

# 3.2.3 Using the functional Keras API

library(keras)

input_tensor <- layer_input(shape = c(784))

output_tensor <- input_tensor %>%
  layer_dense(units = 512, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")

model <- keras_model(inputs = input_tensor, outputs = output_tensor)
model

model %>% compile(
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
)

model %>% fit(
  train_images, train_labels,
  epochs = 5, batch_size = 128
)

metrics <- model %>%
  evaluate(test_images, test_labels)
metrics

model %>%
  predict_classes(test_images[1:10,])
# Error in py_get_attr_impl(x, name, silent) :
#   AttributeError: 'Model' object has no attribute 'predict_classes'

model %>%
  fit(input_tensor, output_tensor, batch_size = 128, epochs = 10)
# Error in py_call_impl(callable, dots$args, dots$keywords) :
#   TypeError: int() argument must be a string, a bytes-like object or a number, not 'NoneType'


# 3.4.1. The IMDB dataset

library(keras)

imdb <- dataset_imdb(num_words = 10000)

c(c(train_data, train_labels), c(test_data, test_labels)) %<-% imdb

str(train_data[[1]])
train_labels[[1]]
max(purrr::map_dbl(train_data, max))

word_index <- dataset_imdb_word_index()
str(word_index)
word_index$fawn
word_index['fawn']
word_index[1:4]

reverse_word_index <- names(word_index)
str(reverse_word_index)
# reverse_word_index[[1]] # fawn
names(reverse_word_index) <- word_index
reverse_word_index[1:4]

str(train_data[[1]])

# Note that the indices are offset by 3 because
# 0, 1, and 2 are reserved indices for “padding,”
# “start of sequence,” and “unknown.”

decoded_review <- purrr::map_chr(train_data[[1]], function(index) {
  word <- if (index >= 3)
    reverse_word_index[[as.character(index - 3)]]
  if (!is.null(word)) word else "?"
})

str(decoded_review)


# 3.5.1. The Reuters dataset

library(keras)

reuters <- dataset_reuters(num_words = 10000)
str(reuters)
c(c(train_data, train_labels), c(test_data, test_labels)) %<-% reuters
str(train_data)
str(train_labels)

train_data[[1]]
train_labels[[1]]

word_index <- dataset_reuters_word_index()
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index

decoded_newswire <- purrr::map_chr(train_data[[1]], function(index) {
  word <- if (index >= 3)
    reverse_word_index[[as.character(index - 3)]]
  if (!is.null(word)) word else "?"
})

str(decoded_newswire)


# 3.6.1. The Boston Housing Price dataset

library(keras)

dataset <- dataset_boston_housing()
c(c(train_data, train_targets), c(test_data, test_targets)) %<-% dataset

str(train_data)
str(test_data)

# 3.6.4. Validating your approach using K-fold validation

k <- 3
# indices <- sample(1:18)
indices <- 1:18
folds <- cut(indices, breaks = k, labels = FALSE)
str(folds)

i = 1 # i = 2, i = 3
val_indices <- which(folds == i, arr.ind = TRUE)
val_indices
indices[val_indices]
indices[-val_indices]
