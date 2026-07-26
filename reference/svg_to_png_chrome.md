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
  load_wait = 0,
  timeout = 10
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

  Extra seconds to wait after the page reports ready (default 0).
  Readiness (fonts loaded, layout painted) is detected automatically;
  this is only a safety margin for edge cases.

- timeout:

  Maximum seconds to wait for page readiness (default 10).

## Value

Path to the generated PNG file.

## Details

The Chrome session is kept alive and reused across calls (with an
automatic health check), so repeated conversions avoid the session
startup cost. The screenshot is only captured after
`document.fonts.ready` resolves, ensuring web fonts are fully rendered.

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
