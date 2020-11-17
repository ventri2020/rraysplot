Check MR Images
================
17.11.2020

## Read file names of images

``` r
info <- images_info("../80_images", extension = "dcm")
info
#> # A tibble: 320 x 5
#>    patient kind  type      series    file_path                                  
#>    <chr>   <chr> <chr>     <chr>     <chr>                                      
#>  1 1018642 AT    dicom_co… ../80_im… ../80_images/1018642/dicom_color/1.2.840.1…
#>  2 1018642 MRI   image_ba… ../80_im… ../80_images/1018642/image_base/1.2.840.19…
#>  3 1018642 SCAT  dicom_red ../80_im… ../80_images/1018642/dicom_red/1.2.840.191…
#>  4 1018642 VSAT  dicom_bl… ../80_im… ../80_images/1018642/dicom_blue/1.2.840.19…
#>  5 1023660 AT    dicom_co… ../80_im… ../80_images/1023660/dicom_color/1.2.840.1…
#>  6 1023660 MRI   image_ba… ../80_im… ../80_images/1023660/image_base/1.2.840.19…
#>  7 1023660 SCAT  dicom_red ../80_im… ../80_images/1023660/dicom_red/1.2.840.191…
#>  8 1023660 VSAT  dicom_bl… ../80_im… ../80_images/1023660/dicom_blue/1.2.840.19…
#>  9 1040979 AT    dicom_co… ../80_im… ../80_images/1040979/dicom_color/1.2.840.1…
#> 10 1040979 MRI   image_ba… ../80_im… ../80_images/1040979/image_base/1.2.840.19…
#> # … with 310 more rows
```

## There should be 80\*4=320 images

``` r
testthat::expect_equal(length(info$file_path), 80 * 4)
```

``` r
iList <- ANTsRCore::imageFileNames2ImageList(info$file_path)
n_images <- length(iList)
  
domainImage <- iList[[1]]
domainImage
#> antsImage
#>   Pixel Type          : float 
#>   Components Per Pixel: 3 
#>   Dimensions          : 836x496x1 
#>   Voxel Spacing       : 1x1x1 
#>   Origin              : 0 0 0 
#>   Direction           : 1 0 0 0 1 0 0 0 1 
#>   Filename           : ../80_images/1018642/dicom_color/1.2.840.19104.20483.007.401002.1.637400293148711933.dcm
```

## All images must have the same attributes

``` r
pixeltype(domainImage)
#> [1] "float"
components(domainImage)
#> [1] 3
dim(domainImage)
#> [1] 836 496   1
spacing(domainImage)
#> [1] 1 1 1
origin(domainImage)
#> [1] 0 0 0
direction(domainImage)
#>      [,1] [,2] [,3]
#> [1,]    1    0    0
#> [2,]    0    1    0
#> [3,]    0    0    1
```

``` r
pixel_types <- purrr::map_chr(iList, pixeltype)
expected_types <- rep("float", n_images)
testthat::expect_identical(pixel_types, expected_types)
```

``` r
components_per_pixel <- purrr::map_dbl(iList, components)
expected_components_per_pixel <- rep(3, n_images)
testthat::expect_identical(components_per_pixel, expected_components_per_pixel)
```

Images have different y-dimensions: 494 495 496.

``` r
dims <- purrr::map(iList, dim)
x <- purrr::map_int(dims, dplyr::nth, 1)
y <- purrr::map_int(dims, dplyr::nth, 2)
z <- purrr::map_int(dims, dplyr::nth, 3)

expected_dims <- rep(list(dim(domainImage)), n_images)
expected_x <- purrr::map_int(expected_dims, dplyr::nth, 1)
expected_y <- purrr::map_int(expected_dims, dplyr::nth, 2)
expected_z <- purrr::map_int(expected_dims, dplyr::nth, 3)

testthat::expect_equal(x, expected_x)
# testthat::expect_equal(y, expected_y)
sort(unique(y))
#> [1] 494 495 496
testthat::expect_equal(z, expected_z)
```

``` r
spacings <- purrr::map(iList, spacing)
expected_spacings <- rep(list(spacing(domainImage)), n_images)
testthat::expect_identical(spacings, expected_spacings)
```

``` r
origins <- purrr::map(iList, origin)
expected_origins <- rep(list(origin(domainImage)), n_images)
testthat::expect_identical(origins, expected_origins)
```

``` r
directions <- purrr::map(iList, direction)
expected_directions <- rep(list(direction(domainImage)), n_images)
testthat::expect_identical(directions, expected_directions)
```
