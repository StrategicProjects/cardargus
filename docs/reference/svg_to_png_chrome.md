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
  timeout = 30
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

- timeout:

  Maximum time in seconds to wait for page load (default 30).

## Value

Path to the generated PNG file.

## Examples

``` r
svg <- svg_card("FAR", list(), list())
file_name <- tempfile(fileext = ".png")
# High-quality PNG with Chrome rendering
if (FALSE)  # Requires an external Chrome/Chromium installation.
if (chrome_available()) {
  png_path <- svg_to_png_chrome(svg, file_name, dpi = 300)
}
 # \dontrun{}
```
