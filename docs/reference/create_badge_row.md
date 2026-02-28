# Create a row of SVG badges with uniform height

Generate multiple badges arranged horizontally with the same height.

## Usage

``` r
create_badge_row(
  badges_data,
  default_color = "white",
  spacing = 4,
  font = "Jost",
  fontsize = 10,
  uniform_height = TRUE
)
```

## Arguments

- badges_data:

  A list of lists, each containing label, value, and optionally color

- default_color:

  Default color for badges

- spacing:

  Spacing between badges

- font:

  Font family

- fontsize:

  Font size

- uniform_height:

  Force all badges to have the same height (default TRUE)

## Value

SVG string containing all badges

## Examples

``` r
badges <- list(
  list(label = "UH", value = "192"),
  list(label = "Recurso Federal", value = "36,4 milhões"),
  list(label = "Contrapartida", value = "0,0")
)
create_badge_row(badges, default_color = "white")
#> [1] "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"306\" height=\"20\"><g transform=\"translate(0.0, 0)\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"s8d1ac602\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r8d1ac602\">\n        <rect width=\"53\" height=\"20\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r8d1ac602)\">\n        <rect width=\"53\" height=\"20\" fill=\"#555\"/>\n        <rect x=\"23\" width=\"30\" height=\"20\" fill=\"white\"/>\n        <rect width=\"53\" height=\"20\" fill=\"url(#s8d1ac602)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"10\" dominant-baseline=\"middle\">\n        <text x=\"13.7\" y=\"13.0\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"11.7\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"40.4\" y=\"13.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"38.4\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </g><g transform=\"translate(57.0, 0)\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"sfd35a035\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"rfd35a035\">\n        <rect width=\"148\" height=\"20\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#rfd35a035)\">\n        <rect width=\"148\" height=\"20\" fill=\"#555\"/>\n        <rect x=\"78\" width=\"70\" height=\"20\" fill=\"white\"/>\n        <rect width=\"148\" height=\"20\" fill=\"url(#sfd35a035)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"10\" dominant-baseline=\"middle\">\n        <text x=\"41.1\" y=\"13.0\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"39.1\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"115.1\" y=\"13.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"113.1\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </g><g transform=\"translate(209.0, 0)\">\n      <title>Contrapartida: 0,0</title>\n      \n      <linearGradient id=\"s207f9f17\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r207f9f17\">\n        <rect width=\"97\" height=\"20\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r207f9f17)\">\n        <rect width=\"97\" height=\"20\" fill=\"#555\"/>\n        <rect x=\"68\" width=\"29\" height=\"20\" fill=\"white\"/>\n        <rect width=\"97\" height=\"20\" fill=\"url(#s207f9f17)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"10\" dominant-baseline=\"middle\">\n        <text x=\"35.8\" y=\"13.0\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Contrapartida</text>\n        <text x=\"33.8\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Contrapartida</text>\n        <text x=\"84.2\" y=\"13.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">0,0</text>\n        <text x=\"82.2\" y=\"11.0\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">0,0</text>\n      </g>\n    </g></svg>"
```
