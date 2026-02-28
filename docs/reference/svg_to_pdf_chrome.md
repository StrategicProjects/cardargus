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
  timeout = 30
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

- timeout:

  Maximum time in seconds to wait for page load (default 30).

## Value

Path to the generated PDF file.

## Examples

``` r
if (FALSE)  # It requires an external Chrome/Chromium installation 
svg <- svg_card("FAR", list(), list())
if (chrome_available()) {
  pdf_path <- svg_to_pdf_chrome(svg, tempfile(fileext = ".pdf"))
}
#> Error in as.character(svg_input): cannot coerce type 'closure' to vector of type 'character'
 # \dontrun{}
```
