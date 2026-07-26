# Convert SVG to PDF using headless Chrome

Renders an SVG to PDF using headless Chrome via the chromote package.
This method produces vector PDFs with perfect font rendering.

## Usage

``` r
svg_to_pdf_chrome(
  svg_input,
  output_path,
  background = "transparent",
  print_background = TRUE,
  load_wait = 0,
  timeout = 10
)
```

## Arguments

- svg_input:

  SVG string or path to an SVG file.

- output_path:

  Output path for the PDF file.

- background:

  Background color for the HTML page (default "transparent").

- print_background:

  Whether to include CSS backgrounds in PDF (default TRUE).

- load_wait:

  Extra seconds to wait after the page reports ready (default 0).
  Readiness (fonts loaded, layout painted) is detected automatically;
  this is only a safety margin for edge cases.

- timeout:

  Maximum seconds to wait for page readiness (default 10).

## Value

Path to the generated PDF file.

## Details

The Chrome session is kept alive and reused across calls (with an
automatic health check). The PDF is only generated after
`document.fonts.ready` resolves, ensuring web fonts are fully rendered.

## Examples

``` r
if (FALSE) { # \dontrun{
svg <- svg_card("FAR", list(), list())
if (chrome_available()) {
  pdf_path <- svg_to_pdf_chrome(svg, tempfile(fileext = ".pdf"))
}
} # }
```
