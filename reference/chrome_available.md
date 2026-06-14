# Check if Chrome/Chromium is available for rendering

Checks whether the chromote package can find and use a Chrome or
Chromium installation for headless rendering.

## Usage

``` r
chrome_available(verbose = FALSE)
```

## Arguments

- verbose:

  Print status messages (default FALSE).

## Value

TRUE if Chrome is available, FALSE otherwise.

## Examples

``` r
if (chrome_available()) {
   cat("Using Chrome")
} else {
   cat("Using Magick")
}
#> Using Chrome
```
