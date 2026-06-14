# Read a single root SVG dimension robustly

Read a single root SVG dimension robustly

## Usage

``` r
svg_dimension(
  svg_content,
  attr = c("width", "height"),
  prefer = c("attr", "viewBox")
)
```

## Arguments

- svg_content:

  SVG string.

- attr:

  `"width"` or `"height"`.

- prefer:

  Which source to try first: `"attr"` (width/height attribute, the
  default) or `"viewBox"`.

## Value

Numeric value in CSS px, or `NA_real_` if not found.
