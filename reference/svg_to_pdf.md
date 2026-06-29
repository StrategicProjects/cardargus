# Convert SVG to PDF

Convert an SVG string or SVG file path to a **vector** PDF. As with
[`svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md),
the SVG is sanitized and the required WOFF2 fonts are embedded
(downloaded on demand into a user cache) so text renders consistently.
Conversion uses rsvg
([`rsvg::rsvg_pdf()`](https://docs.ropensci.org/rsvg/reference/rsvg.html)),
preserving vector text.

For headless-Chrome rendering (often best for web fonts), see
[`svg_to_pdf_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf_chrome.md).

## Usage

``` r
svg_to_pdf(svg_input, output_path = NULL, width = NULL, height = NULL)
```

## Arguments

- svg_input:

  SVG string or path to an SVG file.

- output_path:

  Output path for the PDF file (optional; a temp file is used if NULL).

- width:

  Output width in pixels (NULL to infer from the SVG).

- height:

  Output height in pixels (NULL to infer from the SVG).

## Value

Path to the generated PDF file.

## Examples

``` r
if (requireNamespace("rsvg", quietly = TRUE)) {
  svg <- svg_card("FAR", list(), list())
  file_name <- tempfile(fileext = ".pdf")
  pdf_path <- svg_to_pdf(svg, file_name)
}
```
