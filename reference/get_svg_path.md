# Get path to a bundled SVG file

Returns the full path to a SVG file bundled with the package.

## Usage

``` r
get_svg_path(filename, height = NULL, width = NULL)
```

## Arguments

- filename:

  Name of the SVG file (e.g., "morar_bem.svg")

- height:

  Optional target height (px). If provided, returns the SVG content
  resized for embedding instead of the file path.

- width:

  Optional target width (px). Only used when returning resized SVG
  content.

## Value

If `height` and `width` are both NULL, returns the full file path.
Otherwise returns the resized SVG content (character string).
