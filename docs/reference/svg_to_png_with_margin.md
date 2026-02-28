# Convert SVG to PNG with optional margin and background

Creates a PNG with extra margin around the card. Fonts are embedded
before rasterization for consistent appearance.

## Usage

``` r
svg_to_png_with_margin(
  svg_input,
  output_path = NULL,
  margin = 20,
  margin_color = "transparent",
  dpi = 300,
  background = "transparent"
)
```

## Arguments

- svg_input:

  SVG string or path to SVG file.

- output_path:

  Output path for PNG file (optional; a temp file is used if NULL).

- margin:

  Margin in pixels to add around the card.

- margin_color:

  Color of the margin area (default transparent).

- dpi:

  Resolution in dots per inch.

- background:

  Background color for the card rasterization (default transparent).

## Value

Path to the generated PNG file.
