# Construction Icon SVG

Generate a construction/crane icon SVG.

## Usage

``` r
icon_construction(
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
icon_construction(50, 56)
#> [1] "<svg width=\"50\" height=\"56\" viewBox=\"0 0 50 56\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n      <!-- Base -->\n      <rect x=\"20\" y=\"48\" width=\"10\" height=\"6\" stroke=\"white\" stroke-width=\"2\" fill=\"none\"/>\n      <!-- Tower -->\n      <line x1=\"25\" y1=\"48\" x2=\"25\" y2=\"8\" stroke=\"white\" stroke-width=\"2\"/>\n      <!-- Arm -->\n      <line x1=\"25\" y1=\"8\" x2=\"45\" y2=\"8\" stroke=\"white\" stroke-width=\"2\"/>\n      <!-- Cable -->\n      <line x1=\"40\" y1=\"8\" x2=\"40\" y2=\"25\" stroke=\"white\" stroke-width=\"1\"/>\n      <!-- Hook -->\n      <path d=\"M38 25 L42 25 L42 30 Q40 33 38 30 Z\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <!-- Counter weight -->\n      <line x1=\"25\" y1=\"8\" x2=\"10\" y2=\"8\" stroke=\"white\" stroke-width=\"2\"/>\n      <rect x=\"5\" y=\"8\" width=\"8\" height=\"6\" stroke=\"white\" stroke-width=\"1\" fill=\"none\"/>\n      <!-- Support cables -->\n      <line x1=\"25\" y1=\"15\" x2=\"10\" y2=\"8\" stroke=\"white\" stroke-width=\"1\"/>\n      <line x1=\"25\" y1=\"15\" x2=\"40\" y2=\"8\" stroke=\"white\" stroke-width=\"1\"/>\n    </svg>"
```
