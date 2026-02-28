# Building Icon SVG

Generate a building/apartment icon SVG.

## Usage

``` r
icon_building(
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
icon_building(50, 56)
#> [1] "<svg width=\"50\" height=\"56\" viewBox=\"0 0 50 56\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n      <rect x=\"5\" y=\"10\" width=\"40\" height=\"44\" stroke=\"white\" stroke-width=\"2\" fill=\"none\"/>\n      <rect x=\"10\" y=\"16\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"21\" y=\"16\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"32\" y=\"16\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"10\" y=\"28\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"21\" y=\"28\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"32\" y=\"28\" width=\"8\" height=\"8\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <rect x=\"18\" y=\"42\" width=\"14\" height=\"12\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n    </svg>"
```
