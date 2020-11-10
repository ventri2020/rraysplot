
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
set.seed(202011)

lar <- make_arrays(3, 3)
lar$checker
#>      [,1] [,2] [,3]
#> [1,]   NA   NA   NA
#> [2,]   NA   NA   NA
#> [3,]   NA   NA   NA
lar$urandom
#>            [,1]      [,2]      [,3]
#> [1,] 0.09437554 0.4107326 0.6544631
#> [2,] 0.94736910 0.3445925 0.1290866
#> [3,] 0.60130009 0.8488876 0.8151506
```
