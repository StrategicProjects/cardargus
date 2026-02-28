# Convert SVG to PNG

Convert an SVG string or SVG file path to a high-quality PNG image. The
function sanitizes the SVG and embeds required WOFF2 fonts (downloaded
on demand into a user cache) to ensure consistent font rendering.

**Important note about DPI**: `rsvg` rasterizes primarily based on pixel
dimensions. To make DPI matter, this function scales output pixel size
by `(dpi / 96)` when `width` / `height` are not explicitly provided.

## Usage

``` r
svg_to_png(
  svg_input,
  output_path = NULL,
  width = NULL,
  height = NULL,
  dpi = 300,
  background = "transparent"
)
```

## Arguments

- svg_input:

  SVG string or path to an SVG file.

- output_path:

  Output path for the PNG file (optional; a temp file is used if NULL).

- width:

  Output width in pixels (NULL to infer from SVG and scale by DPI).

- height:

  Output height in pixels (NULL to infer from SVG and scale by DPI).

- dpi:

  Resolution in dots per inch (default 300 for high quality).

- background:

  Background color. Use "transparent" or "none" for transparency
  (default), or specify a color like "white", "#FFFFFF", etc.

## Value

Path to the generated PNG file.

## Examples

``` r
svg <- svg_card("FAR", list(), list())
file_name <- tempfile(fileext = ".png")
png_path <- svg_to_png(svg, file_name, dpi = 300)
png_path <- svg_to_png(svg, file_name, dpi = 300, background = "white")
```
