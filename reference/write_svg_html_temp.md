# Create a temporary HTML file wrapping an SVG

Create a temporary HTML file wrapping an SVG

## Usage

``` r
write_svg_html_temp(
  svg_string,
  width_px = NULL,
  height_px = NULL,
  background = "transparent"
)
```

## Arguments

- svg_string:

  SVG content as character string.

- width_px:

  Width in pixels. If NULL, extracted from SVG.

- height_px:

  Height in pixels. If NULL, extracted from SVG.

- background:

  Background color (default "transparent").

## Value

A list with path, width, and height.
