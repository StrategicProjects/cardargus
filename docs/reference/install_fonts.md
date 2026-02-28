# Pre-download fonts for offline use

Downloads and caches the specified fonts (or default fonts) so they are
available for PNG conversion without internet access.

## Usage

``` r
install_fonts(
  fonts = c("Jost", "Montserrat", "Roboto", "Open Sans"),
  verbose = TRUE
)
```

## Arguments

- fonts:

  Character vector of Google Font names to download. Default is
  c("Jost", "Montserrat", "Roboto", "Open Sans").

- verbose:

  Print status messages

## Value

Named logical vector indicating success for each font

## Examples

``` r
# \donttest{
install_fonts()
#> 
#> ── Downloading fonts from Google Fonts ──
#> 
#> ℹ Requires internet connection
#> ℹ Using curl package for downloads
#> ℹ Downloading "Jost"...
#> ✔ Jost (WOFF2)
#> ℹ Downloading "Jost"...

#> ✔ Downloading "Montserrat"... [8ms]
#> 
#> ℹ Downloading "Montserrat"...
#> ✔ Montserrat (WOFF2)
#> ℹ Downloading "Montserrat"...

#> ✔ Downloading "Roboto"... [22ms]
#> 
#> ℹ Downloading "Roboto"...
#> ✔ Roboto (WOFF2)
#> ℹ Downloading "Roboto"...

#> ✔ Downloading "Open Sans"... [14ms]
#> 
#> ℹ Downloading "Open Sans"...
#> ✔ Open Sans (WOFF2)
#> ℹ Downloading "Open Sans"...

#> 
#> ℹ Downloading "Open Sans"...

#> ── Summary 
#> ℹ Downloading "Open Sans"...

#> ℹ Downloaded 4/4 fonts
#> ℹ Downloading "Open Sans"...

#> ℹ Cache: /Users/leite/Library/Caches/org.R-project.R/R/cardargus
#> ℹ Downloading "Open Sans"...

#> ✔ Downloading "Open Sans"... [16ms]
#> 
install_fonts(c("Jost", "Roboto"))
#> 
#> ── Downloading fonts from Google Fonts ──
#> 
#> ℹ Requires internet connection
#> ℹ Using curl package for downloads
#> ℹ Downloading "Jost"...
#> ✔ Jost (WOFF2)
#> ℹ Downloading "Jost"...

#> ✔ Downloading "Roboto"... [5ms]
#> 
#> ℹ Downloading "Roboto"...
#> ✔ Roboto (WOFF2)
#> ℹ Downloading "Roboto"...

#> 
#> ℹ Downloading "Roboto"...

#> ── Summary 
#> ℹ Downloading "Roboto"...

#> ℹ Downloaded 2/2 fonts
#> ℹ Downloading "Roboto"...

#> ℹ Cache: /Users/leite/Library/Caches/org.R-project.R/R/cardargus
#> ℹ Downloading "Roboto"...

#> ✔ Downloading "Roboto"... [18ms]
#> 
# }
```
