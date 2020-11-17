Convert Images to Tensors
================
17.11.2020

*NOTE:* Use these functions `ANTsRNet::resampleTensor`,
`reticulate::array_reshape`

## Image data for U-Net

Source [2.2.11 Data representations for neural
networks](https://livebook.manning.com/book/deep-learning-with-r/chapter-2/48)
in [Deep Learning with
R](https://www.manning.com/books/deep-learning-with-r) by François
Chollet with J. J. Allaire.

Images typically have three dimensions:

    height × width × color channels

Although grayscale images have only a single color channel and could
thus be stored in 2D tensors, by convention image tensors are always 3D,
with a one-dimensional color channel for grayscale images.

A batch of 80 grayscale images of size 768×384 could thus be stored in a
tensor of shape

    (80, 768, 384, 1)

and a batch of 80 color images could be stored in a tensor of shape

    (80, 768, 384, 3)

and a batch of 80 mask –

    (80, 768, 384, 2)

## Important Note

We will crop all images to 768x384 and prepare additional data with
resampled (smaller) images: 384x192 and 192x96. Note that both
dimensions 768x384 are divisble by 128 (768/2^7=6, 384/2^7=3).

## Read Images Info

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

``` r
info_mri <- info %>% filter(kind == "MRI")
info_mri
#> # A tibble: 80 x 5
#>    patient    kind  type     series   file_path                                 
#>    <chr>      <chr> <chr>    <chr>    <chr>                                     
#>  1 1018642    MRI   image_b… ../80_i… ../80_images/1018642/image_base/1.2.840.1…
#>  2 1023660    MRI   image_b… ../80_i… ../80_images/1023660/image_base/1.2.840.1…
#>  3 1040979    MRI   image_b… ../80_i… ../80_images/1040979/image_base/1.2.840.1…
#>  4 1041204    MRI   image_b… ../80_i… ../80_images/1041204/image_base/1.2.840.1…
#>  5 1095912    MRI   image_b… ../80_i… ../80_images/1095912/image_base/1.2.840.1…
#>  6 1110505-2… MRI   image_b… ../80_i… ../80_images/1110505-2011/image_base/1.2.…
#>  7 1110505-2… MRI   image_b… ../80_i… ../80_images/1110505-2012/image_base/1.2.…
#>  8 1176610    MRI   image_b… ../80_i… ../80_images/1176610/image_base/1.2.840.1…
#>  9 1185364    MRI   image_b… ../80_i… ../80_images/1185364/image_base/1.2.840.1…
#> 10 158894-20… MRI   image_b… ../80_i… ../80_images/158894-2016/image_base/1.2.8…
#> # … with 70 more rows
```

``` r
info_at <- info %>% filter(kind == "AT")
info_at
#> # A tibble: 80 x 5
#>    patient    kind  type     series    file_path                                
#>    <chr>      <chr> <chr>    <chr>     <chr>                                    
#>  1 1018642    AT    dicom_c… ../80_im… ../80_images/1018642/dicom_color/1.2.840…
#>  2 1023660    AT    dicom_c… ../80_im… ../80_images/1023660/dicom_color/1.2.840…
#>  3 1040979    AT    dicom_c… ../80_im… ../80_images/1040979/dicom_color/1.2.840…
#>  4 1041204    AT    dicom_c… ../80_im… ../80_images/1041204/dicom_color/1.2.840…
#>  5 1095912    AT    dicom_c… ../80_im… ../80_images/1095912/dicom_color/1.2.840…
#>  6 1110505-2… AT    dicom_c… ../80_im… ../80_images/1110505-2011/dicom_color/1.…
#>  7 1110505-2… AT    dicom_c… ../80_im… ../80_images/1110505-2012/dicom_color/1.…
#>  8 1176610    AT    dicom_c… ../80_im… ../80_images/1176610/dicom_color/1.2.840…
#>  9 1185364    AT    dicom_c… ../80_im… ../80_images/1185364/dicom_color/1.2.840…
#> 10 158894-20… AT    dicom_c… ../80_im… ../80_images/158894-2016/dicom_color/1.2…
#> # … with 70 more rows
```

``` r
crop_image_wxhx1 <- function(img, ll = c(34, 56), wh = c(768, 384)) {
  ll = c(ll, 1)                        # c(34, 56, 1)
  ur = ll + c(wh, 0) - c(1, 1, 0)      # c(768 - 1, 384 - 1, 0)
  ANTsRCore::cropIndices(img, ll, ur)
}

crop_image_wxh <- function(img, ll = c(34, 56), wh = c(768, 384)) {
  ur = ll + wh - c(1, 1)               # c(768 - 1, 384 - 1)
  ANTsRCore::cropIndices(img, ll, ur)
}
```

## MRI images

``` r
mri_unet <- function(info, ll = c(34, 56), width_x_height = c(768, 384), channel = 1) {
  crop_image_wxhx1 <- function(img, ll = ll, wh = wh) {
    ll = c(ll, 1)                               # c(34, 56, 1)
    ur = ll + c(width_x_height, 0) - c(1, 1, 0) # c(768 - 1, 384 - 1, 0)
    ANTsRCore::cropIndices(img, ll, ur)
  }

  iList <- imageFileNames2ImageList(info[["file_path"]])
  n_images <- length(iList)
  
  domainImage = ANTsRCore::makeImage(imagesize = width_x_height, voxval = 0)
  dims = dim(domainImage)
  
  y_train <- array(
    data = NA, 
    dim = c(components(iList[[1]]), dims, n_images)
  )
  
  K <- keras::backend()
  array_crop <- purrr::compose(as.array, crop_image_wxhx1)
  aList <- map(iList, array_crop, ll = ll, wh = wh)
  
  for (i in seq_along(aList)) {
    y_train[,,,i] <- aList[[i]]
  }
  
  y_train <- as.array(
    K$permute_dimensions(y_train, pattern = c(3L, 1L, 2L, 0L))
  )
  
  # str(y_train)
  # str(info$patient)
  dimnames(y_train)[[1]] <- info$patient
  
  y_train[,,,channel]
}
```

``` r
images <- mri_unet(info_mri)
str(images)
#>  num [1:80, 1:768, 1:384] 0 0 0 0 0 0 0 0 0 0 ...
#>  - attr(*, "dimnames")=List of 3
#>   ..$ : chr [1:80] "1018642" "1023660" "1040979" "1041204" ...
#>   ..$ : NULL
#>   ..$ : NULL
dimnames(images)
#> [[1]]
#>  [1] "1018642"      "1023660"      "1040979"      "1041204"      "1095912"     
#>  [6] "1110505-2011" "1110505-2012" "1176610"      "1185364"      "158894-2016" 
#> [11] "158894-2018"  "163855"       "197929-2015"  "254582-2014"  "254582-2016" 
#> [16] "281774-2018"  "306001"       "306637"       "307629"       "330238"      
#> [21] "376426"       "377549"       "387800"       "389728"       "400295"      
#> [26] "415676"       "547766"       "552705"       "554667-2013"  "554667-2014" 
#> [31] "578317"       "579124"       "600725-2013"  "600725-2019"  "626604"      
#> [36] "648995-2011"  "648995-2013"  "648995-2014"  "661579"       "665924"      
#> [41] "678810"       "683412-2015"  "683412-2016"  "683412-2019"  "690256"      
#> [46] "700120"       "712846"       "715432"       "723887-2016"  "723887-2018" 
#> [51] "754337"       "764045"       "795905"       "797208"       "797610"      
#> [56] "801802"       "802551"       "803817"       "804568"       "806365"      
#> [61] "835693"       "840780"       "843037"       "853661"       "854387"      
#> [66] "858488"       "871006"       "873863"       "876730"       "878740"      
#> [71] "879820"       "882360-2016"  "882360-2017"  "883616"       "887603"      
#> [76] "894688"       "902756"       "914522"       "918538"       "924243"      
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
```

``` r
plot_array2d(images[5,,], title = dimnames(images)[[1]][[5]])
plot_array2d(images[29,,], title = dimnames(images)[[1]][[29]])
```

<img src="man/figures/10_images_to_tensors-figures2-side2-1.png" width="48%" /><img src="man/figures/10_images_to_tensors-figures2-side2-2.png" width="48%" />

``` r
plot_array2d(images[46,,], title = dimnames(images)[[1]][[46]])
plot_array2d(images["700120",,], title = dimnames(images)[[1]][[46]])
```

<img src="man/figures/10_images_to_tensors-figures2-side3-1.png" width="48%" /><img src="man/figures/10_images_to_tensors-figures2-side3-2.png" width="48%" />

## TODO

``` r
p <- info$file_path[[1]]
img <- ANTsRCore::antsImageRead(p)
channels <- ANTsRCore::splitChannels(img)
slice <- ANTsRCore::extractSlice(channels[[1]], 1, 3)
cslice <- crop_image_wxh(slice)
aslice = as.array(cslice)

dim(cslice)
#> [1] 768 384
dim(aslice)
#> [1] 768 384
```

``` r
plot_array2d(aslice)
invisible(plot(cslice, doCropping=F))
```

<img src="man/figures/10_images_to_tensors-figures2-side1-1.png" width="48%" /><img src="man/figures/10_images_to_tensors-figures2-side1-2.png" width="48%" />
