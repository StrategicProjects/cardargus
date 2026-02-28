# Dollar/Money Icon SVG

Generate a dollar/money icon SVG.

## Usage

``` r
icon_money(
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
icon_money(50, 56)
#> [1] "<svg width=\"50\" height=\"56\" viewBox=\"0 0 50 56\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n      <circle cx=\"25\" cy=\"28\" r=\"20\" stroke=\"white\" stroke-width=\"2\" fill=\"none\"/>\n      <text x=\"25\" y=\"35\" font-family=\"Arial, sans-serif\" font-size=\"24\" font-weight=\"bold\" \n            fill=\"white\" text-anchor=\"middle\">$</text>\n    </svg>"
```
