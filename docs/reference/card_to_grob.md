# Create a grob for grid/ggplot2

Wrap an SVG card as a raster grob so it can be used with grid graphics.

## Usage

``` r
card_to_grob(svg_string, dpi = 150, engine = c("auto", "chrome", "rsvg"))
```

## Arguments

- svg_string:

  SVG string from
  [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md).

- dpi:

  Rasterization DPI (default 150).

- engine:

  Rendering engine: `"auto"`, `"chrome"`, or `"rsvg"`.

## Value

A [`grid::rasterGrob`](https://rdrr.io/r/grid/grid.raster.html) object.
