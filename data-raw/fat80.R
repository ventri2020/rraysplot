## code to prepare `DATASET` dataset goes here

library(tidyr)
library(dplyr)
library(usethis)

# https://antsx.github.io/ANTsRNet/docs/reference/resampleTensor.html
# ANTsRNet::resampleTensor
library(ANTsRNet)

# years <- seq(1900, 2017, by = 10)
# lifetables <- tbl_df(bind_rows(lapply(years, get_lifetables))) %>%
#   arrange(year, sex, x)
# readr::write_csv(
#   lifetables[1:nrow(lifetables) %% 100 == 0,],
#   "data-raw/lifetables_sample.csv")
# usethis::use_data(lifetables, compress = "xz", overwrite = T)

# usethis::use_data(fat80_384x192, overwrite = TRUE)
# usethis::use_data(fat80_192x96, overwrite = TRUE)
