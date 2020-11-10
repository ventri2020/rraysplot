
# First Steps

## More info…

-   Package structure and state. [4.7 Package
    libraries](https://r-pkgs.org/package-structure-state.html#library).
-   [Comparison of `fs` functions, base R, and shell
    commands](https://cran.r-project.org/web/packages/fs/vignettes/function-comparisons.html)

## Managing package libraries

Here are the main two levers that control which libraries are active, in
order of scope and persistence:

1.  Environment variables, like `R_LIBS` and `R_LIBS_USER`, which are
    consulted at startup.
2.  Calling `.libPaths()` with one or more filepaths.

``` sh
mkdir -p ~/Library/R/4.0/library
```

``` sh
cat ~/.Rprofile.site
#> # ?.libPaths
#> .Library.site = "~/Library/%v/library"
#> .libPaths(.libPaths())
```

``` sh
echo $R_LIBS_USER
#> ~/Library/R/4.0/library
```

``` r
.Library
#> [1] "/Library/Frameworks/R.framework/Resources/library"
.Library.site
#> character(0)
```

In both cases we see two active libraries, consulted in this order:

1.  A user library.
2.  A system-level or global library.

``` r
.libPaths()
#> [1] "/Users/wbzyl/Library/R/4.0/library"                            
#> [2] "/Library/Frameworks/R.framework/Versions/4.0/Resources/library"
```

``` r
lapply(
  .libPaths(), 
  list.dirs, 
  recursive = FALSE, 
  full.names = FALSE)
#> [[1]]
#>  [1] "available"   "clisymbols"  "hunspell"    "janeaustenr" "ragg"       
#>  [6] "rraysplot"   "SnowballC"   "stringdist"  "systemfonts" "textshaping"
#> [11] "tidytext"    "tokenizers"  "udapi"       "yesno"      
#> 
#> [[2]]
#>   [1] "abind"        "ANTsR"        "ANTsRCore"    "ANTsRNet"     "askpass"     
#>   [6] "assertthat"   "backports"    "base"         "base64enc"    "BBmisc"      
#>  [11] "BH"           "bitops"       "blob"         "bmp"          "boot"        
#>  [16] "brew"         "brio"         "broom"        "callr"        "cellranger"  
#>  [21] "checkmate"    "class"        "cli"          "clipr"        "cluster"     
#>  [26] "codetools"    "colorspace"   "commonmark"   "compiler"     "config"      
#>  [31] "covr"         "cowplot"      "cpp11"        "crayon"       "credentials" 
#>  [36] "crosstalk"    "curl"         "datasets"     "DBI"          "dbplyr"      
#>  [41] "desc"         "devtools"     "diffobj"      "digest"       "downloader"  
#>  [46] "dplyr"        "DT"           "ellipsis"     "evaluate"     "fansi"       
#>  [51] "farver"       "fastmap"      "fftwtools"    "forcats"      "foreign"     
#>  [56] "fs"           "generics"     "gert"         "ggplot2"      "gh"          
#>  [61] "git2r"        "gitcreds"     "glue"         "graphics"     "grDevices"   
#>  [66] "grid"         "gridExtra"    "gtable"       "haven"        "highr"       
#>  [71] "hms"          "htmltools"    "htmlwidgets"  "httpuv"       "httr"        
#>  [76] "igraph"       "imager"       "imagerExtra"  "ini"          "isoband"     
#>  [81] "ITKR"         "jpeg"         "jsonlite"     "keras"        "KernSmooth"  
#>  [86] "knitr"        "labeling"     "later"        "lattice"      "lazyeval"    
#>  [91] "learnr"       "lifecycle"    "lobstr"       "lubridate"    "magrittr"    
#>  [96] "markdown"     "MASS"         "Matrix"       "memoise"      "methods"     
#> [101] "mgcv"         "mime"         "miniUI"       "misc3d"       "modelr"      
#> [106] "munsell"      "mvtnorm"      "nlme"         "nnet"         "openssl"     
#> [111] "oro.nifti"    "parallel"     "pillar"       "pixmap"       "pkgbuild"    
#> [116] "pkgconfig"    "pkgload"      "plogr"        "plyr"         "png"         
#> [121] "praise"       "prettyunits"  "processx"     "progress"     "promises"    
#> [126] "ps"           "purrr"        "R6"           "rappdirs"     "raster"      
#> [131] "rcmdcheck"    "RColorBrewer" "Rcpp"         "RcppEigen"    "readbitmap"  
#> [136] "readr"        "readxl"       "regexplain"   "rematch"      "rematch2"    
#> [141] "remotes"      "renv"         "reprex"       "reshape2"     "reticulate"  
#> [146] "rex"          "rlang"        "rmarkdown"    "RNifti"       "roxygen2"    
#> [151] "rpart"        "rprojroot"    "rstudioapi"   "rticles"      "rversions"   
#> [156] "rvest"        "scales"       "selectr"      "sessioninfo"  "shiny"       
#> [161] "sloop"        "sourcetools"  "sp"           "spatial"      "splines"     
#> [166] "spng"         "stats"        "stats4"       "stringi"      "stringr"     
#> [171] "survival"     "sys"          "tcltk"        "tensorflow"   "testthat"    
#> [176] "tfruns"       "tibble"       "tidyr"        "tidyselect"   "tidyverse"   
#> [181] "tiff"         "tinytex"      "tools"        "translations" "usethis"     
#> [186] "utf8"         "utils"        "vctrs"        "viridisLite"  "waldo"       
#> [191] "whisker"      "withr"        "xfun"         "xml2"         "xopen"       
#> [196] "xtable"       "yaml"         "zeallot"      "zip"
```

## Check what is installed

``` r
packageVersion("devtools")
#> [1] '2.3.2'

options(buildtools.check = NULL)
# devtools::install_github("r-lib/devtools")
# packageVersion("devtools")
```

Optionally run:

``` r
# tidyverse::tidyverse_update()
# tidyverse::tidyverse_conflicts()
tidyverse::tidyverse_packages()
#>  [1] "broom"      "cli"        "crayon"     "dbplyr"     "dplyr"     
#>  [6] "forcats"    "ggplot2"    "haven"      "hms"        "httr"      
#> [11] "jsonlite"   "lubridate"  "magrittr"   "modelr"     "pillar"    
#> [16] "purrr"      "readr"      "readxl"     "reprex"     "rlang"     
#> [21] "rstudioapi" "rvest"      "stringr"    "tibble"     "tidyr"     
#> [26] "xml2"       "tidyverse"
```

## [Name your package](https://r-pkgs.org/workflows101.html#naming)

There are three formal requirements:

1.  The name can only consist of letters, numbers, and periods.
2.  It must start with a letter.
3.  It cannot end with a period.

Unfortunately, this means you can’t use either hyphens (`-`) or
underscores (`_`) in your package name. We recommend against using
periods in package names, due to confusing associations with file
extensions and S3 methods.

The
[available](https://cran.r-project.org/web/packages/available/available.pdf)
package has a function called `available()` that helps you evaluate a
potential package name from many angles:

``` r
devtools::install_github("ropenscilabs/available")
```

``` r
available::suggest(text = "Plotting helpers for arrays.")
#> rraysplot
```

## [Create package](https://r-pkgs.org/workflows101.html#create-a-package)

``` r
library(devtools)
#> Loading required package: usethis
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.4     ✓ dplyr   1.0.2
#> ✓ tidyr   1.1.2     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.0
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

``` r
source_directory <- "~/RPKGS/GUMED" 
package_name <- "rraysplot"

# fs::dir_create(source_directory)

pkg_path <- fs::path(.libPaths()[[1]], package_name)
pkg_path
#> /Users/wbzyl/Library/R/4.0/library/rraysplot
src_path <- fs::path(source_directory, package_name)
src_path
#> ~/RPKGS/GUMED/rraysplot
```

``` r
usethis::create_package(src_path)
```

    ✓ Creating '/Users/wbzyl/RPKGS/GUMED/rraysplot/'
    ✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
    ✓ Creating 'R/'
    ✓ Writing 'DESCRIPTION'
    Package: rraysplot
    Title: What the Package Does (One Line, Title Case)
    Version: 0.0.0.9000
    Authors@R (parsed):
        * Wlodek <wlodek@rpkgs.com> [aut, cre]
    Description: What the package does (one paragraph).
    License: MIT + file LICENSE
    Encoding: UTF-8
    LazyData: true
    Roxygen: list(markdown = TRUE)
    RoxygenNote: 7.1.1
    ✓ Writing 'NAMESPACE'
    ✓ Writing 'rraysplot.Rproj'
    ✓ Adding '.Rproj.user' to '.gitignore'
    ✓ Adding '^rraysplot\\.Rproj$', '^\\.Rproj\\.user$' to '.Rbuildignore'
    ✓ Opening '/Users/wbzyl/RPKGS/GUMED/rraysplot/' in new RStudio session
    ✓ Setting active project to '<no active project>'

``` r
fs::dir_info(
    all = TRUE,
    recurse = TRUE,
    regexp = "^(.git|.Rproj.user)/.+",
    invert = TRUE) %>% 
  dplyr::select(path, type)
#> # A tibble: 25 x 2
#>    path            type     
#>    <fs::path>      <fct>    
#>  1 .Rbuildignore   file     
#>  2 .Rproj.user     directory
#>  3 .git            directory
#>  4 .gitignore      file     
#>  5 DESCRIPTION     file     
#>  6 LICENSE         file     
#>  7 LICENSE.md      file     
#>  8 NAMESPACE       file     
#>  9 R               directory
#> 10 R/make_arrays.R file     
#> # … with 15 more rows
```

``` r
use_r("make_arrays")
#> ✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
#> ● Edit 'R/make_arrays.R'
#> ● Call `use_test()` to create a matching test file
```
