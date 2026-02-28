# Get Google Font CSS for embedding in SVG

Get Google Font CSS for embedding in SVG

## Usage

``` r
get_font_css(font_name = "Jost", weights = c(400, 500, 600, 700))
```

## Arguments

- font_name:

  Name of the Google Font

- weights:

  Vector of font weights to include

## Value

Character string with CSS @font-face rules

## Examples

``` r
get_font_css("Jost")
#> [1] "@import url(\"https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&display=swap\");"
```
