# Build an HTML document wrapping an SVG

Returns the HTML as an in-memory string (injected into Chrome via
`Page.setDocumentContent`), avoiding temp-file I/O and `file://` path
issues on Windows.

## Usage

``` r
build_svg_html(
  svg_string,
  width_px = NULL,
  height_px = NULL,
  background = "transparent"
)
```

## Arguments

- svg_string:

  SVG content as character string.

- width_px:

  Width in pixels. If NULL, extracted from SVG.

- height_px:

  Height in pixels. If NULL, extracted from SVG.

- background:

  Background color (default "transparent").

## Value

A list with html, width, and height.
