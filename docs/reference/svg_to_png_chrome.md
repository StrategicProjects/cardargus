# Convert SVG to PNG using headless Chrome

Renders an SVG to PNG using headless Chrome via the chromote package.
This method provides superior font rendering compared to
librsvg/ImageMagick, as Chrome properly handles @font-face rules, web
fonts, and CSS features.

## Usage

``` r
svg_to_png_chrome(
  svg_input,
  output_path = NULL,
  dpi = 300,
  background = "transparent",
  load_wait = 0.5
)
```

## Arguments

- svg_input:

  SVG string or path to an SVG file.

- output_path:

  Output path for the PNG file. If NULL, a temp file is used.

- dpi:

  Resolution in dots per inch (default 300). Chrome uses 96 DPI as base,
  so dpi = 300 results in approximately 3.125x scaling.

- background:

  Background color for the HTML page (default "transparent"). Use
  "white", "#FFFFFF", etc. for a solid background.

- load_wait:

  Seconds to wait for page to load (default 0.5). Increase if fonts are
  not rendering correctly.

## Value

Path to the generated PNG file.

## Examples

``` r
svg <- svg_card("FAR", list(), list())
file_name <- tempfile(fileext = ".png")
if (FALSE) { # \dontrun{
if (chrome_available()) {
  png_path <- svg_to_png_chrome(svg, file_name, dpi = 300)
}
} # }
```
