# Parse a viewBox string into width/height

Parse a viewBox string into width/height

## Usage

``` r
parse_viewbox(vb)
```

## Arguments

- vb:

  A viewBox string `"minx miny width height"` or `NA`.

## Value

Numeric vector `c(width, height)`, possibly `c(NA, NA)`.
