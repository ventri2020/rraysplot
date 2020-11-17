
# Development Workflow

See [3.1 HTML
document](https://bookdown.org/yihui/rmarkdown/html-document.html) in „R
Markdown: The Definitive Guide” by Yihui Xie, J. J. Allaire, Garrett
Grolemund.

``` r
library(devtools)
#> Loading required package: usethis
library(fs)
```

``` r
fs::dir_info(
    all = TRUE,
    recurse = TRUE,
    regexp = "^(.git|.Rproj.user|.+\\.(html|md))/.+",
    invert = TRUE) %>% 
  dplyr::select(path, type)
#> # A tibble: 58 x 2
#>    path                        type     
#>    <fs::path>                  <fct>    
#>  1 .Rbuildignore               file     
#>  2 .Rhistory                   file     
#>  3 .Rproj.user                 directory
#>  4 .git                        directory
#>  5 .gitignore                  file     
#>  6 00-check_mr_images.Rmd      file     
#>  7 00-check_mr_images.md       file     
#>  8 10-mr_images_to_tensors.Rmd file     
#>  9 10-mr_images_to_tensors.md  file     
#> 10 DESCRIPTION                 file     
#> # … with 48 more rows
```

## [2.6 Write the first function](https://r-pkgs.org/whole-game.html#write-the-first-function)

``` r
use_r("make_arrays")
```

Put the following definition in *R/make\_arrays.R* an save it.

``` r
make_arrays <- function(m = 5, n = 5) {
  array(NA, c(m, n))
}
```

``` r
load_all() # shift + ctrl + L  or  shift + command

make_arrays(2, 4)
#>      [,1] [,2] [,3] [,4]
#> [1,]   NA   NA   NA   NA
#> [2,]   NA   NA   NA   NA
```

``` r
check()
```

## 2.10 Edit DESCRIPTION

``` r
use_mit_license("Wlodek Bzyl")
#> ✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
#> ✓ Leaving 'LICENSE.md' unchanged
# ✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
# ✓ Writing 'LICENSE.md'
# ✓ Adding '^LICENSE\\.md$' to '.Rbuildignore'
# ✓ Writing 'LICENSE'
```

``` r
check()
```

## 2.12 document()

Would not it be nice to get help on `make_arrays()`, just like we do
with other R functions?

This requires that your package have a special R documentation file,
*man/make\_arrays.Rd*.

``` r
document()
# Updating rraysplot documentation
# Loading rraysplot
# Writing NAMESPACE
# Writing make_arrays.Rd
```

``` r
check()
```

## 2.14 `install()`

Since we have a minimum viable(?) product now, let’s install the
foofactors package into your library via `install()`:

``` r
install()
#> Skipping 1 packages not available: ANTsRCore
#>      checking for file ‘/Users/wbzyl/RPKGS/GUMED/rraysplot/DESCRIPTION’ ...  ✓  checking for file ‘/Users/wbzyl/RPKGS/GUMED/rraysplot/DESCRIPTION’
#>   ─  preparing ‘rraysplot’: (456ms)
#>      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>    Removed empty directory ‘rraysplot/tests/testthat/_snaps’
#>   ─  building ‘rraysplot_0.0.0.9000.tar.gz’
#>      
#> Running /Library/Frameworks/R.framework/Resources/bin/R CMD INSTALL \
#>   /var/folders/hc/wp9ltsm97db0c3ch1xj0n6hc0000gn/T//RtmpnVlIHc/rraysplot_0.0.0.9000.tar.gz \
#>   --install-tests 
#> * installing to library ‘/Users/wbzyl/Library/R/4.0/library’
#> * installing *source* package ‘rraysplot’ ...
#> ** using staged installation
#> ** R
#> ** tests
#> ** byte-compile and prepare package for lazy loading
#> ** help
#> *** installing help indices
#> *** copying figures
#> ** building package indices
#> ** testing if installed package can be loaded from temporary location
#> ** testing if installed package can be loaded from final location
#> ** testing if installed package keeps a record of temporary installation path
#> * DONE (rraysplot)
# * installing to library ‘/Users/wbzyl/Library/R/4.0/library’
```

``` r
library(rraysplot)
make_arrays(4, 3)
#> $checker
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    1    0    1
#> [3,]    0    1    0
#> [4,]    1    0    1
#> 
#> $urandom
#>            [,1]       [,2]        [,3]
#> [1,] 0.05597932 0.80248600 0.527525785
#> [2,] 0.96575772 0.24347722 0.242524328
#> [3,] 0.52234277 0.30947353 0.002026208
#> [4,] 0.79392942 0.07970442 0.819688315
#> 
#> $zeros
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    0    0    0
#> [3,]    0    0    0
#> [4,]    0    0    0
#> 
#> $ones
#>      [,1] [,2] [,3]
#> [1,]    1    1    1
#> [2,]    1    1    1
#> [3,]    1    1    1
#> [4,]    1    1    1
#> 
#> $rectangle
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    0    1    0
#> [3,]    0    1    0
#> [4,]    0    0    0
```

## 2.15 `use_testthat()`

-   [testthat](https://testthat.r-lib.org) – overview, reference,
    articles.

``` r
use_testthat()
# ✓ Adding 'testthat' to Suggests field in DESCRIPTION
# ✓ Creating 'tests/testthat/'
# ✓ Writing 'tests/testthat.R'
# ● Call `use_test()` to initialize a basic test file and open it for editing.
```

``` r
use_test("make_arrays")
# ✓ Writing 'tests/testthat/test-make_arrays.R'
# ● Modify 'tests/testthat/test-make_arrays.R'
```

``` r
library(testthat)
#> 
#> Attaching package: 'testthat'
#> The following object is masked from 'package:devtools':
#> 
#>     test_file
load_all()
#> Loading rraysplot
#> Warning: 
#> ── Conflicts ──────────────────────────────────────────── rraysplot conflicts ──
#> x %>%() masks rraysplot::%>%()
#> 
#> Did you accidentally source a file rather than using `load_all()`?
#> Run `rm(list = c("%>%"))` to remove the conflicts.
```

``` r
test() # cmd + shift + T
```

## 2.18 `use_readme_rmd()`

Now that your package is on GitHub, the *README.md* file matters.

It is the package’s home page and welcome mat, at least until you decide
to give it a website with pkgdown, **add a vignette**, or submit it to
CRAN.

``` r
use_readme_rmd()

✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
✓ Writing 'README.Rmd'
✓ Adding '^README\\.Rmd$' to '.Rbuildignore'
● Modify 'README.Rmd'
✓ Writing '.git/hooks/pre-commit'
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

``` r
devtools::build_readme()
```

is handy for this.

## 2.16 `use_package()`

We’re going to add another function to package. We’ll borrow some smarts
from the another package, for example the function `expand_grid` from
the tidyr and `%>%` from the purrr package.

First, declare your general intent to use some functions from the tidyr
namespace with `use_package()`:

``` r
use_package("tidyr")
use_package("purrr")
use_package("tibble")
```

Next, optionally(?), we add these lines to the source R file
(`R/plot_array2d.R`):

``` r
#' @importFrom purrr %>% map map_dbl
#' @importFrom tidyr expand_grid
#' @importFrom tibble tibble
```
