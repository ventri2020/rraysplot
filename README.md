
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rraysplot

<!-- badges: start -->
<!-- badges: end -->

The goal of rraysplot is to make 2D arrays and matrices plots less
aggravating.

## Installation

You can install the released version of rraysplot from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rraysplot")
```

You can install the development version of rraysplot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ventri2020/rraysplot")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rraysplot)
## basic example code
```

``` r
lar <- make_arrays(3, 3)
lar$checker
#>      [,1] [,2] [,3]
#> [1,]   NA   NA   NA
#> [2,]   NA   NA   NA
#> [3,]   NA   NA   NA
lar$urandom
#>           [,1]      [,2]      [,3]
#> [1,] 0.3177797 0.4918289 0.4333269
#> [2,] 0.8033645 0.3119313 0.3429495
#> [3,] 0.3639404 0.4642657 0.3002776
```
