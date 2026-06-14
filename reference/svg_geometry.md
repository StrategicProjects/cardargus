# Read SVG root geometry (attribute and viewBox dimensions)

Read SVG root geometry (attribute and viewBox dimensions)

## Usage

``` r
svg_geometry(svg_content)
```

## Arguments

- svg_content:

  SVG string.

## Value

A list with numeric `attr_w`, `attr_h`, `vb_w`, `vb_h` (any may be NA).
