# Prepare SVG for rasterization (sanitize + embed fonts)

Removes Google Fonts @import rules (not supported by librsvg), sanitizes
editor metadata (handled by sanitize_svg_for_raster()), then embeds
fonts referenced by the SVG into @font-face blocks.

## Usage

``` r
prepare_svg_for_raster(svg_content, subset_fonts = FALSE)
```

## Arguments

- svg_content:

  Character SVG.

- subset_fonts:

  If TRUE, embed a glyph *subset* covering only the characters that
  actually appear in the SVG text, instead of the full font (much
  smaller output). Subsets are downloaded from the Google Fonts CSS API
  and cached per character set; when a subset cannot be obtained, the
  full font is embedded as fallback.

## Value

A sanitized SVG with embedded WOFF2 fonts.
