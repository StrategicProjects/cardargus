# Create an Information Card in SVG Format

Generate a complete information card as an SVG with embedded styles,
fonts, badges, logos, and field labels/values.

## Usage

``` r
svg_card(
  title = "FAR",
  badges_data = list(),
  fields = list(),
  bg_color = "#fab255",
  width = 500,
  padding = 20,
  corner_radius = 8,
  font = "Jost",
  title_fontsize = 16,
  title_color = "white",
  label_fontsize = 11,
  value_fontsize = 11,
  label_color = "white",
  value_bg_color = "#f8f8ff",
  value_text_color = "#212529",
  show_house_icon = TRUE,
  logos = list(),
  logos_height = 40,
  bottom_logos = list(),
  bottom_logos_height = 30,
  footer = NULL,
  gap_to_footer = 6,
  footer_row_padding_bottom = 6,
  footer_fontsize = 8,
  footer_color = "white",
  uniform_row_height = TRUE,
  show_viewer = interactive()
)
```

## Arguments

- title:

  Card title (e.g., "FAR", "FNHIS")

- badges_data:

  List of badge data (label, value, color)

- fields:

  List of field rows, each row is a list of fields with label, value,
  and optionally with_icon. The with_icon parameter can be:

  - TRUE - uses the default house icon

  - FALSE or NULL - no icon

  - A character string - path to an SVG file or raw SVG code

- bg_color:

  Background color of the card. Can be a solid color (e.g., "#fab255")
  or a CSS gradient (e.g., "linear-gradient(to right, \#1a5a3a,
  \#2e7d32)" or "linear-gradient(135deg, \#667eea, \#764ba2)").

- width:

  Card width in pixels

- padding:

  Padding inside the card

- corner_radius:

  Corner radius for rounded corners

- font:

  Font family

- title_fontsize:

  Title font size

- title_color:

  Color for the card title (default "white")

- label_fontsize:

  Label font size

- value_fontsize:

  Value font size

- label_color:

  Color for field labels (default "white")

- value_bg_color:

  Background color for value boxes

- value_text_color:

  Text color for values

- show_house_icon:

  Show house icon next to empreendimento

- logos:

  Character vector of logo file paths or SVG strings for top right. Use
  `get_svg_path("filename.svg")` for bundled logos, or any local path.

- logos_height:

  Height for top-right logos (default 40)

- bottom_logos:

  Character vector of logo file paths or SVG strings for bottom left.

- bottom_logos_height:

  Height for bottom-left logos (default 30)

- footer:

  Footer text (e.g., update timestamp)

- gap_to_footer:

  Distance (px) between the last info block and the footer row.

- footer_row_padding_bottom:

  Bottom padding (px) under the footer row.

- footer_fontsize:

  Footer font size

- footer_color:

  Color for footer text (default "white")

- uniform_row_height:

  If TRUE, keep the height inside a row.

- show_viewer:

  If TRUE (and interactive), preview the SVG in the Viewer.

## Value

SVG string

## Examples

``` r
# With default house icon
fields <- list(
  list(
    list(label = "Empreendimento", value = "CAIARA II", with_icon = TRUE)
  )
)

# With custom icon
custom_icon <- '<svg width="50" height="50"><circle cx="25" cy="25" r="20" fill="white"/></svg>'
fields <- list(
  list(
    list(label = "Projeto", value = "Meu Projeto", with_icon = custom_icon)
  )
)

badges <- list(
  list(label = "UH", value = "192"),
  list(label = "Recurso Federal", value = "36,4 milhões")
)

# With file paths for logos
svg_card("FAR", badges, fields, 
         bg_color = "#fab255",
         logos = c("path/to/logo1.svg", "path/to/logo2.svg"),
         bottom_logos = c("path/to/gov_logo.svg"))
#> [1] "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"500\" height=\"207\" viewBox=\"0 0 500 207\">\n  \n    <defs>\n      <style>\n        @import url(\"https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&amp;display=swap\");\n        .card-title { font-family: \"Jost\", sans-serif; font-weight: 700; font-size: 16px; fill: white; }\n        .field-label { font-family: \"Jost\", sans-serif; font-weight: 600; font-size: 11px; fill: white; }\n        .field-value { font-family: \"Jost\", sans-serif; font-weight: 400; font-size: 11px; fill: #212529; }\n        .footer-text { font-family: \"Jost\", sans-serif; font-style: italic; font-size: 8px; fill: white; opacity: 0.8; }\n      </style>\n      <clipPath id=\"card-clip-b910318e\">\n        <rect width=\"500\" rx=\"8\" ry=\"8\"/>\n      </clipPath>\n      \n    </defs>\n  <!-- Background -->\n  <rect width=\"500\" height=\"207\" rx=\"8\" fill=\"#fab255\"/>\n  <!-- Content -->\n  <text x=\"20\" y=\"40.0\" class=\"card-title\" dominant-baseline=\"middle\">FAR</text>\n  <g transform=\"translate(20.0, 75.0)\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"sf9ea59d7_1\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"rf9ea59d7_1\">\n        <rect width=\"61\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#rf9ea59d7_1)\">\n        <rect width=\"61\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"26\" width=\"35\" height=\"18\" fill=\"white\"/>\n        <rect width=\"61\" height=\"18\" fill=\"url(#sf9ea59d7_1)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"14.2\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"13.2\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"44.8\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"43.8\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </g>\n  <g transform=\"translate(85.0, 75.0)\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"s1154a9bb_2\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r1154a9bb_2\">\n        <rect width=\"184\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r1154a9bb_2)\">\n        <rect width=\"184\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"99\" width=\"85\" height=\"18\" fill=\"white\"/>\n        <rect width=\"184\" height=\"18\" fill=\"url(#s1154a9bb_2)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"50.5\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"49.5\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"142.6\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"141.6\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </g>\n  <g transform=\"translate(20.0, 105.5)\"><svg width=\"50\" height=\"50\"><circle cx=\"25\" cy=\"25\" r=\"20\" fill=\"white\"/></svg></g>\n  <text x=\"85.0\" y=\"118.9\" class=\"field-label\">Projeto</text>\n  <rect x=\"85.0\" y=\"122.9\" width=\"395.0\" height=\"30.3\" rx=\"4\" fill=\"#f8f8ff\" stroke=\"#dee2e6\" stroke-width=\"1\"/>\n  <text x=\"95.0\" y=\"140.2\" class=\"field-value\">Meu Projeto</text>\n  <g transform=\"translate(450, 171)\">path/to/gov_logo.svg</g>\n  <!-- Top-right logos -->\n  <g transform=\"translate(390, 20)\">path/to/logo1.svg</g>\n<g transform=\"translate(440, 20)\">path/to/logo2.svg</g>\n</svg>"

# With gradient background
svg_card("MCMV", badges, fields,
         bg_color = "linear-gradient(to right, #1a5a3a, #2e7d32)")
#> [1] "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"500\" height=\"164\" viewBox=\"0 0 500 164\">\n  \n    <defs>\n      <style>\n        @import url(\"https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&amp;display=swap\");\n        .card-title { font-family: \"Jost\", sans-serif; font-weight: 700; font-size: 16px; fill: white; }\n        .field-label { font-family: \"Jost\", sans-serif; font-weight: 600; font-size: 11px; fill: white; }\n        .field-value { font-family: \"Jost\", sans-serif; font-weight: 400; font-size: 11px; fill: #212529; }\n        .footer-text { font-family: \"Jost\", sans-serif; font-style: italic; font-size: 8px; fill: white; opacity: 0.8; }\n      </style>\n      <clipPath id=\"card-clip-2c292737\">\n        <rect width=\"500\" rx=\"8\" ry=\"8\"/>\n      </clipPath>\n      <linearGradient id=\"bg_grad_2c292737\" x1=\"0%\" y1=\"0%\" x2=\"100%\" y2=\"0%\"><stop offset=\"0%\" stop-color=\"#1a5a3a\"/><stop offset=\"100%\" stop-color=\"#2e7d32\"/></linearGradient>\n    </defs>\n  <!-- Background -->\n  <rect width=\"500\" height=\"164\" rx=\"8\" fill=\"url(#bg_grad_2c292737)\"/>\n  <!-- Content -->\n  <text x=\"20\" y=\"36.0\" class=\"card-title\" dominant-baseline=\"alphabetic\">MCMV</text>\n  <g transform=\"translate(20.0, 54.2)\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"se4386841_1\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"re4386841_1\">\n        <rect width=\"61\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#re4386841_1)\">\n        <rect width=\"61\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"26\" width=\"35\" height=\"18\" fill=\"white\"/>\n        <rect width=\"61\" height=\"18\" fill=\"url(#se4386841_1)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"14.2\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"13.2\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"44.8\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"43.8\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </g>\n  <g transform=\"translate(85.0, 54.2)\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"s5d351653_2\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r5d351653_2\">\n        <rect width=\"184\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r5d351653_2)\">\n        <rect width=\"184\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"99\" width=\"85\" height=\"18\" fill=\"white\"/>\n        <rect width=\"184\" height=\"18\" fill=\"url(#s5d351653_2)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"50.5\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"49.5\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"142.6\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"141.6\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </g>\n  <g transform=\"translate(20.0, 84.7)\"><svg width=\"50\" height=\"50\"><circle cx=\"25\" cy=\"25\" r=\"20\" fill=\"white\"/></svg></g>\n  <text x=\"85.0\" y=\"98.1\" class=\"field-label\">Projeto</text>\n  <rect x=\"85.0\" y=\"102.1\" width=\"395.0\" height=\"30.3\" rx=\"4\" fill=\"#f8f8ff\" stroke=\"#dee2e6\" stroke-width=\"1\"/>\n  <text x=\"95.0\" y=\"119.4\" class=\"field-value\">Meu Projeto</text>\n  <!-- Top-right logos -->\n  \n</svg>"

# Diagonal gradient
svg_card("Programa", badges, fields,
         bg_color = "linear-gradient(135deg, #667eea, #764ba2)")
#> [1] "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"500\" height=\"164\" viewBox=\"0 0 500 164\">\n  \n    <defs>\n      <style>\n        @import url(\"https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&amp;display=swap\");\n        .card-title { font-family: \"Jost\", sans-serif; font-weight: 700; font-size: 16px; fill: white; }\n        .field-label { font-family: \"Jost\", sans-serif; font-weight: 600; font-size: 11px; fill: white; }\n        .field-value { font-family: \"Jost\", sans-serif; font-weight: 400; font-size: 11px; fill: #212529; }\n        .footer-text { font-family: \"Jost\", sans-serif; font-style: italic; font-size: 8px; fill: white; opacity: 0.8; }\n      </style>\n      <clipPath id=\"card-clip-8c448e90\">\n        <rect width=\"500\" rx=\"8\" ry=\"8\"/>\n      </clipPath>\n      <linearGradient id=\"bg_grad_8c448e90\" x1=\"15%\" y1=\"15%\" x2=\"85%\" y2=\"85%\"><stop offset=\"0%\" stop-color=\"#667eea\"/><stop offset=\"100%\" stop-color=\"#764ba2\"/></linearGradient>\n    </defs>\n  <!-- Background -->\n  <rect width=\"500\" height=\"164\" rx=\"8\" fill=\"url(#bg_grad_8c448e90)\"/>\n  <!-- Content -->\n  <text x=\"20\" y=\"36.0\" class=\"card-title\" dominant-baseline=\"alphabetic\">Programa</text>\n  <g transform=\"translate(20.0, 54.2)\">\n      <title>UH: 192</title>\n      \n      <linearGradient id=\"s94529cce_1\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"r94529cce_1\">\n        <rect width=\"61\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#r94529cce_1)\">\n        <rect width=\"61\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"26\" width=\"35\" height=\"18\" fill=\"white\"/>\n        <rect width=\"61\" height=\"18\" fill=\"url(#s94529cce_1)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"14.2\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">UH</text>\n        <text x=\"13.2\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">UH</text>\n        <text x=\"44.8\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">192</text>\n        <text x=\"43.8\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">192</text>\n      </g>\n    </g>\n  <g transform=\"translate(85.0, 54.2)\">\n      <title>Recurso Federal: 36,4 milhões</title>\n      \n      <linearGradient id=\"sc35183f0_2\" x2=\"0\" y2=\"100%\">\n        <stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/>\n        <stop offset=\"1\" stop-opacity=\".1\"/>\n      </linearGradient>\n      <clipPath id=\"rc35183f0_2\">\n        <rect width=\"184\" height=\"18\" rx=\"3\" ry=\"3\" fill=\"#fff\"/>\n      </clipPath>\n      <g clip-path=\"url(#rc35183f0_2)\">\n        <rect width=\"184\" height=\"18\" fill=\"#555\"/>\n        <rect x=\"99\" width=\"85\" height=\"18\" fill=\"white\"/>\n        <rect width=\"184\" height=\"18\" fill=\"url(#sc35183f0_2)\"/>\n      </g>\n      <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Jost\" font-size=\"11\" dominant-baseline=\"middle\">\n        <text x=\"50.5\" y=\"10.8\" fill=\"#010101\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill-opacity=\".3\">Recurso Federal</text>\n        <text x=\"49.5\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#fff\">Recurso Federal</text>\n        <text x=\"142.6\" y=\"10.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#ccc\" fill-opacity=\".3\">36,4 milhões</text>\n        <text x=\"141.6\" y=\"9.8\" text-rendering=\"geometricPrecision\" alignment-baseline=\"middle\" fill=\"#333\">36,4 milhões</text>\n      </g>\n    </g>\n  <g transform=\"translate(20.0, 84.7)\"><svg width=\"50\" height=\"50\"><circle cx=\"25\" cy=\"25\" r=\"20\" fill=\"white\"/></svg></g>\n  <text x=\"85.0\" y=\"98.1\" class=\"field-label\">Projeto</text>\n  <rect x=\"85.0\" y=\"102.1\" width=\"395.0\" height=\"30.3\" rx=\"4\" fill=\"#f8f8ff\" stroke=\"#dee2e6\" stroke-width=\"1\"/>\n  <text x=\"95.0\" y=\"119.4\" class=\"field-value\">Meu Projeto</text>\n  <!-- Top-right logos -->\n  \n</svg>"
```
