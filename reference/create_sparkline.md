# Create a sparkline SVG

Generates a small, self-contained SVG mini-chart (line, area or bars)
from a numeric vector. The result is a plain SVG string that can be
embedded anywhere
[`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
accepts raw SVG content: the `with_icon` field slot, `logos` or
`bottom_logos`.

## Usage

``` r
create_sparkline(
  values,
  width = 120,
  height = 36,
  color = "white",
  type = c("line", "area", "bar"),
  stroke_width = 2,
  fill_opacity = 0.3,
  show_last_point = TRUE,
  padding = 3
)
```

## Arguments

- values:

  Numeric vector with the series to plot (no missing values). Line and
  area sparklines need at least 2 points; bars need at least 1.

- width:

  Total width of the sparkline in pixels.

- height:

  Total height of the sparkline in pixels.

- color:

  Stroke/fill color (any SVG color, e.g. "white" or "#0ea5e9").

- type:

  Chart type: `"line"` (default), `"area"` or `"bar"`.

- stroke_width:

  Line thickness in pixels (line/area types).

- fill_opacity:

  Fill opacity for the area under the curve (`"area"`) and for the bars
  (`"bar"`).

- show_last_point:

  Draw a dot on the last point (line/area types).

- padding:

  Inner padding in pixels so strokes/dots are not clipped.

## Value

A character string with a standalone `<svg>` element.

## Examples

``` r
# A line sparkline used as a field icon in a card
spark <- create_sparkline(c(3, 5, 2, 8, 7), color = "white")
fields <- list(
  list(list(label = "Tendência", value = "Alta", with_icon = spark))
)
svg <- svg_card("Vendas", fields = fields, show_viewer = FALSE)

# Area and bar variants
create_sparkline(c(1, 4, 2, 6), type = "area", color = "#0ea5e9")
#> [1] "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"120\" height=\"36\" viewBox=\"0 0 120 36\" aria-hidden=\"true\"><polygon points=\"3.00,33.00 41.00,15.00 79.00,27.00 117.00,3.00 117.00,33.00 3.00,33.00\" fill=\"#0ea5e9\" fill-opacity=\"0.30\" stroke=\"none\"/><polyline points=\"3.00,33.00 41.00,15.00 79.00,27.00 117.00,3.00\" fill=\"none\" stroke=\"#0ea5e9\" stroke-width=\"2.00\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/><circle cx=\"117.00\" cy=\"3.00\" r=\"3.00\" fill=\"#0ea5e9\"/></svg>"
create_sparkline(c(5, 2, 8, 3, 7), type = "bar", color = "white")
#> [1] "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"120\" height=\"36\" viewBox=\"0 0 120 36\" aria-hidden=\"true\"><rect x=\"5.85\" y=\"14.25\" width=\"17.10\" height=\"18.75\" fill=\"white\" fill-opacity=\"0.30\"/><rect x=\"28.65\" y=\"25.50\" width=\"17.10\" height=\"7.50\" fill=\"white\" fill-opacity=\"0.30\"/><rect x=\"51.45\" y=\"3.00\" width=\"17.10\" height=\"30.00\" fill=\"white\" fill-opacity=\"0.30\"/><rect x=\"74.25\" y=\"21.75\" width=\"17.10\" height=\"11.25\" fill=\"white\" fill-opacity=\"0.30\"/><rect x=\"97.05\" y=\"6.75\" width=\"17.10\" height=\"26.25\" fill=\"white\" fill-opacity=\"0.30\"/></svg>"
```
