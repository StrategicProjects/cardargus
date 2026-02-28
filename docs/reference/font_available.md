# Check if a font is available for embedding

Check if a font is available for embedding

## Usage

``` r
font_available(family)
```

## Arguments

- family:

  Font family name

## Value

TRUE if font is cached (any supported format), FALSE otherwise

## Examples

``` r
font_available("Jost")
#> [1] TRUE
font_available("Montserrat")
#> [1] TRUE
```
