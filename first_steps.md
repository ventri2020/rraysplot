
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
#> .Library.site = "~/Library/%v/library
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
#>  [1] "available"   "clisymbols"  "hunspell"    "janeaustenr" "rraysplot"  
#>  [6] "SnowballC"   "stringdist"  "tidytext"    "tokenizers"  "udapi"      
#> [11] "yesno"      
#> 
#> [[2]]
#>   [1] "ANTsR"        "ANTsRCore"    "ANTsRNet"     "askpass"      "assertthat"  
#>   [6] "backports"    "base"         "base64enc"    "BH"           "blob"        
#>  [11] "boot"         "brew"         "brio"         "broom"        "callr"       
#>  [16] "cellranger"   "class"        "cli"          "clipr"        "cluster"     
#>  [21] "codetools"    "colorspace"   "commonmark"   "compiler"     "config"      
#>  [26] "covr"         "cowplot"      "cpp11"        "crayon"       "crosstalk"   
#>  [31] "curl"         "datasets"     "DBI"          "dbplyr"       "desc"        
#>  [36] "devtools"     "diffobj"      "digest"       "dplyr"        "DT"          
#>  [41] "ellipsis"     "evaluate"     "fansi"        "farver"       "forcats"     
#>  [46] "foreign"      "fs"           "generics"     "ggplot2"      "gh"          
#>  [51] "git2r"        "glue"         "graphics"     "grDevices"    "grid"        
#>  [56] "gtable"       "haven"        "highr"        "hms"          "htmltools"   
#>  [61] "htmlwidgets"  "httr"         "ini"          "isoband"      "ITKR"        
#>  [66] "jsonlite"     "keras"        "KernSmooth"   "knitr"        "labeling"    
#>  [71] "later"        "lattice"      "lazyeval"     "lifecycle"    "lobstr"      
#>  [76] "lubridate"    "magrittr"     "markdown"     "MASS"         "Matrix"      
#>  [81] "memoise"      "methods"      "mgcv"         "mime"         "misc3d"      
#>  [86] "modelr"       "munsell"      "mvtnorm"      "nlme"         "nnet"        
#>  [91] "openssl"      "parallel"     "pillar"       "pixmap"       "pkgbuild"    
#>  [96] "pkgconfig"    "pkgload"      "praise"       "prettyunits"  "processx"    
#> [101] "progress"     "promises"     "pryr"         "ps"           "purrr"       
#> [106] "R6"           "ragg"         "rappdirs"     "rcmdcheck"    "RColorBrewer"
#> [111] "Rcpp"         "RcppEigen"    "readr"        "readxl"       "rematch"     
#> [116] "rematch2"     "remotes"      "reprex"       "reticulate"   "rex"         
#> [121] "rlang"        "rmarkdown"    "roxygen2"     "rpart"        "rprojroot"   
#> [126] "rstudioapi"   "rversions"    "rvest"        "scales"       "selectr"     
#> [131] "sessioninfo"  "spatial"      "splines"      "stats"        "stats4"      
#> [136] "stringi"      "stringr"      "survival"     "sys"          "systemfonts" 
#> [141] "tcltk"        "tcltk2"       "tensorflow"   "testthat"     "textshaping" 
#> [146] "tfruns"       "tibble"       "tidyr"        "tidyselect"   "tidyverse"   
#> [151] "tinytex"      "tools"        "translations" "usethis"      "utf8"        
#> [156] "utils"        "vctrs"        "viridisLite"  "waldo"        "whisker"     
#> [161] "withr"        "xfun"         "xml2"         "xopen"        "yaml"        
#> [166] "zeallot"
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
#> # A tibble: 22 x 2
#>    path          type     
#>    <fs::path>    <fct>    
#>  1 .Rbuildignore file     
#>  2 .Rhistory     file     
#>  3 .Rproj.user   directory
#>  4 .git          directory
#>  5 .gitignore    file     
#>  6 DESCRIPTION   file     
#>  7 LICENSE       file     
#>  8 LICENSE.md    file     
#>  9 NAMESPACE     file     
#> 10 R             directory
#> # … with 12 more rows
```

``` r
use_r("make_arrays")
#> ✓ Setting active project to '/Users/wbzyl/RPKGS/GUMED/rraysplot'
#> ● Edit 'R/make_arrays.R'
#> ● Call `use_test()` to create a matching test file
```
