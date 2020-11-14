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
