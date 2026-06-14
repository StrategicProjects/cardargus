# Map Pin Icon SVG

Generate a map pin/location icon SVG.

## Usage

``` r
icon_map_pin(
  width = 50,
  height = 56,
  stroke_color = "white",
  stroke_width = 2,
  fill = "none"
)
```

## Arguments

- width:

  Width of the icon

- height:

  Height of the icon

- stroke_color:

  Stroke color

- stroke_width:

  Stroke width

- fill:

  Fill color

## Value

SVG string

## Examples

``` r
icon_map_pin(50, 56)
#> [1] "<svg width=\"50\" height=\"56\" viewBox=\"0 0 50 56\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n      <path d=\"M25 4 C14 4 6 12 6 22 C6 35 25 52 25 52 C25 52 44 35 44 22 C44 12 36 4 25 4 Z\" \n            stroke=\"white\" stroke-width=\"2\" fill=\"none\"/>\n      <circle cx=\"25\" cy=\"22\" r=\"8\" stroke=\"white\" stroke-width=\"2\" fill=\"none\"/>\n    </svg>"
```
