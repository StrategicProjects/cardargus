# Prepare SVG for rasterization (sanitize + embed fonts)

Removes Google Fonts @import rules (not supported by librsvg), sanitizes
editor metadata (handled by sanitize_svg_for_raster()), then embeds
fonts referenced by the SVG into @font-face blocks.

## Usage

``` r
prepare_svg_for_raster(svg_content)
```

## Arguments

- svg_content:

  Character SVG.

## Value

A sanitized SVG with embedded WOFF2 fonts.
