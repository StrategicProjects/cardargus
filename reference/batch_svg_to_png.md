# Batch convert multiple SVG cards to PNG

Convert a list of SVG strings to PNG files in a given directory. Fonts
are embedded automatically for consistent rendering.

## Usage

``` r
batch_svg_to_png(
  svg_list,
  output_dir = ".",
  prefix = "card",
  dpi = 300,
  background = "transparent"
)
```

## Arguments

- svg_list:

  List of SVG strings.

- output_dir:

  Output directory.

- prefix:

  File name prefix.

- dpi:

  Resolution.

- background:

  Background color for PNG output.

## Value

Character vector of output paths.
