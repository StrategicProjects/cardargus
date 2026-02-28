# Parse a numeric width/height from the root \<svg ...\> tag

Tries:

1.  width="..." / height="..." (supports px, numbers)

2.  viewBox="minx miny width height" as fallback

## Usage

``` r
parse_svg_root_dim(svg_content, attr = c("width", "height"))
```

## Arguments

- svg_content:

  Character SVG.

- attr:

  "width" or "height".

## Value

Numeric value (in CSS px) or NA_real\_ if not found.
