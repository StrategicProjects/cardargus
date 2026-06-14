# Read SVG width and height robustly

Read SVG width and height robustly

## Usage

``` r
svg_dims(svg_content, prefer = c("attr", "viewBox"))
```

## Arguments

- svg_content:

  SVG string.

- prefer:

  Which source to try first per dimension (see
  [`svg_dimension()`](https://strategicprojects.github.io/cardargus/reference/svg_dimension.md)).

## Value

A list with numeric `width` and `height` (either may be NA).
