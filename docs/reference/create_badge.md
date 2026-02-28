# Create an SVG Badge

Generate a badge similar to shields.io style with label and value. Both
sides have properly rounded corners.

## Usage

``` r
create_badge(
  label,
  value,
  color,
  font = "Jost",
  style = "margin:2px;",
  fontsize = 11,
  horiz_padding = 5,
  extra_right_pad = 2,
  class = "",
  shadow_offset = 2,
  corner_radius = 3,
  height = NULL,
  as_string = TRUE
)
```

## Arguments

- label:

  Label text (left side)

- value:

  Value text (right side)

- color:

  Background color for value area

- font:

  Font family name

- style:

  CSS style string

- fontsize:

  Font size in pixels

- horiz_padding:

  Horizontal padding

- extra_right_pad:

  Extra padding on right side

- class:

  CSS class

- shadow_offset:

  Shadow offset in pixels

- corner_radius:

  Corner radius for rounded rectangle

- height:

  Minimum height (optional)

- as_string:

  Return as character string

## Value

SVG string

## Examples

``` r
create_badge("UH", "192", "white")
#> [1] "<svg class=\"\" style=\"margin:2px;\" xmlns=\"http://www.w3.org/2000/svg\" width=\"56\" height=\"16\" role=\"img\" aria-label=\"UH: 192\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"s7e67f023\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r7e67f023\">\n        <rect width=\"56\" height=\"16\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r7e67f023)\">\n        <rect width=\"56\" height=\"16\" fill=\"#555\"/>\n        <rect x=\"25\" width=\"32\" height=\"16\" fill=\"white\"/>\n        <rect width=\"56\" height=\"16\" fill=\"url(#s7e67f023)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"14.4\" y=\"10.6\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"12.4\" y=\"8.6\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"42.5\" y=\"10.6\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"40.5\" y=\"8.6\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </svg>"
create_badge("Recurso Federal", "36,4 milhões", "#4CAF50")
#> [1] "<svg class=\"\" style=\"margin:2px;\" xmlns=\"http://www.w3.org/2000/svg\" width=\"160\" height=\"21\" role=\"img\" aria-label=\"Recurso Federal: 36,4 milhões\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"s31fef764\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r31fef764\">\n        <rect width=\"160\" height=\"21\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r31fef764)\">\n        <rect width=\"160\" height=\"21\" fill=\"#555\"/>\n        <rect x=\"85\" width=\"75\" height=\"21\" fill=\"#4CAF50\"/>\n        <rect width=\"160\" height=\"21\" fill=\"url(#s31fef764)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"44.5\" y=\"13.5\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"42.5\" y=\"11.5\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"124.7\" y=\"13.5\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"122.7\" y=\"11.5\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </svg>"
```
