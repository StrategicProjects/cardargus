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
  load_wait = 0.5
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

  Seconds to wait for page to load (default 0.5).

## Value

Path to the generated PDF file.

## Examples

``` r
if (FALSE) { # \dontrun{
svg <- svg_card("FAR", list(), list())
if (chrome_available()) {
  pdf_path <- svg_to_pdf_chrome(svg, tempfile(fileext = ".pdf"))
}
} # }
```
