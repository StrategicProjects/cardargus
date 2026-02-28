# Convert SVG to multiple formats

Convert an SVG string or file to multiple formats. Supported formats
are:

- `"svg"` - saves the SVG

- `"png"` - rasterizes to PNG via
  [`svg_to_png`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md)

- `"pdf"` - converts to PDF (prefers rsvg)

## Usage

``` r
svg_to_formats(
  svg_input,
  output_base,
  formats = c("svg", "png"),
  dpi = 300,
  background = "transparent"
)
```

## Arguments

- svg_input:

  SVG string or file path.

- output_base:

  Base name for output files (without extension).

- formats:

  Vector of formats to generate ("png", "svg", "pdf").

- dpi:

  Resolution for raster formats.

- background:

  Background color for PNG output.

## Value

Named list with paths to generated files.
