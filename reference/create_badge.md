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
#> [1] "<svg class=\"\" style=\"margin:2px;\" xmlns=\"http://www.w3.org/2000/svg\" width=\"61\" height=\"17\" role=\"img\" aria-label=\"UH: 192\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"s8036e173\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r8036e173\">\n        <rect width=\"61\" height=\"17\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r8036e173)\">\n        <rect width=\"61\" height=\"17\" fill=\"#555\"/>\n        <rect x=\"26\" width=\"35\" height=\"17\" fill=\"white\"/>\n        <rect width=\"61\" height=\"17\" fill=\"url(#s8036e173)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"15.2\" y=\"11.2\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"13.2\" y=\"9.2\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"45.8\" y=\"11.2\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"43.8\" y=\"9.2\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </svg>"
create_badge("Recurso Federal", "36,4 milhões", "#4CAF50")
#> [1] "<svg class=\"\" style=\"margin:2px;\" xmlns=\"http://www.w3.org/2000/svg\" width=\"184\" height=\"20\" role=\"img\" aria-label=\"Recurso Federal: 36,4 milhões\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"s56882243\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r56882243\">\n        <rect width=\"184\" height=\"20\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r56882243)\">\n        <rect width=\"184\" height=\"20\" fill=\"#555\"/>\n        <rect x=\"99\" width=\"85\" height=\"20\" fill=\"#4CAF50\"/>\n        <rect width=\"184\" height=\"20\" fill=\"url(#s56882243)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"51.5\" y=\"12.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"49.5\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"143.6\" y=\"12.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"141.6\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </svg>"
```
